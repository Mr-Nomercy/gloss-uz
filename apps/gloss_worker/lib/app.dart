import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:dashboard_kit/dashboard_kit.dart';
import 'package:ui_kit/ui_kit.dart';
import 'package:gloss_routing/gloss_routing.dart';
import 'providers/auth_provider.dart';
import 'screens/splash_screen.dart';
import 'screens/auth_screen.dart';
import 'screens/verify_screen.dart';
import 'screens/register_screen.dart';
import 'screens/order_detail_screen.dart';
import 'screens/availability_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/wallet_screen.dart';
import 'screens/notifications_screen.dart';
import 'screens/support_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/firm_tabs.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authProvider);
  final authNotifier = ref.watch(authProvider.notifier);

  return GoRouter(
    initialLocation: '/splash',
    refreshListenable: GoRouterRefreshStream(authNotifier.authStateStream),
    redirect: (context, state) {
      return AuthGuard(
        isAuthenticated: authState.isAuthenticated,
        userRoles: authState.user?.roles ?? [],
        allowedRoles: const ['provider', 'worker'],
        authPaths: const ['/splash', '/auth', '/auth/verify', '/auth/register'],
      ).redirect(state);
    },
    routes: [
      GoRoute(path: '/splash', builder: (_, __) => const SplashScreen()),
      GoRoute(path: '/auth', builder: (_, __) => const AuthScreen()),
      GoRoute(
        path: '/auth/verify',
        builder: (_, state) => VerifyScreen(phone: state.extra as String),
      ),
      GoRoute(path: '/auth/register', builder: (_, __) => const RegisterScreen()),
      GoRoute(
        path: '/',
        builder: (_, __) {
          final glossTheme = Theme.of(_).extension<GlossTheme>();
          final green = glossTheme?.green ?? const Color(0xFF00AA13);
          return DashboardScaffold(
            theme: DashboardTheme(
              primaryColor: green,
              darkAccent: const Color(0xFF047857),
              backgroundColor: const Color(0xFFF8FAF8),
              cardColor: Colors.white,
            ),
            navItems: const [
              NavItem(icon: Icons.home_rounded, activeicon: Icons.home_rounded, label: 'Asosiy'),
              NavItem(icon: Icons.receipt_long_rounded, activeicon: Icons.receipt_long_rounded, label: 'Buyurtmalar'),
              NavItem(icon: Icons.bar_chart_rounded, activeicon: Icons.bar_chart_rounded, label: 'Statistika'),
              NavItem(icon: Icons.grid_view_rounded, activeicon: Icons.grid_view_rounded, label: 'Yana'),
            ],
            screens: const [
              WorkerHomeTab(),
              WorkerOrdersTab(),
              WorkerStatsTab(),
              WorkerMoreTab(),
            ],
          );
        },
      ),
      GoRoute(
        path: '/orders/:orderId',
        builder: (_, state) => OrderDetailScreen(orderId: state.pathParameters['orderId']!),
      ),
      GoRoute(path: '/availability', builder: (_, __) => const AvailabilityScreen()),
      GoRoute(path: '/profile', builder: (_, __) => const ProfileScreen()),
      GoRoute(path: '/wallet', builder: (_, __) => const WalletScreen()),
      GoRoute(path: '/notifications', builder: (_, __) => const NotificationsScreen()),
      GoRoute(path: '/support', builder: (_, __) => const SupportScreen()),
      GoRoute(path: '/settings', builder: (_, __) => const SettingsScreen()),
    ],
  );
});
