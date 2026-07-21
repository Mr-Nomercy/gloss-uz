import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'auth_provider.dart';

class CommissionConfig {
  final String id;
  final String serviceTypeId;
  final String serviceTypeName;
  final double rate;
  final double minOrderAmount;

  const CommissionConfig({
    required this.id,
    required this.serviceTypeId,
    required this.serviceTypeName,
    required this.rate,
    this.minOrderAmount = 30000,
  });

  factory CommissionConfig.fromJson(Map<String, dynamic> json) =>
      CommissionConfig(
        id: json['id'] as String,
        serviceTypeId: json['serviceTypeId'] as String,
        serviceTypeName: json['serviceTypeName'] as String,
        rate: (json['rate'] as num).toDouble(),
        minOrderAmount: (json['minOrderAmount'] as num?)?.toDouble() ?? 30000,
      );
}

class CommissionsState {
  final List<CommissionConfig> commissions;
  final bool isLoading;
  final bool isSaving;
  final String? error;

  const CommissionsState({
    this.commissions = const [],
    this.isLoading = false,
    this.isSaving = false,
    this.error,
  });

  CommissionsState copyWith({
    List<CommissionConfig>? commissions,
    bool? isLoading,
    bool? isSaving,
    String? error,
  }) {
    return CommissionsState(
      commissions: commissions ?? this.commissions,
      isLoading: isLoading ?? this.isLoading,
      isSaving: isSaving ?? this.isSaving,
      error: error,
    );
  }
}

class CommissionsNotifier extends StateNotifier<CommissionsState> {
  final Dio _dio;

  CommissionsNotifier(this._dio) : super(const CommissionsState()) {
    loadCommissions();
  }

  Future<void> loadCommissions() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final response = await _dio.get('/admin/commissions');
      final commissions = (response.data as List)
          .map((e) =>
              CommissionConfig.fromJson(e as Map<String, dynamic>))
          .toList();
      state = state.copyWith(
          commissions: commissions, isLoading: false);
    } on DioException catch (e) {
      state = state.copyWith(
          isLoading: false, error: _handleError(e));
    } catch (_) {
      state = state.copyWith(
          isLoading: false, error: 'Xatolik yuz berdi');
    }
  }

  void updateLocalRate(String configId, double rate) {
    final updated = state.commissions.map((c) {
      if (c.id == configId) {
        return CommissionConfig(
          id: c.id,
          serviceTypeId: c.serviceTypeId,
          serviceTypeName: c.serviceTypeName,
          rate: rate,
          minOrderAmount: c.minOrderAmount,
        );
      }
      return c;
    }).toList();
    state = state.copyWith(commissions: updated);
  }

  Future<bool> saveCommissions() async {
    state = state.copyWith(isSaving: true, error: null);
    try {
      final data = state.commissions.map((c) => {
            'serviceTypeId': c.serviceTypeId,
            'rate': c.rate,
            'minOrderAmount': c.minOrderAmount,
          }).toList();
      await _dio.put('/admin/commissions', data: {'commissions': data});
      state = state.copyWith(isSaving: false);
      return true;
    } on DioException catch (e) {
      state = state.copyWith(
          isSaving: false, error: _handleError(e));
      return false;
    } catch (_) {
      state = state.copyWith(
          isSaving: false, error: 'Xatolik yuz berdi');
      return false;
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

final commissionsProvider =
    StateNotifierProvider<CommissionsNotifier, CommissionsState>((ref) {
  final dio = ref.watch(dioProvider);
  return CommissionsNotifier(dio);
});
