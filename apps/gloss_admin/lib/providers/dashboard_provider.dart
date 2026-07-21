import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'auth_provider.dart';

class DashboardStats {
  final double totalRevenue;
  final int todayOrders;
  final int activeProviders;
  final int totalUsers;
  final double totalCommission;
  final List<ChartDataPoint> weeklyRevenue;
  final List<ChartDataPoint> weeklyOrders;
  final List<RecentOrder> recentOrders;

  const DashboardStats({
    this.totalRevenue = 0,
    this.todayOrders = 0,
    this.activeProviders = 0,
    this.totalUsers = 0,
    this.totalCommission = 0,
    this.weeklyRevenue = const [],
    this.weeklyOrders = const [],
    this.recentOrders = const [],
  });

  factory DashboardStats.fromJson(Map<String, dynamic> json) => DashboardStats(
        totalRevenue: (json['totalRevenue'] as num?)?.toDouble() ?? 0,
        todayOrders: (json['todayOrders'] as num?)?.toInt() ?? 0,
        activeProviders: (json['activeProviders'] as num?)?.toInt() ?? 0,
        totalUsers: (json['totalUsers'] as num?)?.toInt() ?? 0,
        totalCommission: (json['totalCommission'] as num?)?.toDouble() ?? 0,
        weeklyRevenue: (json['weeklyRevenue'] as List?)
                ?.map((e) =>
                    ChartDataPoint.fromJson(e as Map<String, dynamic>))
                .toList() ??
            [],
        weeklyOrders: (json['weeklyOrders'] as List?)
                ?.map((e) =>
                    ChartDataPoint.fromJson(e as Map<String, dynamic>))
                .toList() ??
            [],
        recentOrders: (json['recentOrders'] as List?)
                ?.map((e) =>
                    RecentOrder.fromJson(e as Map<String, dynamic>))
                .toList() ??
            [],
      );
}

class ChartDataPoint {
  final String label;
  final double value;
  const ChartDataPoint({required this.label, required this.value});

  factory ChartDataPoint.fromJson(Map<String, dynamic> json) =>
      ChartDataPoint(
        label: json['label'] as String,
        value: (json['value'] as num).toDouble(),
      );
}

class RecentOrder {
  final String id;
  final String orderNumber;
  final String clientName;
  final double amount;
  final String status;
  final String type;
  final DateTime createdAt;

  const RecentOrder({
    required this.id,
    required this.orderNumber,
    required this.clientName,
    required this.amount,
    required this.status,
    required this.type,
    required this.createdAt,
  });

  factory RecentOrder.fromJson(Map<String, dynamic> json) => RecentOrder(
        id: json['id'] as String,
        orderNumber: json['orderNumber'] as String,
        clientName: json['clientName'] as String,
        amount: (json['amount'] as num).toDouble(),
        status: json['status'] as String,
        type: json['type'] as String,
        createdAt: DateTime.parse(json['createdAt'] as String),
      );
}

class DashboardState {
  final DashboardStats? stats;
  final bool isLoading;
  final String? error;

  const DashboardState({this.stats, this.isLoading = false, this.error});

  DashboardState copyWith({
    DashboardStats? stats,
    bool? isLoading,
    String? error,
  }) {
    return DashboardState(
      stats: stats ?? this.stats,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class DashboardNotifier extends StateNotifier<DashboardState> {
  final Dio _dio;

  DashboardNotifier(this._dio) : super(const DashboardState()) {
    loadDashboard();
  }

  Future<void> loadDashboard() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final response = await _dio.get('/admin/dashboard');
      final stats =
          DashboardStats.fromJson(response.data as Map<String, dynamic>);
      state = state.copyWith(stats: stats, isLoading: false);
    } on DioException catch (e) {
      state = state.copyWith(
          isLoading: false, error: _handleError(e));
    } catch (_) {
      state = state.copyWith(
          isLoading: false, error: 'Xatolik yuz berdi');
    }
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

final dashboardProvider =
    StateNotifierProvider<DashboardNotifier, DashboardState>((ref) {
  final dio = ref.watch(dioProvider);
  return DashboardNotifier(dio);
});
