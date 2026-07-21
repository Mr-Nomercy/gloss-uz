import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:models/models.dart';
import 'auth_provider.dart';

class OrderState {
  final List<Order> activeOrders;
  final List<Order> completedOrders;
  final Order? activeOrderDetail;
  final bool isLoading;
  final bool isLoadingDetail;
  final bool isLoadingAction;
  final String? error;

  const OrderState({
    this.activeOrders = const [],
    this.completedOrders = const [],
    this.activeOrderDetail,
    this.isLoading = false,
    this.isLoadingDetail = false,
    this.isLoadingAction = false,
    this.error,
  });

  OrderState copyWith({
    List<Order>? activeOrders,
    List<Order>? completedOrders,
    Order? activeOrderDetail,
    bool? isLoading,
    bool? isLoadingDetail,
    bool? isLoadingAction,
    String? error,
  }) {
    return OrderState(
      activeOrders: activeOrders ?? this.activeOrders,
      completedOrders: completedOrders ?? this.completedOrders,
      activeOrderDetail: activeOrderDetail ?? this.activeOrderDetail,
      isLoading: isLoading ?? this.isLoading,
      isLoadingDetail: isLoadingDetail ?? this.isLoadingDetail,
      isLoadingAction: isLoadingAction ?? this.isLoadingAction,
      error: error,
    );
  }
}

class OrderNotifier extends StateNotifier<OrderState> {
  final Dio _dio;

  OrderNotifier(this._dio) : super(const OrderState()) {
    loadOrders();
  }

  Future<void> loadOrders() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final response = await _dio.get('/courier/orders');
      final data = response.data as Map<String, dynamic>;

      final active = (data['active'] as List? ?? [])
          .map((e) => Order.fromJson(e as Map<String, dynamic>))
          .toList();
      final completed = (data['completed'] as List? ?? [])
          .map((e) => Order.fromJson(e as Map<String, dynamic>))
          .toList();

      state = state.copyWith(
        activeOrders: active,
        completedOrders: completed,
        isLoading: false,
      );
    } on DioException catch (e) {
      state = state.copyWith(isLoading: false, error: _handleError(e));
    } catch (_) {
      state = state.copyWith(isLoading: false, error: 'Xatolik yuz berdi');
    }
  }

  Future<void> loadOrderDetail(String orderId) async {
    state = state.copyWith(isLoadingDetail: true, error: null);
    try {
      final response = await _dio.get('/courier/orders/$orderId');
      final order = Order.fromJson(response.data as Map<String, dynamic>);
      state = state.copyWith(activeOrderDetail: order, isLoadingDetail: false);
    } on DioException catch (e) {
      state = state.copyWith(isLoadingDetail: false, error: _handleError(e));
    } catch (_) {
      state = state.copyWith(isLoadingDetail: false, error: 'Xatolik yuz berdi');
    }
  }

  Future<bool> acceptOrder(String orderId) async {
    state = state.copyWith(isLoadingAction: true, error: null);
    try {
      await _dio.patch('/courier/orders/$orderId/accept');
      state = state.copyWith(isLoadingAction: false);
      await loadOrders();
      return true;
    } on DioException catch (e) {
      state = state.copyWith(isLoadingAction: false, error: _handleError(e));
      return false;
    } catch (_) {
      state = state.copyWith(isLoadingAction: false, error: 'Xatolik yuz berdi');
      return false;
    }
  }

  Future<bool> updateOrderStatus(String orderId, String status) async {
    state = state.copyWith(isLoadingAction: true, error: null);
    try {
      await _dio.patch('/courier/orders/$orderId/status', data: {'status': status});
      state = state.copyWith(isLoadingAction: false);
      await loadOrders();
      if (state.activeOrderDetail?.id == orderId) {
        await loadOrderDetail(orderId);
      }
      return true;
    } on DioException catch (e) {
      state = state.copyWith(isLoadingAction: false, error: _handleError(e));
      return false;
    } catch (_) {
      state = state.copyWith(isLoadingAction: false, error: 'Xatolik yuz berdi');
      return false;
    }
  }

  Future<bool> rejectOrder(String orderId) async {
    state = state.copyWith(isLoadingAction: true, error: null);
    try {
      await _dio.patch('/courier/orders/$orderId/reject');
      state = state.copyWith(isLoadingAction: false);
      await loadOrders();
      return true;
    } on DioException catch (e) {
      state = state.copyWith(isLoadingAction: false, error: _handleError(e));
      return false;
    } catch (_) {
      state = state.copyWith(isLoadingAction: false, error: 'Xatolik yuz berdi');
      return false;
    }
  }

  void clearActiveOrderDetail() {
    state = state.copyWith(activeOrderDetail: null);
  }

  void clearError() {
    state = state.copyWith(error: null);
  }

  String _handleError(DioException e) {
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout) {
      return 'Internetga ulanishda xatolik';
    }
    if (e.response?.statusCode == 401) {
      return 'Sessiya tugadi, qayta kiring';
    }
    if (e.response?.statusCode == 400) {
      final data = e.response?.data;
      if (data is Map && data['message'] != null) {
        return data['message'] as String;
      }
    }
    if (e.response?.statusCode == 409) {
      return 'Bu buyurtma allaqachon qabul qilingan';
    }
    return 'Xatolik yuz berdi';
  }
}

final orderProvider = StateNotifierProvider<OrderNotifier, OrderState>((ref) {
  final dio = ref.watch(dioProvider);
  return OrderNotifier(dio);
});