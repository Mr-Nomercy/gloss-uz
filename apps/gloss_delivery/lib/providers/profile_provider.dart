import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'auth_provider.dart';

class ProfileState {
  final CourierProfile? profile;
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
    CourierProfile? profile,
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

class CourierProfile {
  final String id;
  final String fullName;
  final String phone;
  final String? email;
  final String? avatar;
  final String? vehicleType;
  final String? vehiclePlate;
  final String? licenseNumber;
  final double rating;
  final int totalOrders;
  final int completedOrders;
  final int cancelledOrders;
  final bool isVerified;
  final bool isActive;
  final DateTime? createdAt;

  const CourierProfile({
    required this.id,
    required this.fullName,
    required this.phone,
    this.email,
    this.avatar,
    this.vehicleType,
    this.vehiclePlate,
    this.licenseNumber,
    this.rating = 0.0,
    this.totalOrders = 0,
    this.completedOrders = 0,
    this.cancelledOrders = 0,
    this.isVerified = false,
    this.isActive = true,
    this.createdAt,
  });

  factory CourierProfile.fromJson(Map<String, dynamic> json) => CourierProfile(
        id: json['id'] as String,
        fullName: json['fullName'] as String,
        phone: json['phone'] as String,
        email: json['email'] as String?,
        avatar: json['avatar'] as String?,
        vehicleType: json['vehicleType'] as String?,
        vehiclePlate: json['vehiclePlate'] as String?,
        licenseNumber: json['licenseNumber'] as String?,
        rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
        totalOrders: (json['totalOrders'] as num?)?.toInt() ?? 0,
        completedOrders: (json['completedOrders'] as num?)?.toInt() ?? 0,
        cancelledOrders: (json['cancelledOrders'] as num?)?.toInt() ?? 0,
        isVerified: json['isVerified'] as bool? ?? false,
        isActive: json['isActive'] as bool? ?? true,
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
      final response = await _dio.get('/courier/profile');
      final profile = CourierProfile.fromJson(response.data as Map<String, dynamic>);
      state = state.copyWith(profile: profile, isLoading: false);
    } on DioException catch (e) {
      state = state.copyWith(isLoading: false, error: _handleError(e));
    } catch (_) {
      state = state.copyWith(isLoading: false, error: 'Xatolik yuz berdi');
    }
  }

  Future<bool> updateProfile({
    String? fullName,
    String? email,
    String? vehicleType,
    String? vehiclePlate,
    String? licenseNumber,
  }) async {
    state = state.copyWith(isUpdating: true, error: null);
    try {
      final data = <String, dynamic>{};
      if (fullName != null) data['fullName'] = fullName;
      if (email != null) data['email'] = email;
      if (vehicleType != null) data['vehicleType'] = vehicleType;
      if (vehiclePlate != null) data['vehiclePlate'] = vehiclePlate;
      if (licenseNumber != null) data['licenseNumber'] = licenseNumber;

      final response = await _dio.patch('/courier/profile', data: data);
      final profile = CourierProfile.fromJson(response.data as Map<String, dynamic>);
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

  Future<bool> uploadAvatar(String filePath) async {
    state = state.copyWith(isUpdating: true, error: null);
    try {
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(filePath, filename: 'avatar.jpg'),
      });
      final response = await _dio.post('/courier/profile/avatar', data: formData);
      final profile = CourierProfile.fromJson(response.data as Map<String, dynamic>);
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