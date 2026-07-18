import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:models/models.dart';

class AuthState {
  final String? phone;
  final String? accessToken;
  final String? refreshToken;
  final User? user;
  final bool isLoading;
  final String? error;

  const AuthState({
    this.phone,
    this.accessToken,
    this.refreshToken,
    this.user,
    this.isLoading = false,
    this.error,
  });

  bool get isAuthenticated => accessToken != null && user != null;

  bool get isCourier => user?.roles.contains('courier') ?? false;

  AuthState copyWith({
    String? phone,
    String? accessToken,
    String? refreshToken,
    User? user,
    bool? isLoading,
    String? error,
  }) {
    return AuthState(
      phone: phone ?? this.phone,
      accessToken: accessToken ?? this.accessToken,
      refreshToken: refreshToken ?? this.refreshToken,
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  final Dio _dio;
  final FlutterSecureStorage _storage;

  AuthNotifier(this._dio, this._storage) : super(const AuthState()) {
    _loadTokens();
  }

  Future<void> _loadTokens() async {
    final accessToken = await _storage.read(key: 'access_token');
    final refreshToken = await _storage.read(key: 'refresh_token');
    final phone = await _storage.read(key: 'user_phone');

    if (accessToken != null && refreshToken != null) {
      state = state.copyWith(
        accessToken: accessToken,
        refreshToken: refreshToken,
        phone: phone,
      );
    }
  }

  Future<void> login(String phone) async {
    state = state.copyWith(isLoading: true, error: null, phone: phone);
    try {
      await _dio.post('/auth/login', data: {'phone': phone});
    } on DioException catch (e) {
      state = state.copyWith(isLoading: false, error: _handleError(e));
    } catch (e) {
      state = state.copyWith(isLoading: false, error: 'Xatolik yuz berdi');
    }
  }

  Future<bool> verifyOtp(String phone, String code) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final response = await _dio.post('/auth/login', data: {
        'phone': phone,
        'otp': code,
      });
      final data = response.data;
      final accessToken = data['accessToken'] as String;
      final refreshToken = data['refreshToken'] as String;
      final userData = data['user'] as Map<String, dynamic>;
      final user = User.fromJson(userData);

      if (!user.roles.contains('courier')) {
        state = state.copyWith(
          isLoading: false,
          error: "Siz kuryer emassiz",
        );
        return false;
      }

      await _saveTokens(accessToken, refreshToken, phone, user);
      state = state.copyWith(
        phone: phone,
        accessToken: accessToken,
        refreshToken: refreshToken,
        user: user,
        isLoading: false,
      );
      return true;
    } on DioException catch (e) {
      state = state.copyWith(isLoading: false, error: _handleError(e));
      return false;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: 'Xatolik yuz berdi');
      return false;
    }
  }

  Future<bool> register(String phone, String fullName) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final response = await _dio.post('/auth/register', data: {
        'phone': phone,
        'fullName': fullName,
        'role': 'courier',
      });
      final data = response.data;
      final accessToken = data['accessToken'] as String;
      final refreshToken = data['refreshToken'] as String;
      final userData = data['user'] as Map<String, dynamic>;
      final user = User.fromJson(userData);
      await _saveTokens(accessToken, refreshToken, phone, user);
      state = state.copyWith(
        phone: phone,
        accessToken: accessToken,
        refreshToken: refreshToken,
        user: user,
        isLoading: false,
      );
      return true;
    } on DioException catch (e) {
      state = state.copyWith(isLoading: false, error: _handleError(e));
      return false;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: 'Xatolik yuz berdi');
      return false;
    }
  }

  Future<void> _saveTokens(
    String accessToken,
    String refreshToken,
    String phone,
    User user,
  ) async {
    await _storage.write(key: 'access_token', value: accessToken);
    await _storage.write(key: 'refresh_token', value: refreshToken);
    await _storage.write(key: 'user_phone', value: phone);
  }

  Future<void> logout() async {
    await _storage.deleteAll();
    state = const AuthState();
  }

  void clearError() {
    state = state.copyWith(error: null);
  }

  Future<void> refreshAccessToken() async {
    final refreshToken = state.refreshToken;
    if (refreshToken == null) return;

    try {
      final response = await _dio.post('/auth/refresh', data: {
        'refreshToken': refreshToken,
      });
      final accessToken = response.data['accessToken'] as String;
      await _storage.write(key: 'access_token', value: accessToken);
      state = state.copyWith(accessToken: accessToken);
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        await logout();
      }
    }
  }

  String _handleError(DioException e) {
    if (e.response?.statusCode == 401) {
      return "Kod noto'g'ri";
    }
    if (e.response?.statusCode == 400) {
      final data = e.response?.data;
      if (data is Map && data['message'] != null) {
        return data['message'] as String;
      }
    }
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout) {
      return "Internetga ulanishda xatolik";
    }
    return 'Xatolik yuz berdi';
  }
}

final storageProvider = Provider<FlutterSecureStorage>((ref) {
  return const FlutterSecureStorage();
});

final dioProvider = Provider<Dio>((ref) {
  return Dio(BaseOptions(
    baseUrl: 'http://localhost:3000/api',
    connectTimeout: const Duration(milliseconds: 30000),
    receiveTimeout: const Duration(milliseconds: 30000),
    headers: {'Content-Type': 'application/json'},
  ));
});

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final dio = ref.watch(dioProvider);
  final storage = ref.watch(storageProvider);
  return AuthNotifier(dio, storage);
});