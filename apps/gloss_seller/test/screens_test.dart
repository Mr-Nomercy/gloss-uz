import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:ui_kit/ui_kit.dart';

import '../lib/screens/splash_screen.dart';
import '../lib/screens/onboarding_screen.dart';
import '../lib/screens/login_screen.dart';
import '../lib/screens/register_screen.dart';
import '../lib/screens/home_screen.dart';
import '../lib/screens/dashboard_screen.dart';
import '../lib/screens/add_product_screen.dart';
import '../lib/screens/kyc_screen.dart';
import '../lib/screens/profile_screen.dart';

Widget wrapWithRouter(Widget child) {
  return ProviderScope(
    child: MaterialApp.router(
      theme: AppTheme.light,
      routerConfig: GoRouter(
        initialLocation: '/',
        routes: [
          GoRoute(path: '/', builder: (_, __) => child),
          GoRoute(path: '/auth/login', builder: (_, __) => const SizedBox()),
          GoRoute(path: '/auth/register', builder: (_, __) => const SizedBox()),
          GoRoute(path: '/seller/dashboard', builder: (_, __) => const SizedBox()),
          GoRoute(path: '/seller/add-product', builder: (_, __) => const SizedBox()),
          GoRoute(path: '/seller/kyc', builder: (_, __) => const SizedBox()),
          GoRoute(path: '/onboarding', builder: (_, __) => const SizedBox()),
        ],
      ),
    ),
  );
}

void main() {
  group('SplashScreen', () {
    testWidgets('renders main elements', (tester) async {
      await tester.pumpWidget(wrapWithRouter(const SplashScreen()));
      await tester.pump(const Duration(milliseconds: 500));
      expect(find.text('Gloss Seller'), findsOneWidget);
      expect(find.text('Sotuvchi platformasi'), findsOneWidget);
      expect(find.byIcon(Icons.store), findsOneWidget);
      await tester.pump(const Duration(seconds: 3));
    });
  });

  group('OnboardingScreen', () {
    testWidgets('renders onboarding content', (tester) async {
      await tester.pumpWidget(wrapWithRouter(const OnboardingScreen()));
      await tester.pump(const Duration(seconds: 1));
      expect(find.text("O'z do'koningizni yarating"), findsOneWidget);
      expect(find.byType(GlossButton), findsOneWidget);
    });

    testWidgets('shows login link', (tester) async {
      await tester.pumpWidget(wrapWithRouter(const OnboardingScreen()));
      await tester.pump(const Duration(seconds: 1));
      expect(find.text("Hisobingiz bormi? Kirish"), findsOneWidget);
    });
  });

  group('LoginScreen', () {
    testWidgets('renders login form fields', (tester) async {
      await tester.pumpWidget(wrapWithRouter(const LoginScreen()));
      await tester.pump(const Duration(seconds: 1));
      expect(find.text('Xush kelibsiz'), findsOneWidget);
      expect(find.byType(GlossTextField), findsNWidgets(2));
      expect(find.byType(GlossButton), findsOneWidget);
    });

    testWidgets('has register navigation button', (tester) async {
      await tester.pumpWidget(wrapWithRouter(const LoginScreen()));
      await tester.pump(const Duration(seconds: 1));
      expect(find.text("Ro'yxatdan o'tish"), findsOneWidget);
    });
  });

  group('RegisterScreen', () {
    testWidgets('renders step-based registration', (tester) async {
      await tester.pumpWidget(wrapWithRouter(const RegisterScreen()));
      await tester.pump(const Duration(seconds: 1));
      expect(find.text('Hisob yaratish'), findsOneWidget);
      expect(find.byType(GlossTextField), findsOneWidget);
      expect(find.byType(GlossCard), findsOneWidget);
    });

    testWidgets('shows step indicators', (tester) async {
      await tester.pumpWidget(wrapWithRouter(const RegisterScreen()));
      await tester.pump(const Duration(seconds: 1));
      expect(find.text('Telefon'), findsOneWidget);
      expect(find.text("Ma'lumotlar"), findsOneWidget);
      expect(find.text('Parol'), findsOneWidget);
    });

    testWidgets('has login link', (tester) async {
      await tester.pumpWidget(wrapWithRouter(const RegisterScreen()));
      await tester.pump(const Duration(seconds: 1));
      expect(find.text('Hisobingiz bormi? Kirish'), findsOneWidget);
    });
  });

  group('HomeScreen', () {
    testWidgets('renders with bottom navigation', (tester) async {
      await tester.pumpWidget(wrapWithRouter(const HomeScreen()));
      await tester.pumpAndSettle(const Duration(seconds: 3));
      expect(find.byType(Scaffold), findsAtLeastNWidgets(1));
      expect(find.byType(NavigationBar), findsAtLeastNWidgets(1));
    });

    testWidgets('has FAB for adding product', (tester) async {
      await tester.pumpWidget(wrapWithRouter(const HomeScreen()));
      await tester.pumpAndSettle(const Duration(seconds: 3));
      expect(find.byType(FloatingActionButton), findsAtLeastNWidgets(1));
    });
  });

  group('SellerDashboardScreen', () {
    testWidgets('shows loading then dashboard', (tester) async {
      await tester.pumpWidget(wrapWithRouter(const SellerDashboardScreen()));
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.byType(GlossLoadingView), findsOneWidget);
      await tester.pumpAndSettle(const Duration(seconds: 5));
      expect(find.text('Panel'), findsOneWidget);
      expect(find.text("Mening do'konim"), findsOneWidget);
    });

    testWidgets('has action buttons', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());
      addTearDown(() => tester.view.resetDevicePixelRatio());
      await tester.pumpWidget(wrapWithRouter(const SellerDashboardScreen()));
      await tester.pumpAndSettle(const Duration(seconds: 5));
      expect(find.text("Mahsulot qo'shish"), findsAtLeastNWidgets(1));
      expect(find.text('KYC tekshiruvi'), findsOneWidget);
    });
  });

  group('AddProductScreen', () {
    testWidgets('renders product form', (tester) async {
      await tester.pumpWidget(wrapWithRouter(const AddProductScreen()));
      await tester.pump(const Duration(seconds: 1));
      expect(find.text("Mahsulot qo'shish"), findsOneWidget);
      expect(find.byType(GlossTextField), findsAtLeastNWidgets(4));
    });

    testWidgets('has image upload area', (tester) async {
      await tester.pumpWidget(wrapWithRouter(const AddProductScreen()));
      await tester.pump(const Duration(seconds: 1));
      expect(find.text("Rasm qo'shish"), findsOneWidget);
    });
  });

  group('KycScreen', () {
    testWidgets('renders KYC verification screen', (tester) async {
      await tester.pumpWidget(wrapWithRouter(const KycScreen()));
      await tester.pump(const Duration(seconds: 2));
      expect(find.text('KYC tekshiruvi'), findsOneWidget);
      expect(find.text('Tasdiqlanmagan'), findsOneWidget);
    });

    testWidgets('lists document types', (tester) async {
      await tester.pumpWidget(wrapWithRouter(const KycScreen()));
      await tester.pump(const Duration(seconds: 2));
      expect(find.text('Passport'), findsOneWidget);
      expect(find.text('Selfie'), findsOneWidget);
    });
  });

  group('ProfileScreen', () {
    testWidgets('renders profile header', (tester) async {
      await tester.pumpWidget(wrapWithRouter(const ProfileScreen()));
      await tester.pump(const Duration(seconds: 1));
      expect(find.text('Profil'), findsOneWidget);
      expect(find.text("Mening do'konim"), findsOneWidget);
    });

    testWidgets('shows menu items', (tester) async {
      await tester.pumpWidget(wrapWithRouter(const ProfileScreen()));
      await tester.pump(const Duration(seconds: 1));
      expect(find.text("Do'kon ma'lumotlari"), findsOneWidget);
      expect(find.text('KYC hujjatlari'), findsOneWidget);
      expect(find.text('Chiqish'), findsOneWidget);
    });
  });
}
