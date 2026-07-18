import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'auth_provider.dart';

class StatsState {
  final CourierStats? stats;
  final bool isLoading;
  final String? error;

  const StatsState({
    this.stats,
    this.isLoading = false,
    this.error,
  });

  StatsState copyWith({
    CourierStats? stats,
    bool? isLoading,
    String? error,
  }) {
    return StatsState(
      stats: stats ?? this.stats,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class CourierStats {
  final int totalOrders;
  final int completedOrders;
  final int cancelledOrders;
  final double totalEarnings;
  final double weeklyEarnings;
  final double monthlyEarnings;
  final double averageRating;
  final int totalDistance;
  final int weeklyDistance;
  final List<ChartData> weeklyChart;
  final List<ChartData> monthlyChart;

  const CourierStats({
    required this.totalOrders,
    required this.completedOrders,
    required this.cancelledOrders,
    required this.totalEarnings,
    required this.weeklyEarnings,
    required this.monthlyEarnings,
    required this.averageRating,
    required this.totalDistance,
    required this.weeklyDistance,
    this.weeklyChart = const [],
    this.monthlyChart = const [],
  });

  factory CourierStats.fromJson(Map<String, dynamic> json) => CourierStats(
        totalOrders: (json['totalOrders'] as num?)?.toInt() ?? 0,
        completedOrders: (json['completedOrders'] as num?)?.toInt() ?? 0,
        cancelledOrders: (json['cancelledOrders'] as num?)?.toInt() ?? 0,
        totalEarnings: (json['totalEarnings'] as num?)?.toDouble() ?? 0,
        weeklyEarnings: (json['weeklyEarnings'] as num?)?.toDouble() ?? 0,
        monthlyEarnings: (json['monthlyEarnings'] as num?)?.toDouble() ?? 0,
        averageRating: (json['averageRating'] as num?)?.toDouble() ?? 0,
        totalDistance: (json['totalDistance'] as num?)?.toInt() ?? 0,
        weeklyDistance: (json['weeklyDistance'] as num?)?.toInt() ?? 0,
        weeklyChart: (json['weeklyChart'] as List?)
                ?.map((e) => ChartData.fromJson(e as Map<String, dynamic>))
                .toList() ??
            [],
        monthlyChart: (json['monthlyChart'] as List?)
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

class StatsNotifier extends StateNotifier<StatsState> {
  final Dio _dio;

  StatsNotifier(this._dio) : super(const StatsState()) {
    loadStats();
  }

  Future<void> loadStats() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final response = await _dio.get('/courier/stats');
      final stats = CourierStats.fromJson(response.data as Map<String, dynamic>);
      state = state.copyWith(stats: stats, isLoading: false);
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

final statsProvider = StateNotifierProvider<StatsNotifier, StatsState>((ref) {
  final dio = ref.watch(dioProvider);
  return StatsNotifier(dio);
});