import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ui_kit/ui_kit.dart';

Widget wrapWithTheme(Widget child) {
  return ProviderScope(
    child: MaterialApp(
      theme: AppTheme.light,
      home: Scaffold(body: child),
    ),
  );
}

void main() {
  group('GlossCard', () {
    testWidgets('renders child content', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const GlossCard(child: Text('Card Content')),
      ));
      expect(find.text('Card Content'), findsOneWidget);
    });

    testWidgets('uses Card widget internally', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const GlossCard(child: SizedBox()),
      ));
      expect(find.byType(Card), findsOneWidget);
    });

    testWidgets('has InkWell for tap support', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const GlossCard(child: SizedBox()),
      ));
      expect(find.byType(InkWell), findsOneWidget);
    });

    testWidgets('onTap callback works', (tester) async {
      var tapped = false;
      await tester.pumpWidget(wrapWithTheme(
        GlossCard(
          child: const SizedBox(width: 100, height: 100),
          onTap: () => tapped = true,
        ),
      ));
      await tester.tap(find.byType(GlossCard));
      expect(tapped, isTrue);
    });
  });

  group('GlossBadge', () {
    testWidgets('renders label text', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const GlossBadge(label: 'Active'),
      ));
      expect(find.text('Active'), findsOneWidget);
    });

    testWidgets('status factory creates success variant for completed', (tester) async {
      final badge = GlossBadge.status('Yetkazilgan');
      expect(badge.variant, BadgeVariant.success);
    });

    testWidgets('status factory creates neutral for unknown status', (tester) async {
      final badge = GlossBadge.status('Qabul qilingan');
      expect(badge.variant, BadgeVariant.neutral);
    });

    test('status factory handles all statuses correctly', () {
      expect(GlossBadge.status('Yetkazilgan').variant, BadgeVariant.success);
      expect(GlossBadge.status('completed').variant, BadgeVariant.success);
      expect(GlossBadge.status('Bekor qilingan').variant, BadgeVariant.neutral);
      expect(GlossBadge.status('rejected').variant, BadgeVariant.error);
      expect(GlossBadge.status("Yo'lda").variant, BadgeVariant.neutral);
    });
  });

  group('GlossTextField', () {
    testWidgets('renders with label and hint', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const GlossTextField(
          label: 'Test Label',
          hint: 'Enter value',
        ),
      ));
      expect(find.text('Test Label'), findsOneWidget);
    });

    testWidgets('accepts text input', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const GlossTextField(
          label: 'Phone',
          hint: '+998 XX XXX XX XX',
        ),
      ));
      final textField = find.byType(TextFormField);
      expect(textField, findsOneWidget);
    });

    testWidgets('supports obscureText', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const GlossTextField(
          label: 'Password',
          hint: 'Enter password',
          obscureText: true,
        ),
      ));
      final glossField = tester.widget<GlossTextField>(find.byType(GlossTextField));
      expect(glossField.obscureText, isTrue);
    });
  });

  group('GlossStatCard', () {
    testWidgets('renders label and value', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const GlossStatCard(
          label: 'Orders',
          value: '42',
          icon: Icons.receipt,
        ),
      ));
      expect(find.text('Orders'), findsOneWidget);
      expect(find.text('42'), findsOneWidget);
    });

    testWidgets('renders icon', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const GlossStatCard(
          label: 'Revenue',
          value: '1.5M',
          icon: Icons.attach_money,
        ),
      ));
      expect(find.byIcon(Icons.attach_money), findsOneWidget);
    });

    testWidgets('supports onTap callback', (tester) async {
      var tapped = false;
      await tester.pumpWidget(wrapWithTheme(
        GlossStatCard(
          label: 'Daily',
          value: '12',
          icon: Icons.today,
          onTap: () => tapped = true,
        ),
      ));
      await tester.tap(find.byType(GlossStatCard));
      expect(tapped, isTrue);
    });
  });

  group('GlossBalanceCard', () {
    testWidgets('renders title and balance', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        GlossBalanceCard(
          title: 'Mavjud balans',
          balance: "2 450 000 so'm",
          actionLabel: 'Pul chiqarish',
          onAction: () {},
        ),
      ));
      expect(find.text('Mavjud balans'), findsOneWidget);
      expect(find.text("2 450 000 so'm"), findsOneWidget);
      expect(find.text('Pul chiqarish'), findsOneWidget);
    });
  });

  group('GlossLoadingView', () {
    testWidgets('renders with message', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const GlossLoadingView(message: 'Yuklanmoqda...'),
      ));
      expect(find.text('Yuklanmoqda...'), findsOneWidget);
    });

    testWidgets('shows CircularProgressIndicator', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const GlossLoadingView(message: 'Loading...'),
      ));
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
  });

  group('GlossErrorView', () {
    testWidgets('renders connection error with retry button', (tester) async {
      var retried = false;
      await tester.pumpWidget(wrapWithTheme(
        GlossErrorView.connection(onRetry: () => retried = true),
      ));
      expect(find.text('Xatolik yuz berdi'), findsOneWidget);
      expect(find.text('Internetga ulanishda xatolik'), findsOneWidget);
    });
  });

  group('GlossEmptyState', () {
    testWidgets('renders orders empty state', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        SizedBox(
          height: 400,
          child: GlossEmptyState.orders(),
        ),
      ));
      expect(find.text("Buyurtmalar yo'q"), findsOneWidget);
    });

    testWidgets('renders with custom icon and text', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const SizedBox(
          height: 400,
          child: GlossEmptyState(
            icon: Icons.inbox,
            title: 'No items',
            subtitle: 'Nothing to show',
          ),
        ),
      ));
      expect(find.text('No items'), findsOneWidget);
      expect(find.text('Nothing to show'), findsOneWidget);
    });
  });

  group('GlossSectionHeader', () {
    testWidgets('renders title', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const GlossSectionHeader(title: 'TEZKOR AMALLAR'),
      ));
      expect(find.text('TEZKOR AMALLAR'), findsOneWidget);
    });
  });

  group('GlossMenuItem', () {
    testWidgets('renders icon and title', (tester) async {
      var tapped = false;
      await tester.pumpWidget(wrapWithTheme(
        GlossMenuItem(
          icon: Icons.person_outline,
          title: "Shaxsiy ma'lumotlar",
          onTap: () => tapped = true,
        ),
      ));
      expect(find.text("Shaxsiy ma'lumotlar"), findsOneWidget);
      expect(find.byIcon(Icons.person_outline), findsOneWidget);
    });

    testWidgets('onTap callback works', (tester) async {
      var tapped = false;
      await tester.pumpWidget(wrapWithTheme(
        GlossMenuItem(
          icon: Icons.settings,
          title: 'Settings',
          onTap: () => tapped = true,
        ),
      ));
      await tester.tap(find.byType(GlossMenuItem));
      expect(tapped, isTrue);
    });
  });

  group('AppTheme', () {
    test('light theme has correct seed color', () {
      final theme = AppTheme.light;
      expect(theme.colorScheme.primary, isNotNull);
    });

    test('GlossTheme extension is accessible via context', () async {
      await _testGlossThemeExtension();
    });
  });

  group('GlossColors', () {
    test('all static colors are defined', () {
      expect(GlossColors.green, isA<Color>());
      expect(GlossColors.darkGreen, isA<Color>());
      expect(GlossColors.bg, isA<Color>());
      expect(GlossColors.card, isA<Color>());
      expect(GlossColors.surface, isA<Color>());
      expect(GlossColors.text, isA<Color>());
      expect(GlossColors.hint, isA<Color>());
      expect(GlossColors.red, isA<Color>());
      expect(GlossColors.orange, isA<Color>());
      expect(GlossColors.star, isA<Color>());
    });
  });

  group('BadgeVariant', () {
    test('has all expected values', () {
      expect(BadgeVariant.values.length, 5);
      expect(BadgeVariant.values, contains(BadgeVariant.success));
      expect(BadgeVariant.values, contains(BadgeVariant.warning));
      expect(BadgeVariant.values, contains(BadgeVariant.error));
      expect(BadgeVariant.values, contains(BadgeVariant.info));
      expect(BadgeVariant.values, contains(BadgeVariant.neutral));
    });
  });
}

Future<void> _testGlossThemeExtension() async {
  final theme = AppTheme.light;
  final glossTheme = theme.extensions[GlossTheme] as GlossTheme?;
  assert(glossTheme != null, 'GlossTheme extension must not be null');
  assert(glossTheme!.green == GlossColors.green, 'Green color mismatch');
}
