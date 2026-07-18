import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'auth_provider.dart';

class CancelReasonState {
  final bool isSubmitting;
  final String? error;

  const CancelReasonState({
    this.isSubmitting = false,
    this.error,
  });

  CancelReasonState copyWith({
    bool? isSubmitting,
    String? error,
  }) {
    return CancelReasonState(
      isSubmitting: isSubmitting ?? this.isSubmitting,
      error: error,
    );
  }
}

class CancelReasonNotifier extends StateNotifier<CancelReasonState> {
  final Dio _dio;

  CancelReasonNotifier(this._dio) : super(const CancelReasonState());

  static const List<String> cancelReasons = [
    'Rejam o\'zgardi',
    'Arzonroq topdim',
    'Juda uzoq kutdim',
    'Manzil noto\'g\'ri',
    'Xizmat kerak emas',
    'Provider bilan muammo',
    'Boshqa',
  ];

  Future<bool> cancelOrder(String orderId, String reason) async {
    state = state.copyWith(isSubmitting: true, error: null);
    try {
      await _dio.patch('/orders/$orderId/cancel', data: {'reason': reason});
      state = state.copyWith(isSubmitting: false);
      return true;
    } on DioException catch (e) {
      state = state.copyWith(isSubmitting: false, error: _handleError(e));
      return false;
    } catch (_) {
      state = state.copyWith(isSubmitting: false, error: 'Xatolik yuz berdi');
      return false;
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
    if (e.response?.statusCode == 400) {
      final data = e.response?.data;
      if (data is Map && data['message'] != null) {
        return data['message'] as String;
      }
    }
    return 'Xatolik yuz berdi';
  }
}

final cancelReasonProvider = StateNotifierProvider<CancelReasonNotifier, CancelReasonState>((ref) {
  final dio = ref.watch(dioProvider);
  return CancelReasonNotifier(dio);
});