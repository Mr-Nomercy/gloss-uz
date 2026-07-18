import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'auth_provider.dart';

class DashboardState {
  final SellerDashboard? dashboard;
  final bool isLoading;
  final String? error;

  const DashboardState({
    this.dashboard,
    this.isLoading = false,
    this.error,
  });

  DashboardState copyWith({
    SellerDashboard? dashboard,
    bool? isLoading,
    String? error,
  }) {
    return DashboardState(
      dashboard: dashboard ?? this.dashboard,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class SellerDashboard {
  final int productsCount;
  final int ordersCount;
  final double revenue;
  final double rating;
  final int pendingKyc;
  final List<ChartData> revenueChart;

  const SellerDashboard({
    required this.productsCount,
    required this.ordersCount,
    required this.revenue,
    required this.rating,
    required this.pendingKyc,
    this.revenueChart = const [],
  });

  factory SellerDashboard.fromJson(Map<String, dynamic> json) => SellerDashboard(
        productsCount: (json['productsCount'] as num?)?.toInt() ?? 0,
        ordersCount: (json['ordersCount'] as num?)?.toInt() ?? 0,
        revenue: (json['revenue'] as num?)?.toDouble() ?? 0,
        rating: (json['rating'] as num?)?.toDouble() ?? 0,
        pendingKyc: (json['pendingKyc'] as num?)?.toInt() ?? 0,
        revenueChart: (json['revenueChart'] as List?)
                ?.map((e) => ChartData.fromJson(e as Map<String, dynamic>))
                .toList() ??
            [],
      );
}

class ChartData {
  final String label;
  final double value;

  const ChartData({
    required this.label,
    required this.value,
  });

  factory ChartData.fromJson(Map<String, dynamic> json) => ChartData(
        label: json['label'] as String,
        value: (json['value'] as num).toDouble(),
      );
}

class DashboardNotifier extends StateNotifier<DashboardState> {
  final Dio _dio;

  DashboardNotifier(this._dio) : super(const DashboardState()) {
    loadDashboard();
  }

  Future<void> loadDashboard() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final response = await _dio.get('/seller/dashboard');
      final dashboard = SellerDashboard.fromJson(response.data as Map<String, dynamic>);
      state = state.copyWith(dashboard: dashboard, isLoading: false);
    } on DioException catch (e) {
      state = state.copyWith(isLoading: false, error: _handleError(e));
    } catch (_) {
      state = state.copyWith(isLoading: false, error: 'Xatolik yuz berdi');
    }
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
    return 'Xatolik yuz berdi';
  }
}

final dashboardProvider = StateNotifierProvider<DashboardNotifier, DashboardState>((ref) {
  final dio = ref.watch(dioProvider);
  return DashboardNotifier(dio);
});