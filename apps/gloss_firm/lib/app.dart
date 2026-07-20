import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'screens/splash_screen.dart';
import 'screens/auth_screen.dart';
import 'screens/verify_screen.dart';
import 'screens/register_screen.dart';
import 'screens/home_screen.dart';
import 'screens/orders_screen.dart';
import 'screens/order_detail_screen.dart';
import 'screens/availability_screen.dart';
import 'screens/stats_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/wallet_screen.dart';
import 'screens/notifications_screen.dart';
import 'screens/support_screen.dart';
import 'screens/settings_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/splash',
    routes: [
      GoRoute(path: '/splash', builder: (_, __) => const SplashScreen()),
      GoRoute(path: '/auth', builder: (_, __) => const AuthScreen()),
      GoRoute(
        path: '/auth/verify',
        builder: (_, state) => VerifyScreen(phone: state.extra as String),
      ),
      GoRoute(path: '/auth/register', builder: (_, __) => const RegisterScreen()),
      GoRoute(path: '/', builder: (_, __) => const HomeScreen()),
      GoRoute(path: '/orders', builder: (_, __) => const OrdersScreen()),
      GoRoute(
        path: '/orders/:orderId',
        builder: (_, state) => OrderDetailScreen(orderId: state.pathParameters['orderId']!),
      ),
      GoRoute(path: '/availability', builder: (_, __) => const AvailabilityScreen()),
      GoRoute(path: '/stats', builder: (_, __) => const StatsScreen()),
      GoRoute(path: '/profile', builder: (_, __) => const ProfileScreen()),
      GoRoute(path: '/wallet', builder: (_, __) => const WalletScreen()),
      GoRoute(path: '/notifications', builder: (_, __) => const NotificationsScreen()),
      GoRoute(path: '/support', builder: (_, __) => const SupportScreen()),
      GoRoute(path: '/settings', builder: (_, __) => const SettingsScreen()),
    ],
  );
});
