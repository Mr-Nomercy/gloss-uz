import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'providers/auth_provider.dart';
import 'partner_shell.dart';
import 'screens/login_screen.dart';
import 'screens/worker_home_tab.dart';
import 'screens/worker_orders_tab.dart';
import 'screens/worker_stats_tab.dart';
import 'screens/worker_profile_tab.dart';
import 'screens/courier_home_tab.dart';
import 'screens/courier_orders_tab.dart';
import 'screens/courier_earnings_tab.dart';
import 'screens/courier_profile_tab.dart';
import 'screens/order_detail_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authProvider);

  return GoRouter(
    initialLocation: '/login',
    redirect: (context, state) {
      final isAuthRoute = state.matchedLocation == '/login';
      if (!authState.isAuthenticated && !isAuthRoute) {
        return '/login';
      }
      if (authState.isAuthenticated && isAuthRoute) {
        return authState.homePath;
      }
      return null;
    },
    routes: [
      GoRoute(path: '/login', builder: (_, __) => const LoginScreen()),

      // Worker shell
      ShellRoute(
        builder: (_, __, child) => WorkerShell(child: child),
        routes: [
          GoRoute(
            path: '/worker/home',
            pageBuilder: (_, __) => const NoTransitionPage(child: WorkerHomeTab()),
          ),
          GoRoute(
            path: '/worker/orders',
            pageBuilder: (_, __) => const NoTransitionPage(child: WorkerOrdersTab()),
          ),
          GoRoute(
            path: '/worker/stats',
            pageBuilder: (_, __) => const NoTransitionPage(child: WorkerStatsTab()),
          ),
          GoRoute(
            path: '/worker/profile',
            pageBuilder: (_, __) => const NoTransitionPage(child: WorkerProfileTab()),
          ),
        ],
      ),

      // Courier shell
      ShellRoute(
        builder: (_, __, child) => CourierShell(child: child),
        routes: [
          GoRoute(
            path: '/courier/home',
            pageBuilder: (_, __) => const NoTransitionPage(child: CourierHomeTab()),
          ),
          GoRoute(
            path: '/courier/orders',
            pageBuilder: (_, __) => const NoTransitionPage(child: CourierOrdersTab()),
          ),
          GoRoute(
            path: '/courier/earnings',
            pageBuilder: (_, __) => const NoTransitionPage(child: CourierEarningsTab()),
          ),
          GoRoute(
            path: '/courier/profile',
            pageBuilder: (_, __) => const NoTransitionPage(child: CourierProfileTab()),
          ),
        ],
      ),

      // Shared
      GoRoute(
        path: '/orders/:orderId',
        builder: (_, state) => OrderDetailScreen(orderId: state.pathParameters['orderId']!),
      ),
    ],
  );
});
