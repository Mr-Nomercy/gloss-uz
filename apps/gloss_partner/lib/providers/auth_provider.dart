import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:models/models.dart';

class AuthState {
  final String phone;
  final String? accessToken;
  final User? user;
  final bool isLoading;
  final String? error;

  const AuthState({
    this.phone = '',
    this.accessToken,
    this.user,
    this.isLoading = false,
    this.error,
  });

  bool get isAuthenticated => accessToken != null && user != null;

  bool get isWorker => user?.roles.contains('worker') ?? false;
  bool get isCourier => user?.roles.contains('courier') ?? false;

  String get homePath {
    if (isWorker) return '/worker/home';
    if (isCourier) return '/courier/home';
    return '/login';
  }

  AuthState copyWith({
    String? phone,
    String? accessToken,
    User? user,
    bool? isLoading,
    String? error,
    bool clearError = false,
    bool clearUser = false,
  }) {
    return AuthState(
      phone: phone ?? this.phone,
      accessToken: clearUser ? null : (accessToken ?? this.accessToken),
      user: clearUser ? null : (user ?? this.user),
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(const AuthState());

  Future<void> login(String phone) async {
    state = state.copyWith(isLoading: true, clearError: true);
    await Future.delayed(const Duration(seconds: 1));

    if (phone == '998901234567') {
      state = state.copyWith(
        phone: phone,
        accessToken: 'mock_access_token_worker',
        user: User(
          id: 'worker_1',
          phone: phone,
          fullName: 'Dilshod Karimov',
          roles: const ['worker'],
        ),
        isLoading: false,
        clearError: true,
      );
    } else if (phone == '998907654321') {
      state = state.copyWith(
        phone: phone,
        accessToken: 'mock_access_token_courier',
        user: User(
          id: 'courier_1',
          phone: phone,
          fullName: 'Jasur Alimov',
          roles: const ['courier'],
        ),
        isLoading: false,
        clearError: true,
      );
    } else {
      state = state.copyWith(
        isLoading: false,
        error: 'Foydalanuvchi topilmadi',
        clearUser: true,
      );
    }
  }

  void clearError() {
    state = state.copyWith(clearError: true);
  }

  Future<void> logout() async {
    state = const AuthState();
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});
