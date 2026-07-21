import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:gloss_routing/gloss_routing.dart';
import 'providers/auth_provider.dart';
import 'screens/login_screen.dart';
import 'screens/totp_setup_screen.dart';
import 'screens/totp_verify_screen.dart';
import 'screens/dashboard_tab.dart';
import 'screens/orders_tab.dart';
import 'screens/order_detail_screen.dart';
import 'screens/tenants_tab.dart';
import 'screens/tenant_detail_screen.dart';
import 'screens/more_tab.dart';
import 'screens/users_screen.dart';
import 'screens/user_detail_screen.dart';
import 'screens/market_screen.dart';
import 'screens/product_form_screen.dart';
import 'screens/commissions_screen.dart';
import 'screens/payouts_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/admin_profile_screen.dart';
import 'admin_shell.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authProvider);

  return GoRouter(
    initialLocation: '/login',
    redirect: (context, state) {
      return AuthGuard(
        isAuthenticated: authState.isAuthenticated,
        userRoles: authState.user?.roles ?? [],
        allowedRoles: const ['admin', 'super_admin'],
        authPaths: const ['/login'],
        homePath: '/dashboard',
      ).redirect(state);
    },
    routes: [
      GoRoute(path: '/login', builder: (_, __) => const LoginScreen()),
      GoRoute(path: '/login/totp-setup', builder: (_, __) => const TotpSetupScreen()),
      GoRoute(path: '/login/totp-verify', builder: (_, __) => const TotpVerifyScreen()),
      ShellRoute(
        builder: (_, __, child) => AdminShell(child: child),
        routes: [
          GoRoute(path: '/dashboard', pageBuilder: (_, __) => const NoTransitionPage(child: DashboardTab())),
          GoRoute(path: '/orders', pageBuilder: (_, __) => const NoTransitionPage(child: OrdersTab())),
          GoRoute(path: '/tenants', pageBuilder: (_, __) => const NoTransitionPage(child: TenantsTab())),
          GoRoute(path: '/more', pageBuilder: (_, __) => const NoTransitionPage(child: MoreTab())),
        ],
      ),
      GoRoute(path: '/orders/:orderId', builder: (_, state) => OrderDetailScreen(orderId: state.pathParameters['orderId']!)),
      GoRoute(path: '/tenants/:tenantId', builder: (_, state) => TenantDetailScreen(tenantId: state.pathParameters['tenantId']!)),
      GoRoute(path: '/users', builder: (_, __) => const UsersScreen()),
      GoRoute(path: '/users/:userId', builder: (_, state) => UserDetailScreen(userId: state.pathParameters['userId']!)),
      GoRoute(path: '/market', builder: (_, __) => const MarketScreen()),
      GoRoute(path: '/market/product/add', builder: (_, __) => const ProductFormScreen()),
      GoRoute(path: '/market/product/:productId', builder: (_, state) => ProductFormScreen(productId: state.pathParameters['productId'])),
      GoRoute(path: '/commissions', builder: (_, __) => const CommissionsScreen()),
      GoRoute(path: '/payouts', builder: (_, __) => const PayoutsScreen()),
      GoRoute(path: '/settings', builder: (_, __) => const SettingsScreen()),
      GoRoute(path: '/profile', builder: (_, __) => const AdminProfileScreen()),
    ],
  );
});
