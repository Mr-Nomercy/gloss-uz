import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:models/models.dart';
import 'package:constants/constants.dart';

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
  final _authStateController = StreamController<AuthState>.broadcast();

  Stream<AuthState> get authStateStream => _authStateController.stream;

  AuthNotifier(this._dio, this._storage) : super(const AuthState()) {
    _loadTokens();
  }

  @override
  void dispose() {
    _authStateController.close();
    super.dispose();
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
    _authStateController.add(state);
  }

  Future<bool> login(String phone) async {
    state = state.copyWith(isLoading: true, error: null, phone: phone);
    _authStateController.add(state);
    try {
      await _dio.post('/auth/login', data: {'phone': phone});
      state = state.copyWith(isLoading: false);
      _authStateController.add(state);
      return true;
    } on DioException catch (e) {
      state = state.copyWith(isLoading: false, error: _handleError(e));
      _authStateController.add(state);
      return false;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: 'Xatolik yuz berdi');
      _authStateController.add(state);
      return false;
    }
  }

  Future<bool> verifyOtp(String phone, String code) async {
    state = state.copyWith(isLoading: true, error: null);
    _authStateController.add(state);
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
        _authStateController.add(state);
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
      _authStateController.add(state);
      return true;
    } on DioException catch (e) {
      state = state.copyWith(isLoading: false, error: _handleError(e));
      _authStateController.add(state);
      return false;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: 'Xatolik yuz berdi');
      _authStateController.add(state);
      return false;
    }
  }

  Future<bool> register(String phone, String fullName) async {
    state = state.copyWith(isLoading: true, error: null);
    _authStateController.add(state);
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
      _authStateController.add(state);
      return true;
    } on DioException catch (e) {
      state = state.copyWith(isLoading: false, error: _handleError(e));
      _authStateController.add(state);
      return false;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: 'Xatolik yuz berdi');
      _authStateController.add(state);
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
    _authStateController.add(state);
  }

  void clearError() {
    state = state.copyWith(error: null);
    _authStateController.add(state);
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
      _authStateController.add(state);
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
  final dio = Dio(BaseOptions(
    baseUrl: AppConstants.devBaseUrl,
    connectTimeout: const Duration(milliseconds: 30000),
    receiveTimeout: const Duration(milliseconds: 30000),
    headers: {'Content-Type': 'application/json'},
  ));

  // Without this, every request went out with no Authorization header at
  // all — /delivery/assignments/ etc. would 401 unconditionally.
  dio.interceptors.add(InterceptorsWrapper(
    onRequest: (options, handler) async {
      const storage = FlutterSecureStorage();
      final token = await storage.read(key: 'access_token');
      if (token != null) {
        options.headers['Authorization'] = 'Bearer $token';
      }
      handler.next(options);
    },
    onError: (error, handler) async {
      if (error.response?.statusCode == 401) {
        const storage = FlutterSecureStorage();
        final rt = await storage.read(key: 'refresh_token');
        if (rt != null) {
          try {
            final response = await Dio(BaseOptions(baseUrl: AppConstants.devBaseUrl))
                .post('/auth/refresh', data: {'refreshToken': rt});
            final newToken = response.data['accessToken'] as String;
            await storage.write(key: 'access_token', value: newToken);
            error.requestOptions.headers['Authorization'] = 'Bearer $newToken';
            final retryResponse = await Dio(BaseOptions(baseUrl: AppConstants.devBaseUrl))
                .fetch(error.requestOptions);
            handler.resolve(retryResponse);
            return;
          } catch (_) {
            await storage.deleteAll();
          }
        }
      }
      handler.next(error);
    },
  ));

  return dio;
});

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final dio = ref.watch(dioProvider);
  final storage = ref.watch(storageProvider);
  return AuthNotifier(dio, storage);
});