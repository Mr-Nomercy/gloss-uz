import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ui_kit/ui_kit.dart';
import 'package:gloss_firm/screens/splash_screen.dart';
import 'package:gloss_firm/screens/auth_screen.dart';
import 'package:gloss_firm/screens/home_screen.dart';
import 'package:gloss_firm/screens/orders_screen.dart';
import 'package:gloss_firm/screens/order_detail_screen.dart';
import 'package:gloss_firm/screens/stats_screen.dart';
import 'package:gloss_firm/screens/wallet_screen.dart';
import 'package:gloss_firm/screens/profile_screen.dart';

Widget _wrapScreen(Widget screen) {
  final router = GoRouter(routes: [
    GoRoute(path: '/', builder: (_, __) => screen),
  ]);
  return ProviderScope(
    child: MaterialApp.router(
      routerConfig: router,
      theme: AppTheme.light,
    ),
  );
}

Widget _wrapScreenSimple(Widget screen) {
  return ProviderScope(
    child: MaterialApp(
      theme: AppTheme.light,
      home: screen,
    ),
  );
}

void main() {
  testWidgets('SplashScreen renders', (tester) async {
    await tester.pumpWidget(_wrapScreen(const SplashScreen()));
    await tester.pump();
    expect(find.text('Gloss Firm'), findsOneWidget);
    expect(find.text('Tozalash xizmati'), findsOneWidget);
    await tester.pump(const Duration(seconds: 3));
  });

  testWidgets('AuthScreen renders phone input', (tester) async {
    await tester.pumpWidget(_wrapScreen(const AuthScreen()));
    await tester.pump(const Duration(milliseconds: 200));
    expect(find.text('Telefon raqam'), findsOneWidget);
    expect(find.text('+998'), findsOneWidget);
    expect(find.text('Kirish'), findsOneWidget);
  });

  testWidgets('HomeScreen renders online toggle + balance + quick actions', (tester) async {
    await tester.pumpWidget(_wrapScreenSimple(const HomeScreen()));
    await tester.pump(const Duration(seconds: 1));
    await tester.pump(const Duration(seconds: 1));
    expect(find.text('Mavjud balans'), findsOneWidget);
    expect(find.text('Pul chiqarish'), findsOneWidget);
    expect(find.text('Buyurtmalar'), findsOneWidget);
    expect(find.text('Statistika'), findsOneWidget);
    expect(find.text('Hamyon'), findsOneWidget);
    expect(find.text('Profil'), findsOneWidget);
    expect(find.text('Yordam'), findsOneWidget);
  });

  testWidgets('OrdersScreen renders tabs', (tester) async {
    await tester.pumpWidget(_wrapScreen(const OrdersScreen()));
    await tester.pump(const Duration(seconds: 1));
    await tester.pump(const Duration(seconds: 1));
    expect(find.text('Buyurtmalar'), findsOneWidget);
    expect(find.text('Faol'), findsOneWidget);
    expect(find.text('Rejalashtirilgan'), findsOneWidget);
    expect(find.text('Tugallangan'), findsOneWidget);
  });

  testWidgets('OrderDetailScreen renders timeline', (tester) async {
    await tester.pumpWidget(_wrapScreen(const OrderDetailScreen(orderId: 'ORD-001')));
    await tester.pump(const Duration(milliseconds: 900));
    expect(find.text('Buyurtma holati'), findsOneWidget);
    expect(find.text('Buyurtma yuborildi'), findsOneWidget);
    expect(find.text('Narx tafsilotlari'), findsOneWidget);
  });

  testWidgets('StatsScreen renders stat cards', (tester) async {
    await tester.pumpWidget(_wrapScreen(const StatsScreen()));
    await tester.pump(const Duration(milliseconds: 100));
    await tester.pump(const Duration(seconds: 2));
    expect(find.text('Statistika'), findsOneWidget);
    expect(find.text('Jami buyurtmalar'), findsOneWidget);
    expect(find.text("O'rtacha reyting"), findsOneWidget);
    expect(find.text('Bu hafta'), findsOneWidget);
    expect(find.text("Ko'rsatkichlar"), findsOneWidget);
  });

  testWidgets('WalletScreen renders balance + transactions', (tester) async {
    await tester.pumpWidget(_wrapScreen(const WalletScreen()));
    await tester.pump(const Duration(milliseconds: 100));
    await tester.pump(const Duration(seconds: 1));
    expect(find.text('Hamyon'), findsOneWidget);
    expect(find.text('Joriy balans'), findsOneWidget);
    expect(find.text('Pul chiqarish'), findsAtLeastNWidgets(1));
    expect(find.text("Tranzaksiyalar tarixi"), findsOneWidget);
    await tester.pump(const Duration(seconds: 1));
  });

  testWidgets('ProfileScreen renders menu items', (tester) async {
    await tester.pumpWidget(_wrapScreen(const ProfileScreen()));
    await tester.pump(const Duration(seconds: 1));
    await tester.pump(const Duration(seconds: 1));
    expect(find.text('Profil'), findsOneWidget);
    expect(find.text('Jasur Aliyev'), findsOneWidget);
    expect(find.text("Shaxsiy ma'lumotlar"), findsOneWidget);
    expect(find.text('Sozlamalar'), findsOneWidget);
    expect(find.text('Chiqish'), findsOneWidget);
  });
}
