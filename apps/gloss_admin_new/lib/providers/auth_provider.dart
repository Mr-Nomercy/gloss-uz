import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_provider.g.dart';

const _tokenKey = 'admin_token';

const storage = FlutterSecureStorage();

@riverpod
class AuthNotifier extends _$AuthNotifier {
  @override
  Future<String?> build() async {
    return storage.read(key: _tokenKey);
  }

  Future<void> login(String email, String password) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await Future.delayed(const Duration(seconds: 1));
      const token = 'admin-session-token';
      await storage.write(key: _tokenKey, value: token);
      return token;
    });
  }

  Future<void> logout() async {
    await storage.delete(key: _tokenKey);
    state = const AsyncData(null);
  }
}
