import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'screens/splash_screen.dart';
import 'screens/onboarding_screen.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/home_screen.dart';
import 'screens/verify_phone_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/add_product_screen.dart';
import 'screens/kyc_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/splash',
    routes: [
      GoRoute(path: '/splash', builder: (_, __) => const SplashScreen()),
      GoRoute(path: '/onboarding', builder: (_, __) => const OnboardingScreen()),
      GoRoute(path: '/auth/login', builder: (_, __) => const LoginScreen()),
      GoRoute(path: '/auth/register', builder: (_, __) => const RegisterScreen()),
      GoRoute(path: '/auth/verify', builder: (_, __) => const VerifyPhoneScreen(phone: '')),
      GoRoute(path: '/', builder: (_, __) => const HomeScreen()),
      GoRoute(path: '/seller/dashboard', builder: (_, __) => const SellerDashboardScreen()),
      GoRoute(path: '/seller/add-product', builder: (_, __) => const AddProductScreen()),
      GoRoute(path: '/seller/kyc', builder: (_, __) => const KycScreen()),
    ],
  );
});
