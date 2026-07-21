import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:dio/dio.dart';
import 'package:gloss_user/providers/auth_provider.dart';
import 'package:ui_kit/ui_kit.dart';

class FakeFlutterSecureStorage extends FlutterSecureStorage {
  final Map<String, String> _store = {};

  @override
  Future<void> write({
    required String key,
    required String? value,
    IOSOptions? iOptions,
    AndroidOptions? aOptions,
    LinuxOptions? lOptions,
    WebOptions? webOptions,
    WindowsOptions? wOptions,
    MacOsOptions? mOptions,
  }) async {
    _store[key] = value ?? '';
  }

  @override
  Future<String?> read({
    required String key,
    IOSOptions? iOptions,
    AndroidOptions? aOptions,
    LinuxOptions? lOptions,
    WebOptions? webOptions,
    WindowsOptions? wOptions,
    MacOsOptions? mOptions,
  }) async {
    final value = _store[key];
    return value == '' ? null : value;
  }

  @override
  Future<void> delete({
    required String key,
    IOSOptions? iOptions,
    AndroidOptions? aOptions,
    LinuxOptions? lOptions,
    WebOptions? webOptions,
    WindowsOptions? wOptions,
    MacOsOptions? mOptions,
  }) async {
    _store.remove(key);
  }

  @override
  Future<void> deleteAll({
    IOSOptions? iOptions,
    AndroidOptions? aOptions,
    LinuxOptions? lOptions,
    WebOptions? webOptions,
    WindowsOptions? wOptions,
    MacOsOptions? mOptions,
  }) async {
    _store.clear();
  }

  @override
  Future<Map<String, String>> readAll({
    IOSOptions? iOptions,
    AndroidOptions? aOptions,
    LinuxOptions? lOptions,
    WebOptions? webOptions,
    WindowsOptions? wOptions,
    MacOsOptions? mOptions,
  }) async {
    return Map.from(_store);
  }

  @override
  Future<bool> containsKey({
    required String key,
    IOSOptions? iOptions,
    AndroidOptions? aOptions,
    LinuxOptions? lOptions,
    WebOptions? webOptions,
    WindowsOptions? wOptions,
    MacOsOptions? mOptions,
  }) async {
    return _store.containsKey(key) && _store[key] != '';
  }
}

Dio createMockDio() {
  return Dio(BaseOptions(
    baseUrl: 'https://mock-api.example.com',
    connectTimeout: const Duration(seconds: 1),
    receiveTimeout: const Duration(seconds: 1),
    headers: {'Content-Type': 'application/json'},
  ));
}

List<Override> baseOverrides() {
  return [
    dioProvider.overrideWithValue(createMockDio()),
    storageProvider.overrideWithValue(FakeFlutterSecureStorage()),
  ];
}

Widget wrapApp(Widget child, {List<Override> overrides = const []}) {
  return ProviderScope(
    overrides: [...baseOverrides(), ...overrides],
    child: MaterialApp(
      theme: AppTheme.light,
      home: child,
    ),
  );
}

Widget wrapWithAuth({
  required Widget child,
  required AuthState authState,
  List<Override> overrides = const [],
}) {
  return ProviderScope(
    overrides: [
      ...baseOverrides(),
      authProvider.overrideWith((ref) {
        final notifier = AuthNotifier(
          ref.read(dioProvider),
          ref.read(storageProvider),
        );
        notifier.state = authState;
        return notifier;
      }),
      ...overrides,
    ],
    child: MaterialApp(
      theme: AppTheme.light,
      home: child,
    ),
  );
}
