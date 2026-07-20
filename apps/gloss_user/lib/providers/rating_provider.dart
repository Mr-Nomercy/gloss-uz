import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'auth_provider.dart';

class RatingState {
  final bool isSubmitting;
  final String? error;

  const RatingState({
    this.isSubmitting = false,
    this.error,
  });

  RatingState copyWith({
    bool? isSubmitting,
    String? error,
  }) {
    return RatingState(
      isSubmitting: isSubmitting ?? this.isSubmitting,
      error: error,
    );
  }
}

class RatingNotifier extends StateNotifier<RatingState> {
  final Dio _dio;

  RatingNotifier(this._dio) : super(const RatingState());

  Future<bool> submitRating({
    required String orderId,
    required double quality,
    required double punctuality,
    required double communication,
    String? comment,
  }) async {
    state = state.copyWith(isSubmitting: true, error: null);
    try {
      await _dio.post('/orders/$orderId/rate', data: {
        'quality': quality,
        'punctuality': punctuality,
        'communication': communication,
        if (comment != null && comment.isNotEmpty) 'comment': comment,
      });
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

final ratingProvider = StateNotifierProvider<RatingNotifier, RatingState>((ref) {
  final dio = ref.watch(dioProvider);
  return RatingNotifier(dio);
});