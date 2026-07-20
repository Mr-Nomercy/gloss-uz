import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gloss_client/main.dart' show GlossApp;
import 'package:gloss_client/app.dart';
import 'package:ui_kit/ui_kit.dart';

import 'test_helpers.dart';

Widget _wrapGlossApp({List<Override> overrides = const []}) {
  return ProviderScope(
    overrides: [...baseOverrides(), ...overrides],
    child: const GlossApp(),
  );
}

void main() {
  group('GlossApp', () {
    testWidgets('renders MaterialApp', (tester) async {
      await tester.pumpWidget(_wrapGlossApp());
      await tester.pump();

      expect(find.byType(MaterialApp), findsOneWidget);
    });

    testWidgets('sets correct locale and supported locales', (tester) async {
      await tester.pumpWidget(_wrapGlossApp());
      await tester.pump();

      final app = tester.widget<MaterialApp>(find.byType(MaterialApp));
      expect(app.locale, const Locale('uz'));
      expect(app.supportedLocales, contains(const Locale('uz')));
      expect(app.supportedLocales, contains(const Locale('ru')));
      expect(app.supportedLocales, contains(const Locale('en')));
    });

    testWidgets('uses light theme with GlossTheme extension', (tester) async {
      await tester.pumpWidget(_wrapGlossApp());
      await tester.pump();

      final app = tester.widget<MaterialApp>(find.byType(MaterialApp));
      expect(app.theme, AppTheme.light);
      expect(app.themeMode, ThemeMode.light);
    });

    testWidgets('has debug banner disabled', (tester) async {
      await tester.pumpWidget(_wrapGlossApp());
      await tester.pump();

      final app = tester.widget<MaterialApp>(find.byType(MaterialApp));
      expect(app.debugShowCheckedModeBanner, false);
    });

    testWidgets('uses router from routerProvider', (tester) async {
      await tester.pumpWidget(_wrapGlossApp());
      await tester.pump();

      final app = tester.widget<MaterialApp>(find.byType(MaterialApp));
      expect(app.routerDelegate, isNotNull);
    });

    testWidgets('routerProvider returns a GoRouter instance', (tester) async {
      final container = ProviderContainer(
        overrides: baseOverrides(),
      );
      addTearDown(container.dispose);

      final router = container.read(routerProvider);
      expect(router, isNotNull);
    });
  });
}
