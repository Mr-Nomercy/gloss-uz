import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:models/models.dart';
import 'package:constants/constants.dart';

class AuthState {
  final String? email;
  final String? accessToken;
  final String? refreshToken;
  final User? user;
  final bool isLoading;
  final String? error;
  // Transient — only set between password auth succeeding and TOTP
  // completing (see AuthNotifier.login/confirmTotpSetup/verifyTotp).
  // Never persisted; cleared once the real tokens come back.
  final String? setupToken;
  final String? mfaToken;
  final String? totpSecret;
  final String? otpauthUrl;

  const AuthState({
    this.email,
    this.accessToken,
    this.refreshToken,
    this.user,
    this.isLoading = false,
    this.error,
    this.setupToken,
    this.mfaToken,
    this.totpSecret,
    this.otpauthUrl,
  });

  bool get isAuthenticated => accessToken != null && user != null;
  bool get totpSetupRequired => setupToken != null;
  bool get totpVerifyRequired => mfaToken != null;
  bool get isAdmin =>
      user?.roles.any((r) =>
          r == UserRole.admin || r == UserRole.superAdmin) ??
      false;

  AuthState copyWith({
    String? email,
    String? accessToken,
    String? refreshToken,
    User? user,
    bool? isLoading,
    String? error,
    String? setupToken,
    String? mfaToken,
    String? totpSecret,
    String? otpauthUrl,
    bool clearTotpState = false,
  }) {
    return AuthState(
      email: email ?? this.email,
      accessToken: accessToken ?? this.accessToken,
      refreshToken: refreshToken ?? this.refreshToken,
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      setupToken: clearTotpState ? null : (setupToken ?? this.setupToken),
      mfaToken: clearTotpState ? null : (mfaToken ?? this.mfaToken),
      totpSecret: clearTotpState ? null : (totpSecret ?? this.totpSecret),
      otpauthUrl: clearTotpState ? null : (otpauthUrl ?? this.otpauthUrl),
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
    final accessToken = await _storage.read(key: 'admin_access_token');
    final refreshToken = await _storage.read(key: 'admin_refresh_token');
    final email = await _storage.read(key: 'admin_email');

    if (accessToken != null && refreshToken != null) {
      state = state.copyWith(
        accessToken: accessToken,
        refreshToken: refreshToken,
        email: email,
        user: const User(
          id: 'admin-1',
          phone: '+998900000000',
          email: 'admin@gloss.uz',
          fullName: 'Super Admin',
          roles: ['super_admin', 'admin'],
          isBlocked: false,
        ),
      );
    }
  }

  /// Password auth only ever completes login directly when 2FA has never
  /// been enrolled AND already-verified on this account in the same
  /// session — in practice that's never on the real backend (2FA is
  /// mandatory for platform_admin), so this always ends in one of the
  /// two TOTP states below instead of returning tokens.
  Future<bool> login(String email, String password) async {
    state = state.copyWith(isLoading: true, error: null, email: email);

    try {
      final response = await _dio.post('/admin/auth/login', data: {
        'email': email,
        'password': password,
      });
      final data = response.data as Map<String, dynamic>;

      if (data['totpSetupRequired'] == true) {
        state = state.copyWith(
          isLoading: false,
          setupToken: data['setupToken'] as String,
          totpSecret: data['secret'] as String,
          otpauthUrl: data['otpauthUrl'] as String?,
        );
        return true;
      }
      if (data['totpRequired'] == true) {
        state = state.copyWith(
          isLoading: false,
          mfaToken: data['mfaToken'] as String,
        );
        return true;
      }

      // Defensive fallback only — the backend always returns one of the
      // two branches above for platform_admin.
      await _completeLogin(data, email);
      return true;
    } on DioException catch (e) {
      state = state.copyWith(isLoading: false, error: _handleError(e));
      return false;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: 'Xatolik yuz berdi');
      return false;
    }
  }

  /// First-ever login: the code entered against [AuthState.totpSecret]
  /// both enables 2FA on the account and completes this login.
  Future<bool> confirmTotpSetup(String code) async {
    final setupToken = state.setupToken;
    if (setupToken == null) return false;
    state = state.copyWith(isLoading: true, error: null);

    try {
      final response = await _dio.post('/admin/auth/totp/confirm', data: {
        'setup_token': setupToken,
        'code': code,
      });
      await _completeLogin(response.data as Map<String, dynamic>, state.email);
      return true;
    } on DioException catch (e) {
      state = state.copyWith(isLoading: false, error: _handleError(e));
      return false;
    }
  }

  /// Every login after the first: second factor for an already-enrolled
  /// account.
  Future<bool> verifyTotp(String code) async {
    final mfaToken = state.mfaToken;
    if (mfaToken == null) return false;
    state = state.copyWith(isLoading: true, error: null);

    try {
      final response = await _dio.post('/admin/auth/totp/verify', data: {
        'mfa_token': mfaToken,
        'code': code,
      });
      await _completeLogin(response.data as Map<String, dynamic>, state.email);
      return true;
    } on DioException catch (e) {
      state = state.copyWith(isLoading: false, error: _handleError(e));
      return false;
    }
  }

  Future<void> _completeLogin(Map<String, dynamic> data, String? email) async {
    final accessToken = data['accessToken'] as String;
    final refreshToken = data['refreshToken'] as String;
    final userData = data['user'] as Map<String, dynamic>;
    final user = User.fromJson(userData);

    final hasAdminRole = user.roles.any(
      (r) => r == UserRole.admin || r == UserRole.superAdmin,
    );
    if (!hasAdminRole) {
      state = state.copyWith(
        isLoading: false,
        error: 'Ruxsat yo\'q. Admin panelga faqat adminlar kira oladi.',
        clearTotpState: true,
      );
      return;
    }

    await _storage.write(key: 'admin_access_token', value: accessToken);
    await _storage.write(key: 'admin_refresh_token', value: refreshToken);
    if (email != null) {
      await _storage.write(key: 'admin_email', value: email);
    }

    state = state.copyWith(
      accessToken: accessToken,
      refreshToken: refreshToken,
      user: user,
      isLoading: false,
      clearTotpState: true,
    );
  }

  Future<void> logout() async {
    await _storage.deleteAll();
    state = const AuthState();
  }

  void clearError() {
    state = state.copyWith(error: null);
  }

  Future<void> refreshAccessToken() async {
    final rt = state.refreshToken;
    if (rt == null) return;
    try {
      final response = await _dio.post('/admin/auth/refresh', data: {
        'refreshToken': rt,
      });
      final accessToken = response.data['accessToken'] as String;
      await _storage.write(key: 'admin_access_token', value: accessToken);
      state = state.copyWith(accessToken: accessToken);
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) await logout();
    }
  }

  String _handleError(DioException e) {
    if (e.response?.statusCode == 401) {
      return "Email yoki parol noto'g'ri";
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
    connectTimeout: const Duration(milliseconds: 10000),
    receiveTimeout: const Duration(milliseconds: 15000),
    headers: {'Content-Type': 'application/json'},
  ));

  dio.interceptors.add(InterceptorsWrapper(
    onRequest: (options, handler) async {
      final storage = const FlutterSecureStorage();
      final token = await storage.read(key: 'admin_access_token');
      if (token != null) {
        options.headers['Authorization'] = 'Bearer $token';
      }
      handler.next(options);
    },
    onError: (error, handler) async {
      if (error.response?.statusCode == 401) {
        final storage = const FlutterSecureStorage();
        final rt = await storage.read(key: 'admin_refresh_token');
        if (rt != null) {
          try {
            final response = await Dio(BaseOptions(
              baseUrl: AppConstants.devBaseUrl,
            )).post('/admin/auth/refresh', data: {'refreshToken': rt});
            final newToken = response.data['accessToken'] as String;
            await storage.write(
                key: 'admin_access_token', value: newToken);
            error.requestOptions.headers['Authorization'] =
                'Bearer $newToken';
            final retryResponse =
                await Dio(BaseOptions(baseUrl: AppConstants.devBaseUrl))
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

final authProvider =
    StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final dio = ref.watch(dioProvider);
  final storage = ref.watch(storageProvider);
  return AuthNotifier(dio, storage);
});
