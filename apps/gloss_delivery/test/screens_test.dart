import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:ui_kit/ui_kit.dart';

import 'package:gloss_delivery/screens/splash_screen.dart';
import 'package:gloss_delivery/screens/onboarding_screen.dart';
import 'package:gloss_delivery/screens/login_screen.dart';
import 'package:gloss_delivery/screens/register_screen.dart';
import 'package:gloss_delivery/screens/verify_phone_screen.dart';
import 'package:gloss_delivery/screens/home_screen.dart';
import 'package:gloss_delivery/screens/orders_screen.dart';
import 'package:gloss_delivery/screens/stats_screen.dart';
import 'package:gloss_delivery/screens/profile_screen.dart';

Widget wrapWithRouter(Widget child) {
  return ProviderScope(
    child: MaterialApp.router(
      theme: AppTheme.light,
      routerConfig: GoRouter(
        initialLocation: '/',
        routes: [
          GoRoute(path: '/', builder: (_, __) => child),
          GoRoute(path: '/onboarding', builder: (_, __) => const SizedBox()),
          GoRoute(path: '/auth/login', builder: (_, __) => const SizedBox()),
          GoRoute(path: '/auth/register', builder: (_, __) => const SizedBox()),
          GoRoute(path: '/orders', builder: (_, __) => const SizedBox()),
          GoRoute(path: '/stats', builder: (_, __) => const SizedBox()),
          GoRoute(path: '/profile', builder: (_, __) => const SizedBox()),
        ],
      ),
    ),
  );
}

Widget wrapSimple(Widget child) {
  return ProviderScope(
    child: MaterialApp(
      theme: AppTheme.light,
      home: child,
    ),
  );
}

Future<void> pumpAndSettleAsync(WidgetTester tester) async {
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 100));
  await tester.pump(const Duration(milliseconds: 400));
  await tester.pump(const Duration(milliseconds: 600));
}

void main() {
  group('SplashScreen', () {
    testWidgets('renders logo and brand name', (tester) async {
      await tester.pumpWidget(wrapSimple(const SplashScreen()));
      await tester.pump();

      expect(find.text('Gloss Delivery'), findsOneWidget);
      expect(find.text('Yetkazib berish xizmati'), findsOneWidget);
      expect(find.byIcon(Icons.delivery_dining_rounded), findsOneWidget);
    });

    testWidgets('has white text on green background', (tester) async {
      await tester.pumpWidget(wrapSimple(const SplashScreen()));
      await tester.pump();

      final scaffold = tester.widget<Scaffold>(find.byType(Scaffold));
      expect(scaffold.backgroundColor, GlossColors.green);
    });
  });

  group('OnboardingScreen', () {
    testWidgets('renders first page with language selector', (tester) async {
      await tester.pumpWidget(wrapSimple(const OnboardingScreen()));
      await tester.pump();

      expect(find.text('Tilni tanlang'), findsOneWidget);
      expect(find.text("O'zbek"), findsOneWidget);
      expect(find.text('Русский'), findsOneWidget);
      expect(find.text('English'), findsOneWidget);
      expect(find.text('Davom etish'), findsOneWidget);
    });

    testWidgets('has language choice chips', (tester) async {
      await tester.pumpWidget(wrapSimple(const OnboardingScreen()));
      await tester.pump();

      expect(find.byType(ChoiceChip), findsNWidgets(3));
    });

    testWidgets('first page shows cleaning service info', (tester) async {
      await tester.pumpWidget(wrapSimple(const OnboardingScreen()));
      await tester.pump();

      expect(find.text('Toza uy, toza hayot'), findsOneWidget);
    });
  });

  group('LoginScreen', () {
    testWidgets('renders login form elements', (tester) async {
      await tester.pumpWidget(wrapSimple(const LoginScreen()));
      await tester.pump();

      expect(find.text('Xush kelibsiz'), findsOneWidget);
      expect(find.text('Hisobingizga kiring'), findsOneWidget);
      expect(find.text('Kirish'), findsAtLeast(1));
      expect(find.text("Ro'yxatdan o'tish"), findsOneWidget);
    });

    testWidgets('has phone and password fields', (tester) async {
      await tester.pumpWidget(wrapSimple(const LoginScreen()));
      await tester.pump();

      expect(find.byType(GlossTextField), findsNWidgets(2));
    });

    testWidgets('has delivery icon', (tester) async {
      await tester.pumpWidget(wrapSimple(const LoginScreen()));
      await tester.pump();

      expect(find.byIcon(Icons.delivery_dining_rounded), findsOneWidget);
    });

    testWidgets('has forgot password link', (tester) async {
      await tester.pumpWidget(wrapSimple(const LoginScreen()));
      await tester.pump();

      expect(find.text('Parolni unutdingizmi?'), findsOneWidget);
    });
  });

  group('RegisterScreen', () {
    testWidgets('renders registration form elements', (tester) async {
      await tester.pumpWidget(wrapSimple(const RegisterScreen()));
      await tester.pump();

      expect(find.text('Hisob yaratish'), findsOneWidget);
      expect(find.text("Ma'lumotlaringizni kiriting"), findsOneWidget);
      expect(find.text("Ro'yxatdan o'tish"), findsAtLeast(1));
    });

    testWidgets('has phone, name, and password fields', (tester) async {
      await tester.pumpWidget(wrapSimple(const RegisterScreen()));
      await tester.pump();

      expect(find.byType(GlossTextField), findsNWidgets(3));
    });

    testWidgets('has terms checkbox and agreement text', (tester) async {
      await tester.pumpWidget(wrapSimple(const RegisterScreen()));
      await tester.pump();

      expect(find.byType(Checkbox), findsOneWidget);
      expect(
        find.text('Foydalanish shartlari va maxfiylik siyosatiga roziman'),
        findsOneWidget,
      );
    });

    testWidgets('has switch to login button', (tester) async {
      await tester.pumpWidget(wrapSimple(const RegisterScreen()));
      await tester.pump();

      expect(find.text('Hisobingiz bormi? Kirish'), findsOneWidget);
    });
  });

  group('VerifyPhoneScreen', () {
    testWidgets('renders verification screen', (tester) async {
      await tester.pumpWidget(
        wrapSimple(const VerifyPhoneScreen(phone: '+998901234567')),
      );
      await tester.pump();

      expect(find.text('SMS kodni kiriting'), findsOneWidget);
      expect(find.text('Tasdiqlash'), findsOneWidget);
      expect(find.text('Kodni qayta yuborish'), findsOneWidget);
    });

    testWidgets('displays the phone number', (tester) async {
      await tester.pumpWidget(
        wrapSimple(const VerifyPhoneScreen(phone: '+998901234567')),
      );
      await tester.pump();

      expect(
        find.text('+998901234567 raqamiga SMS yuborildi'),
        findsOneWidget,
      );
    });

    testWidgets('has SMS icon', (tester) async {
      await tester.pumpWidget(
        wrapSimple(const VerifyPhoneScreen(phone: '+998901234567')),
      );
      await tester.pump();

      expect(find.byIcon(Icons.sms_rounded), findsOneWidget);
    });
  });

  group('HomeScreen', () {
    Future<void> pumpHome(WidgetTester tester) async {
      await tester.pumpWidget(wrapSimple(const HomeScreen()));
      await pumpAndSettleAsync(tester);
    }

    testWidgets('renders app bar with title', (tester) async {
      await pumpHome(tester);
      expect(find.text('Gloss Delivery'), findsOneWidget);
    });

    testWidgets('has notification bell icon', (tester) async {
      await pumpHome(tester);
      expect(find.byIcon(Icons.notifications_outlined), findsOneWidget);
    });

    testWidgets('shows balance card', (tester) async {
      await pumpHome(tester);
      expect(find.text('Mavjud balans'), findsOneWidget);
      expect(find.text("2 450 000 so'm"), findsOneWidget);
    });

    testWidgets('shows online toggle', (tester) async {
      await pumpHome(tester);
      expect(find.text('Holatingiz: Onlayn'), findsOneWidget);
      expect(find.byType(Switch), findsAtLeast(1));
    });

    testWidgets('shows quick actions section', (tester) async {
      await pumpHome(tester);
      await tester.scrollUntilVisible(
        find.text('TEZKOR AMALLAR'),
        200,
        scrollable: find.byType(Scrollable).first,
      );
      expect(find.text('TEZKOR AMALLAR'), findsOneWidget);
      expect(find.text('Buyurtmalar'), findsOneWidget);
    });

    testWidgets('shows stat cards', (tester) async {
      await pumpHome(tester);
      expect(find.text('Bugun'), findsOneWidget);
      expect(find.text('Reyting'), findsOneWidget);
    });

    testWidgets('shows recent deliveries section', (tester) async {
      await pumpHome(tester);
      await tester.scrollUntilVisible(
        find.text("SO'NGGI YETKAZMALAR"),
        200,
        scrollable: find.byType(Scrollable).first,
      );
      expect(find.text("SO'NGGI YETKAZMALAR"), findsOneWidget);
    });
  });

  group('OrdersScreen', () {
    testWidgets('renders title', (tester) async {
      await tester.pumpWidget(wrapSimple(const OrdersScreen()));
      await pumpAndSettleAsync(tester);

      expect(find.text('Buyurtmalar'), findsOneWidget);
    });

    testWidgets('has TabBar with two tabs', (tester) async {
      await tester.pumpWidget(wrapSimple(const OrdersScreen()));
      await pumpAndSettleAsync(tester);

      expect(find.byType(TabBar), findsOneWidget);
      expect(find.text('Faol'), findsOneWidget);
      expect(find.text('Tugallangan'), findsOneWidget);
    });

    testWidgets('shows active orders in first tab', (tester) async {
      await tester.pumpWidget(wrapSimple(const OrdersScreen()));
      await pumpAndSettleAsync(tester);

      expect(find.text('iPhone 15 Pro 256GB'), findsOneWidget);
    });

    testWidgets('tapping order shows bottom sheet', (tester) async {
      await tester.pumpWidget(wrapSimple(const OrdersScreen()));
      await pumpAndSettleAsync(tester);

      await tester.tap(find.text('iPhone 15 Pro 256GB'));
      await tester.pumpAndSettle();

      expect(find.text('Yopish'), findsOneWidget);
    });
  });

  group('StatsScreen', () {
    Future<void> pumpStats(WidgetTester tester) async {
      await tester.pumpWidget(wrapSimple(const StatsScreen()));
      await pumpAndSettleAsync(tester);
    }

    testWidgets('renders title', (tester) async {
      await pumpStats(tester);
      expect(find.text('Statistika'), findsOneWidget);
    });

    testWidgets('shows stat cards', (tester) async {
      await pumpStats(tester);
      expect(find.text('Jami buyurtmalar'), findsOneWidget);
      expect(find.text('Jami daromad'), findsOneWidget);
    });

    testWidgets('shows bar chart', (tester) async {
      await pumpStats(tester);
      expect(find.text('Haftalik buyurtmalar'), findsOneWidget);
    });

    testWidgets('shows monthly earnings section', (tester) async {
      await pumpStats(tester);
      await tester.scrollUntilVisible(
        find.text('Oylik daromad (mln)'),
        200,
        scrollable: find.byType(Scrollable).first,
      );
      expect(find.text('Oylik daromad (mln)'), findsOneWidget);
    });
  });

  group('ProfileScreen', () {
    Future<void> pumpProfile(WidgetTester tester) async {
      await tester.pumpWidget(wrapSimple(const ProfileScreen()));
      await tester.pump();
    }

    testWidgets('renders title', (tester) async {
      await pumpProfile(tester);
      expect(find.text('Profil'), findsOneWidget);
    });

    testWidgets('shows user name and phone', (tester) async {
      await pumpProfile(tester);
      expect(find.text('Jasur Qurbonov'), findsOneWidget);
      expect(find.text('+998 93 123 45 67'), findsOneWidget);
    });

    testWidgets('shows rating section', (tester) async {
      await pumpProfile(tester);
      expect(find.text('Reyting'), findsAtLeast(1));
    });

    testWidgets('shows vehicle info', (tester) async {
      await pumpProfile(tester);
      await tester.scrollUntilVisible(
        find.text('Transport'),
        200,
        scrollable: find.byType(Scrollable).first,
      );
      expect(find.text('Transport'), findsOneWidget);
      expect(find.text('Chevrolet Lacetti'), findsOneWidget);
    });

    testWidgets('has menu items', (tester) async {
      await pumpProfile(tester);
      await tester.scrollUntilVisible(
        find.text("Shaxsiy ma'lumotlar"),
        200,
        scrollable: find.byType(Scrollable).first,
      );
      expect(find.text("Shaxsiy ma'lumotlar"), findsOneWidget);
      expect(find.text("Transport ma'lumotlari"), findsOneWidget);
    });

    testWidgets('has logout button', (tester) async {
      await pumpProfile(tester);
      await tester.scrollUntilVisible(
        find.text('Chiqish'),
        200,
        scrollable: find.byType(Scrollable).first,
      );
      expect(find.text('Chiqish'), findsOneWidget);
    });

    testWidgets('shows logout confirmation dialog', (tester) async {
      await pumpProfile(tester);
      await tester.scrollUntilVisible(
        find.text('Chiqish'),
        200,
        scrollable: find.byType(Scrollable).first,
      );

      await tester.tap(find.text('Chiqish'));
      await tester.pumpAndSettle();

      expect(find.text('Chiqishni tasdiqlash'), findsOneWidget);
      expect(
        find.text('Haqiqatan ham akkauntdan chiqmoqchimisiz?'),
        findsOneWidget,
      );
    });
  });

  group('All screens render without overflow', () {
    testWidgets('SplashScreen no overflow', (tester) async {
      await tester.pumpWidget(wrapSimple(const SplashScreen()));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));
    });

    testWidgets('OnboardingScreen no overflow', (tester) async {
      await tester.pumpWidget(wrapSimple(const OnboardingScreen()));
      await tester.pump();
    });

    testWidgets('LoginScreen no overflow', (tester) async {
      await tester.pumpWidget(wrapSimple(const LoginScreen()));
      await tester.pump();
    });

    testWidgets('RegisterScreen no overflow', (tester) async {
      await tester.pumpWidget(wrapSimple(const RegisterScreen()));
      await tester.pump();
    });

    testWidgets('VerifyPhoneScreen no overflow', (tester) async {
      await tester.pumpWidget(
        wrapSimple(const VerifyPhoneScreen(phone: '+998901234567')),
      );
      await tester.pump();
    });

    testWidgets('HomeScreen no overflow', (tester) async {
      await tester.pumpWidget(wrapSimple(const HomeScreen()));
      await pumpAndSettleAsync(tester);
    });

    testWidgets('OrdersScreen no overflow', (tester) async {
      await tester.pumpWidget(wrapSimple(const OrdersScreen()));
      await pumpAndSettleAsync(tester);
    });

    testWidgets('StatsScreen no overflow', (tester) async {
      await tester.pumpWidget(wrapSimple(const StatsScreen()));
      await pumpAndSettleAsync(tester);
    });

    testWidgets('ProfileScreen no overflow', (tester) async {
      await tester.pumpWidget(wrapSimple(const ProfileScreen()));
      await tester.pump();
    });
  });
}
