import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:dashboard_kit/dashboard_kit.dart';
import 'package:ui_kit/ui_kit.dart';
import 'package:gloss_routing/gloss_routing.dart';
import 'providers/auth_provider.dart';
import 'screens/splash_screen.dart';
import 'screens/onboarding_screen.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/verify_phone_screen.dart';
import 'screens/delivery_tabs.dart';

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
        allowedRoles: const ['courier'],
        authPaths: const ['/splash', '/onboarding', '/auth/login', '/auth/register', '/auth/verify'],
      ).redirect(state);
    },
    routes: [
      GoRoute(path: '/splash', builder: (_, __) => const SplashScreen()),
      GoRoute(path: '/onboarding', builder: (_, __) => const OnboardingScreen()),
      GoRoute(path: '/auth/login', builder: (_, __) => const LoginScreen()),
      GoRoute(path: '/auth/register', builder: (_, __) => const RegisterScreen()),
      GoRoute(path: '/auth/verify', builder: (_, __) => const VerifyPhoneScreen(phone: '')),
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
              NavItem(icon: Icons.person_rounded, activeicon: Icons.person_rounded, label: 'Profil'),
            ],
            screens: const [
              DeliveryHomeTab(),
              DeliveryOrdersTab(),
              DeliveryStatsTab(),
              DeliveryProfileTab(),
            ],
          );
        },
      ),
    ],
  );
});

