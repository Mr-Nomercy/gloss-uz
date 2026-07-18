import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:models/models.dart';
import 'auth_provider.dart';

class SellerProfileState {
  final SellerProfile? profile;
  final bool isLoading;
  final bool isUpdating;
  final String? error;

  const SellerProfileState({
    this.profile,
    this.isLoading = false,
    this.isUpdating = false,
    this.error,
  });

  SellerProfileState copyWith({
    SellerProfile? profile,
    bool? isLoading,
    bool? isUpdating,
    String? error,
  }) {
    return SellerProfileState(
      profile: profile ?? this.profile,
      isLoading: isLoading ?? this.isLoading,
      isUpdating: isUpdating ?? this.isUpdating,
      error: error,
    );
  }
}

class SellerProfileNotifier extends StateNotifier<SellerProfileState> {
  final Dio _dio;

  SellerProfileNotifier(this._dio) : super(const SellerProfileState()) {
    loadProfile();
  }

  Future<void> loadProfile() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final response = await _dio.get('/seller/profile');
      final profile = SellerProfile.fromJson(response.data as Map<String, dynamic>);
      state = state.copyWith(profile: profile, isLoading: false);
    } on DioException catch (e) {
      state = state.copyWith(isLoading: false, error: _handleError(e));
    } catch (_) {
      state = state.copyWith(isLoading: false, error: 'Xatolik yuz berdi');
    }
  }

  Future<bool> updateProfile({
    String? shopName,
    String? phone,
    String? email,
    String? description,
  }) async {
    state = state.copyWith(isUpdating: true, error: null);
    try {
      final data = <String, dynamic>{};
      if (shopName != null) data['shopName'] = shopName;
      if (phone != null) data['phone'] = phone;
      if (email != null) data['email'] = email;
      if (description != null) data['description'] = description;

      final response = await _dio.patch('/seller/profile', data: data);
      final profile = SellerProfile.fromJson(response.data as Map<String, dynamic>);
      state = state.copyWith(profile: profile, isUpdating: false);
      return true;
    } on DioException catch (e) {
      state = state.copyWith(isUpdating: false, error: _handleError(e));
      return false;
    } catch (_) {
      state = state.copyWith(isUpdating: false, error: 'Xatolik yuz berdi');
      return false;
    }
  }

  Future<bool> uploadLogo(String filePath) async {
    state = state.copyWith(isUpdating: true, error: null);
    try {
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(filePath, filename: 'logo.jpg'),
      });
      final response = await _dio.post('/seller/profile/logo', data: formData);
      final profile = SellerProfile.fromJson(response.data as Map<String, dynamic>);
      state = state.copyWith(profile: profile, isUpdating: false);
      return true;
    } on DioException catch (e) {
      state = state.copyWith(isUpdating: false, error: _handleError(e));
      return false;
    } catch (_) {
      state = state.copyWith(isUpdating: false, error: 'Xatolik yuz berdi');
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
      return 'Fayl hajmi juda katta';
    }
    return 'Xatolik yuz berdi';
  }
}

final sellerProfileProvider = StateNotifierProvider<SellerProfileNotifier, SellerProfileState>((ref) {
  final dio = ref.watch(dioProvider);
  return SellerProfileNotifier(dio);
});