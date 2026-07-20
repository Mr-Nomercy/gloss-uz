import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:models/models.dart';
import 'auth_provider.dart';

class OrderState {
  final List<Order> orders;
  final Order? activeOrder;
  final bool isLoading;
  final bool isLoadingActive;
  final String? error;

  const OrderState({
    this.orders = const [],
    this.activeOrder,
    this.isLoading = false,
    this.isLoadingActive = false,
    this.error,
  });

  OrderState copyWith({
    List<Order>? orders,
    Order? activeOrder,
    bool? isLoading,
    bool? isLoadingActive,
    String? error,
  }) {
    return OrderState(
      orders: orders ?? this.orders,
      activeOrder: activeOrder ?? this.activeOrder,
      isLoading: isLoading ?? this.isLoading,
      isLoadingActive: isLoadingActive ?? this.isLoadingActive,
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
      final response = await _dio.get('/orders');
      final orders = (response.data as List)
          .map((e) => Order.fromJson(e as Map<String, dynamic>))
          .toList();
      state = state.copyWith(orders: orders, isLoading: false);
    } on DioException catch (e) {
      state = state.copyWith(isLoading: false, error: _handleError(e));
    } catch (_) {
      state = state.copyWith(isLoading: false, error: 'Xatolik yuz berdi');
    }
  }

  Future<void> loadOrderDetail(String orderId) async {
    state = state.copyWith(isLoadingActive: true, error: null);
    try {
      final response = await _dio.get('/orders/$orderId');
      final order = Order.fromJson(response.data as Map<String, dynamic>);
      state = state.copyWith(activeOrder: order, isLoadingActive: false);
    } on DioException catch (e) {
      state = state.copyWith(isLoadingActive: false, error: _handleError(e));
    } catch (_) {
      state = state.copyWith(isLoadingActive: false, error: 'Xatolik yuz berdi');
    }
  }

  Future<bool> cancelOrder(String orderId, String reason) async {
    state = state.copyWith(isLoadingActive: true, error: null);
    try {
      await _dio.patch('/orders/$orderId/cancel', data: {'reason': reason});
      state = state.copyWith(isLoadingActive: false);
      return true;
    } on DioException catch (e) {
      state = state.copyWith(isLoadingActive: false, error: _handleError(e));
      return false;
    } catch (_) {
      state = state.copyWith(isLoadingActive: false, error: 'Xatolik yuz berdi');
      return false;
    }
  }

  Future<bool> rateOrder(String orderId, Map<String, dynamic> rating) async {
    try {
      await _dio.post('/orders/$orderId/rate', data: rating);
      return true;
    } on DioException {
      return false;
    } catch (_) {
      return false;
    }
  }

  void clearActiveOrder() {
    state = state.copyWith(activeOrder: null);
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
    return 'Xatolik yuz berdi';
  }
}

final orderProvider = StateNotifierProvider<OrderNotifier, OrderState>((ref) {
  final dio = ref.watch(dioProvider);
  return OrderNotifier(dio);
});