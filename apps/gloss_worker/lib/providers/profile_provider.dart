import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'auth_provider.dart';

class ProfileState {
  final ProviderProfile? profile;
  final bool isLoading;
  final bool isUpdating;
  final String? error;

  const ProfileState({
    this.profile,
    this.isLoading = false,
    this.isUpdating = false,
    this.error,
  });

  ProfileState copyWith({
    ProviderProfile? profile,
    bool? isLoading,
    bool? isUpdating,
    String? error,
  }) {
    return ProfileState(
      profile: profile ?? this.profile,
      isLoading: isLoading ?? this.isLoading,
      isUpdating: isUpdating ?? this.isUpdating,
      error: error,
    );
  }
}

class ProviderProfile {
  final String id;
  final String companyName;
  final String phone;
  final String? email;
  final String? description;
  final String? address;
  final String? logoUrl;
  final double rating;
  final int totalOrders;
  final int totalWorkers;
  final bool isActive;
  final bool isVerified;
  final DateTime? createdAt;

  const ProviderProfile({
    required this.id,
    required this.companyName,
    required this.phone,
    this.email,
    this.description,
    this.address,
    this.logoUrl,
    this.rating = 0.0,
    this.totalOrders = 0,
    this.totalWorkers = 0,
    this.isActive = true,
    this.isVerified = false,
    this.createdAt,
  });

  factory ProviderProfile.fromJson(Map<String, dynamic> json) => ProviderProfile(
        id: json['id'] as String,
        companyName: json['companyName'] as String,
        phone: json['phone'] as String,
        email: json['email'] as String?,
        description: json['description'] as String?,
        address: json['address'] as String?,
        logoUrl: json['logoUrl'] as String?,
        rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
        totalOrders: (json['totalOrders'] as num?)?.toInt() ?? 0,
        totalWorkers: (json['totalWorkers'] as num?)?.toInt() ?? 0,
        isActive: json['isActive'] as bool? ?? true,
        isVerified: json['isVerified'] as bool? ?? false,
        createdAt: json['createdAt'] != null
            ? DateTime.parse(json['createdAt'] as String)
            : null,
      );
}

class ProfileNotifier extends StateNotifier<ProfileState> {
  final Dio _dio;

  ProfileNotifier(this._dio) : super(const ProfileState()) {
    loadProfile();
  }

  Future<void> loadProfile() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final response = await _dio.get('/provider/profile');
      final profile = ProviderProfile.fromJson(response.data as Map<String, dynamic>);
      state = state.copyWith(profile: profile, isLoading: false);
    } on DioException catch (e) {
      state = state.copyWith(isLoading: false, error: _handleError(e));
    } catch (_) {
      state = state.copyWith(isLoading: false, error: 'Xatolik yuz berdi');
    }
  }

  Future<bool> updateProfile({
    String? companyName,
    String? email,
    String? description,
    String? address,
  }) async {
    state = state.copyWith(isUpdating: true, error: null);
    try {
      final data = <String, dynamic>{};
      if (companyName != null) data['companyName'] = companyName;
      if (email != null) data['email'] = email;
      if (description != null) data['description'] = description;
      if (address != null) data['address'] = address;

      final response = await _dio.patch('/provider/profile', data: data);
      final profile = ProviderProfile.fromJson(response.data as Map<String, dynamic>);
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
      final response = await _dio.post('/provider/profile/logo', data: formData);
      final profile = ProviderProfile.fromJson(response.data as Map<String, dynamic>);
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
    return 'Xatolik yuz berdi';
  }
}

final profileProvider = StateNotifierProvider<ProfileNotifier, ProfileState>((ref) {
  final dio = ref.watch(dioProvider);
  return ProfileNotifier(dio);
});