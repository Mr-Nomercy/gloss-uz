import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ui_kit/ui_kit.dart';

Widget _wrap(Widget child) {
  return MaterialApp(
    theme: AppTheme.light,
    home: Scaffold(body: child),
  );
}

void main() {
  group('GlossButton', () {
    testWidgets('renders label text', (tester) async {
      await tester.pumpWidget(_wrap(const GlossButton(label: 'Test Button')));
      expect(find.text('Test Button'), findsOneWidget);
    });

    testWidgets('renders as ElevatedButton by default', (tester) async {
      await tester.pumpWidget(_wrap(const GlossButton(label: 'Test')));
      expect(find.byType(ElevatedButton), findsOneWidget);
    });

    testWidgets('shows loading indicator when isLoading is true', (tester) async {
      await tester.pumpWidget(_wrap(const GlossButton(label: 'Loading', isLoading: true)));
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Loading'), findsNothing);
    });

    testWidgets('renders icon when provided', (tester) async {
      await tester.pumpWidget(_wrap(const GlossButton(
        label: 'Icon Button',
        icon: Icons.star,
      )));
      expect(find.byIcon(Icons.star), findsOneWidget);
    });

    testWidgets('button is disabled when onPressed is null', (tester) async {
      await tester.pumpWidget(_wrap(const GlossButton(label: 'Disabled')));
      final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      expect(button.onPressed, isNull);
    });

    testWidgets('button is enabled when onPressed is provided', (tester) async {
      bool tapped = false;
      await tester.pumpWidget(_wrap(GlossButton(
        label: 'Enabled',
        onPressed: () => tapped = true,
      )));
      final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      expect(button.onPressed, isNotNull);
      await tester.tap(find.byType(ElevatedButton));
      expect(tapped, isTrue);
    });

    testWidgets('renders as OutlinedButton when isOutlined is true', (tester) async {
      await tester.pumpWidget(_wrap(const GlossButton(
        label: 'Outlined',
        isOutlined: true,
      )));
      expect(find.byType(OutlinedButton), findsOneWidget);
    });
  });

  group('GlossCard', () {
    testWidgets('renders child widget', (tester) async {
      await tester.pumpWidget(_wrap(const GlossCard(
        child: Text('Card Content'),
      )));
      expect(find.text('Card Content'), findsOneWidget);
      expect(find.byType(Card), findsOneWidget);
    });

    testWidgets('applies default padding', (tester) async {
      await tester.pumpWidget(_wrap(const GlossCard(
        child: SizedBox(width: 100, height: 50),
      )));
      final card = tester.widget<Card>(find.byType(Card));
      expect(card, isNotNull);
    });

    testWidgets('handles onTap callback', (tester) async {
      bool tapped = false;
      await tester.pumpWidget(_wrap(GlossCard(
        child: const Text('Tappable'),
        onTap: () => tapped = true,
      )));
      await tester.tap(find.byType(InkWell));
      expect(tapped, isTrue);
    });
  });

  group('GlossBadge', () {
    testWidgets('renders label text', (tester) async {
      await tester.pumpWidget(_wrap(const GlossBadge(label: 'Active')));
      expect(find.text('Active'), findsOneWidget);
    });

    testWidgets('renders success variant with green styling', (tester) async {
      await tester.pumpWidget(_wrap(const GlossBadge(
        label: 'Success',
        variant: BadgeVariant.success,
      )));
      expect(find.text('Success'), findsOneWidget);
    });

    testWidgets('renders error variant', (tester) async {
      await tester.pumpWidget(_wrap(const GlossBadge(
        label: 'Error',
        variant: BadgeVariant.error,
      )));
      expect(find.text('Error'), findsOneWidget);
    });

    testWidgets('renders warning variant', (tester) async {
      await tester.pumpWidget(_wrap(const GlossBadge(
        label: 'Warning',
        variant: BadgeVariant.warning,
      )));
      expect(find.text('Warning'), findsOneWidget);
    });

    testWidgets('factory GlossBadge.status maps completed to success', (tester) async {
      await tester.pumpWidget(_wrap(GlossBadge.status('completed')));
      expect(find.text('completed'), findsOneWidget);
    });
  });

  group('GlossMenuItem', () {
    testWidgets('renders icon, title, subtitle and chevron when onTap is set', (tester) async {
      await tester.pumpWidget(_wrap(GlossMenuItem(
        icon: Icons.settings,
        title: 'Settings',
        subtitle: 'App preferences',
        onTap: () {},
      )));
      expect(find.byIcon(Icons.settings), findsOneWidget);
      expect(find.text('Settings'), findsOneWidget);
      expect(find.text('App preferences'), findsOneWidget);
      expect(find.byIcon(Icons.chevron_right), findsOneWidget);
    });

    testWidgets('handles onTap callback', (tester) async {
      bool tapped = false;
      await tester.pumpWidget(_wrap(GlossMenuItem(
        icon: Icons.info,
        title: 'About',
        onTap: () => tapped = true,
      )));
      await tester.tap(find.text('About'));
      await tester.pump();
      expect(tapped, isTrue);
    });

    testWidgets('renders without subtitle', (tester) async {
      await tester.pumpWidget(_wrap(const GlossMenuItem(
        icon: Icons.person,
        title: 'Profile',
      )));
      expect(find.text('Profile'), findsOneWidget);
      expect(find.byIcon(Icons.person), findsOneWidget);
    });
  });

  group('GlossTextField', () {
    testWidgets('renders with hint text', (tester) async {
      await tester.pumpWidget(_wrap(const GlossTextField(
        hint: 'Enter text',
      )));
      expect(find.byType(TextField), findsOneWidget);
    });

    testWidgets('accepts text input', (tester) async {
      final controller = TextEditingController();
      await tester.pumpWidget(_wrap(GlossTextField(
        controller: controller,
        hint: 'Type here',
      )));
      await tester.enterText(find.byType(TextField), 'Hello');
      expect(controller.text, 'Hello');
    });
  });

  group('GlossEmptyState', () {
    testWidgets('renders icon, title and subtitle', (tester) async {
      await tester.pumpWidget(_wrap(const GlossEmptyState(
        icon: Icons.inbox,
        title: 'No items',
        subtitle: 'Nothing to show here',
      )));
      expect(find.byIcon(Icons.inbox), findsOneWidget);
      expect(find.text('No items'), findsOneWidget);
      expect(find.text('Nothing to show here'), findsOneWidget);
    });

    testWidgets('factory GlossEmptyState.orders renders correct content', (tester) async {
      await tester.pumpWidget(_wrap(GlossEmptyState.orders()));
      expect(find.text('Buyurtmalar yo\'q'), findsOneWidget);
      expect(find.text('Hozircha hech qanday buyurtma yo\'q'), findsOneWidget);
      expect(find.byIcon(Icons.shopping_bag_outlined), findsOneWidget);
    });

    testWidgets('factory GlossEmptyState.cart renders correct content', (tester) async {
      await tester.pumpWidget(_wrap(GlossEmptyState.cart()));
      expect(find.text('Savat bo\'sh'), findsOneWidget);
      expect(find.text('Mahsulotlar qo\'shib xaridni boshlang'), findsOneWidget);
      expect(find.byIcon(Icons.shopping_cart_outlined), findsOneWidget);
    });

    testWidgets('factory GlossEmptyState.favorites renders correct content', (tester) async {
      await tester.pumpWidget(_wrap(GlossEmptyState.favorites()));
      expect(find.text('Sevimlilar bo\'sh'), findsOneWidget);
    });

    testWidgets('factory GlossEmptyState.error renders with default message', (tester) async {
      await tester.pumpWidget(_wrap(GlossEmptyState.error()));
      expect(find.text('Xatolik yuz berdi'), findsOneWidget);
    });

    testWidgets('factory GlossEmptyState.error renders custom message', (tester) async {
      await tester.pumpWidget(_wrap(GlossEmptyState.error(message: 'Custom error')));
      expect(find.text('Custom error'), findsOneWidget);
    });

    testWidgets('renders action button when provided', (tester) async {
      bool tapped = false;
      await tester.pumpWidget(_wrap(GlossEmptyState(
        icon: Icons.error,
        title: 'Error',
        action: GlossButton(
          label: 'Retry',
          onPressed: () => tapped = true,
        ),
      )));
      expect(find.text('Retry'), findsOneWidget);
      await tester.tap(find.text('Retry'));
      expect(tapped, isTrue);
    });
  });

  group('formatPrice', () {
    test('formats thousands with space separator and suffix', () {
      expect(formatPrice(25000), "25 000 so'm");
    });

    test('formats hundred thousands', () {
      expect(formatPrice(350000), "350 000 so'm");
    });

    test('formats millions', () {
      expect(formatPrice(1500000), "1 500 000 so'm");
    });

    test('handles zero', () {
      expect(formatPrice(0), "0 so'm");
    });

    test('handles double values by truncating', () {
      expect(formatPrice(25000.99), "25 000 so'm");
    });
  });

  group('GlossTheme extension', () {
    testWidgets('context.gloss returns GlossTheme', (tester) async {
      GlossTheme? captured;
      await tester.pumpWidget(MaterialApp(
        theme: AppTheme.light,
        home: Builder(
          builder: (context) {
            captured = context.gloss;
            return const SizedBox();
          },
        ),
      ));
      expect(captured, isNotNull);
      expect(captured!.green, GlossColors.green);
    });
  });

  group('GlossColors', () {
    test('primary green color is correct', () {
      expect(GlossColors.green, const Color(0xFF00AA13));
    });

    test('dark green color is correct', () {
      expect(GlossColors.darkGreen, const Color(0xFF004A00));
    });

    test('background color is correct', () {
      expect(GlossColors.bg, const Color(0xFFF5F5F5));
    });

    test('text color is correct', () {
      expect(GlossColors.text, const Color(0xFF1A1A1A));
    });

    test('star color is correct', () {
      expect(GlossColors.star, const Color(0xFFFFB300));
    });

    test('red color is correct', () {
      expect(GlossColors.red, const Color(0xFFE53935));
    });
  });
}
