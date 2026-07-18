import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:models/models.dart';
import 'auth_provider.dart';

class KycState {
  final List<KycDocument> documents;
  final bool isLoading;
  final bool isSubmitting;
  final String? error;

  const KycState({
    this.documents = const [],
    this.isLoading = false,
    this.isSubmitting = false,
    this.error,
  });

  KycState copyWith({
    List<KycDocument>? documents,
    bool? isLoading,
    bool? isSubmitting,
    String? error,
  }) {
    return KycState(
      documents: documents ?? this.documents,
      isLoading: isLoading ?? this.isLoading,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      error: error,
    );
  }

  KycDocument? getDocumentByType(String type) {
    try {
      return documents.firstWhere((d) => d.type == type);
    } catch (_) {
      return null;
    }
  }

  bool isTypeSubmitted(String type) {
    final doc = getDocumentByType(type);
    return doc != null && doc.status != 'pending';
  }

  bool isTypeApproved(String type) {
    final doc = getDocumentByType(type);
    return doc != null && doc.status == 'approved';
  }
}

class KycNotifier extends StateNotifier<KycState> {
  final Dio _dio;

  KycNotifier(this._dio) : super(const KycState()) {
    loadDocuments();
  }

  Future<void> loadDocuments() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final response = await _dio.get('/seller/kyc');
      final docs = (response.data as List)
          .map((e) => KycDocument.fromJson(e as Map<String, dynamic>))
          .toList();
      state = state.copyWith(documents: docs, isLoading: false);
    } on DioException catch (e) {
      state = state.copyWith(isLoading: false, error: _handleError(e));
    } catch (_) {
      state = state.copyWith(isLoading: false, error: 'Xatolik yuz berdi');
    }
  }

  Future<bool> submitDocument({
    required String type,
    required String filePath,
  }) async {
    state = state.copyWith(isSubmitting: true, error: null);
    try {
      final formData = FormData.fromMap({
        'type': type,
        'file': await MultipartFile.fromFile(
          filePath,
          filename: '$type.jpg',
        ),
      });

      final response = await _dio.post('/seller/kyc', data: formData);
      final newDoc = KycDocument.fromJson(response.data as Map<String, dynamic>);

      final existingIndex = state.documents.indexWhere((d) => d.type == type);
      if (existingIndex >= 0) {
        final newDocs = List<KycDocument>.from(state.documents);
        newDocs[existingIndex] = newDoc;
        state = state.copyWith(documents: newDocs, isSubmitting: false);
      } else {
        state = state.copyWith(
          documents: [...state.documents, newDoc],
          isSubmitting: false,
        );
      }
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
    if (e.response?.statusCode == 401) {
      return 'Sessiya tugadi, qayta kiring';
    }
    if (e.response?.statusCode == 400) {
      final data = e.response?.data;
      if (data is Map && data['message'] != null) {
        return data['message'] as String;
      }
    }
    if (e.response?.statusCode == 413) {
      return 'Fayl hajmi juda katta (maks 5MB)';
    }
    return 'Xatolik yuz berdi';
  }
}

final kycProvider = StateNotifierProvider<KycNotifier, KycState>((ref) {
  final dio = ref.watch(dioProvider);
  return KycNotifier(dio);
});