import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'screens/login_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/tenants_screen.dart';
import 'screens/commissions_screen.dart';
import 'screens/orders_screen.dart';
import 'screens/users_screen.dart';
import 'screens/market_screen.dart';
import 'screens/payouts_screen.dart';
import 'screens/settings_screen.dart';

part 'app.g.dart';

@riverpod
GoRouter router(RouterRef ref) {
  return GoRouter(
    initialLocation: '/login',
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/dashboard',
        builder: (context, state) => const DashboardScreen(),
      ),
      GoRoute(
        path: '/tenants',
        builder: (context, state) => const TenantsScreen(),
      ),
      GoRoute(
        path: '/commissions',
        builder: (context, state) => const CommissionsScreen(),
      ),
      GoRoute(
        path: '/orders',
        builder: (context, state) => const OrdersScreen(),
      ),
      GoRoute(
        path: '/users',
        builder: (context, state) => const UsersScreen(),
      ),
      GoRoute(
        path: '/market',
        builder: (context, state) => const MarketScreen(),
      ),
      GoRoute(
        path: '/payouts',
        builder: (context, state) => const PayoutsScreen(),
      ),
      GoRoute(
        path: '/settings',
        builder: (context, state) => const SettingsScreen(),
      ),
    ],
  );
}
