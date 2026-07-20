import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ui_kit/ui_kit.dart';

import 'package:gloss_delivery/main.dart';
import 'package:gloss_delivery/app.dart';

Widget buildTestApp() {
  return ProviderScope(
    child: MaterialApp(
      theme: AppTheme.light,
      home: const Scaffold(
        body: Center(child: Text('Test')),
      ),
    ),
  );
}

void main() {
  testWidgets('GlossDeliveryApp renders without error', (tester) async {
    await tester.pumpWidget(const ProviderScope(
      child: GlossDeliveryApp(),
    ));
    await tester.pump();
    expect(find.byType(GlossDeliveryApp), findsOneWidget);
  });

  testWidgets('ProviderScope is available in widget tree', (tester) async {
    await tester.pumpWidget(buildTestApp());
    expect(find.text('Test'), findsOneWidget);
  });

  testWidgets('GoRouter has all expected routes', (tester) async {
    final container = ProviderContainer();
    final router = container.read(routerProvider);

    expect(router.configuration.findMatch('/splash').isEmpty, isFalse);
    expect(router.configuration.findMatch('/onboarding').isEmpty, isFalse);
    expect(router.configuration.findMatch('/auth/login').isEmpty, isFalse);
    expect(router.configuration.findMatch('/auth/register').isEmpty, isFalse);
    expect(router.configuration.findMatch('/auth/verify').isEmpty, isFalse);
    expect(router.configuration.findMatch('/').isEmpty, isFalse);
    expect(router.configuration.findMatch('/orders').isEmpty, isFalse);
    expect(router.configuration.findMatch('/stats').isEmpty, isFalse);
    expect(router.configuration.findMatch('/profile').isEmpty, isFalse);
  });

  testWidgets('Router initial location is /splash', (tester) async {
    final container = ProviderContainer();
    final router = container.read(routerProvider);
    final match = router.configuration.findMatch('/splash');
    expect(match.isEmpty, isFalse);
  });

  testWidgets('App theme has GlossTheme extension', (tester) async {
    final theme = AppTheme.light;
    final glossTheme = theme.extensions[GlossTheme];
    expect(glossTheme, isNotNull);
  });
}
