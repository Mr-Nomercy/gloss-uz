import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'auth_provider.dart';

class AdminOrder {
  final String id;
  final String orderNumber;
  final String clientName;
  final String clientPhone;
  final String? providerName;
  final String? courierName;
  final String type;
  final String status;
  final String paymentStatus;
  final double subtotal;
  final double discount;
  final double deliveryFee;
  final double platformFee;
  final double total;
  final String? addressLine;
  final DateTime? scheduledAt;
  final DateTime createdAt;

  const AdminOrder({
    required this.id,
    required this.orderNumber,
    required this.clientName,
    required this.clientPhone,
    this.providerName,
    this.courierName,
    required this.type,
    required this.status,
    required this.paymentStatus,
    this.subtotal = 0,
    this.discount = 0,
    this.deliveryFee = 0,
    this.platformFee = 0,
    this.total = 0,
    this.addressLine,
    this.scheduledAt,
    required this.createdAt,
  });

  factory AdminOrder.fromJson(Map<String, dynamic> json) => AdminOrder(
        id: json['id'] as String,
        orderNumber: json['orderNumber'] as String,
        clientName: json['clientName'] as String,
        clientPhone: json['clientPhone'] as String,
        providerName: json['providerName'] as String?,
        courierName: json['courierName'] as String?,
        type: json['type'] as String,
        status: json['status'] as String,
        paymentStatus: json['paymentStatus'] as String,
        subtotal: (json['subtotal'] as num?)?.toDouble() ?? 0,
        discount: (json['discount'] as num?)?.toDouble() ?? 0,
        deliveryFee: (json['deliveryFee'] as num?)?.toDouble() ?? 0,
        platformFee: (json['platformFee'] as num?)?.toDouble() ?? 0,
        total: (json['total'] as num?)?.toDouble() ?? 0,
        addressLine: json['addressLine'] as String?,
        scheduledAt: json['scheduledAt'] != null
            ? DateTime.parse(json['scheduledAt'] as String)
            : null,
        createdAt: DateTime.parse(json['createdAt'] as String),
      );
}

class OrdersState {
  final List<AdminOrder> orders;
  final AdminOrder? selectedOrder;
  final bool isLoading;
  final bool isLoadingDetail;
  final String? error;
  final String statusFilter;
  final String typeFilter;
  final String searchQuery;

  const OrdersState({
    this.orders = const [],
    this.selectedOrder,
    this.isLoading = false,
    this.isLoadingDetail = false,
    this.error,
    this.statusFilter = 'all',
    this.typeFilter = 'all',
    this.searchQuery = '',
  });

  List<AdminOrder> get filteredOrders {
    var result = orders;
    if (statusFilter != 'all') {
      result = result.where((o) => o.status == statusFilter).toList();
    }
    if (typeFilter != 'all') {
      result = result.where((o) => o.type == typeFilter).toList();
    }
    if (searchQuery.isNotEmpty) {
      final q = searchQuery.toLowerCase();
      result = result.where((o) {
        return o.orderNumber.toLowerCase().contains(q) ||
            o.clientName.toLowerCase().contains(q) ||
            o.clientPhone.contains(q) ||
            (o.providerName?.toLowerCase().contains(q) ?? false);
      }).toList();
    }
    return result;
  }

  OrdersState copyWith({
    List<AdminOrder>? orders,
    AdminOrder? selectedOrder,
    bool? isLoading,
    bool? isLoadingDetail,
    String? error,
    String? statusFilter,
    String? typeFilter,
    String? searchQuery,
  }) {
    return OrdersState(
      orders: orders ?? this.orders,
      selectedOrder: selectedOrder ?? this.selectedOrder,
      isLoading: isLoading ?? this.isLoading,
      isLoadingDetail: isLoadingDetail ?? this.isLoadingDetail,
      error: error,
      statusFilter: statusFilter ?? this.statusFilter,
      typeFilter: typeFilter ?? this.typeFilter,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}

class OrdersNotifier extends StateNotifier<OrdersState> {
  final Dio _dio;

  OrdersNotifier(this._dio) : super(const OrdersState()) {
    loadOrders();
  }

  Future<void> loadOrders() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final response = await _dio.get('/admin/orders');
      final orders = (response.data as List)
          .map((e) =>
              AdminOrder.fromJson(e as Map<String, dynamic>))
          .toList();
      state = state.copyWith(orders: orders, isLoading: false);
    } on DioException catch (e) {
      state = state.copyWith(
          isLoading: false, error: _handleError(e));
    } catch (_) {
      state = state.copyWith(
          isLoading: false, error: 'Xatolik yuz berdi');
    }
  }

  Future<void> loadOrderDetail(String orderId) async {
    state = state.copyWith(isLoadingDetail: true, error: null);
    try {
      final response = await _dio.get('/admin/orders/$orderId');
      final order =
          AdminOrder.fromJson(response.data as Map<String, dynamic>);
      state = state.copyWith(
          selectedOrder: order, isLoadingDetail: false);
    } on DioException catch (e) {
      state = state.copyWith(
          isLoadingDetail: false, error: _handleError(e));
    } catch (_) {
      state = state.copyWith(
          isLoadingDetail: false, error: 'Xatolik yuz berdi');
    }
  }

  void setStatusFilter(String status) {
    state = state.copyWith(statusFilter: status);
  }

  void setTypeFilter(String type) {
    state = state.copyWith(typeFilter: type);
  }

  void setSearch(String query) {
    state = state.copyWith(searchQuery: query);
  }

  void clearError() => state = state.copyWith(error: null);

  String _handleError(DioException e) {
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout) {
      return 'Internetga ulanishda xatolik';
    }
    return 'Xatolik yuz berdi';
  }
}

class OrderStep {
  final String key;
  final String label;
  const OrderStep(this.key, this.label);
}

final ordersProvider =
    StateNotifierProvider<OrdersNotifier, OrdersState>((ref) {
  final dio = ref.watch(dioProvider);
  return OrdersNotifier(dio);
});
