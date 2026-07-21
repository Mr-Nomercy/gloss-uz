import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';

class AuthGuard {
  final bool isAuthenticated;
  final List<String> userRoles;
  final List<String> allowedRoles;
  final List<String> authPaths;
  final String homePath;

  AuthGuard({
    required this.isAuthenticated,
    this.userRoles = const [],
    this.allowedRoles = const [],
    this.authPaths = const ['/auth', '/verify', '/register', '/splash', '/onboarding'],
    this.homePath = '/',
  }) {
    if (authPaths.isEmpty) {
      throw ArgumentError('authPaths must not be empty');
    }
  }

  String? redirect(GoRouterState state) {
    final location = state.matchedLocation;

    final isInAuth = authPaths.any(
      (p) => location == p || location.startsWith('$p/'),
    );

    if (!isAuthenticated && !isInAuth) {
      return authPaths.first;
    }

    if (isAuthenticated && isInAuth) {
      return homePath;
    }

    if (isAuthenticated && allowedRoles.isNotEmpty) {
      final hasRole = userRoles.any((r) => allowedRoles.contains(r));
      if (!hasRole) {
        return homePath;
      }
    }

    return null;
  }
}

class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    stream.listen((_) => notifyListeners());
    notifyListeners();
  }
}
