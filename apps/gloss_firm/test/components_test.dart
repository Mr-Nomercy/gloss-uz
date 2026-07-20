import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ui_kit/ui_kit.dart';

Widget _wrapWithTheme(Widget child) {
  return MaterialApp(
    theme: AppTheme.light,
    home: Scaffold(body: child),
  );
}

void main() {
  group('GlossButton', () {
    testWidgets('renders label', (tester) async {
      await tester.pumpWidget(_wrapWithTheme(
        const GlossButton(label: 'Test Button', onPressed: null),
      ));
      expect(find.text('Test Button'), findsOneWidget);
    });

    testWidgets('calls onPressed when tapped', (tester) async {
      int calls = 0;
      await tester.pumpWidget(_wrapWithTheme(
        GlossButton(label: 'Tap Me', onPressed: () => calls++),
      ));
      await tester.tap(find.text('Tap Me'));
      expect(calls, 1);
    });

    testWidgets('shows loading indicator when isLoading', (tester) async {
      await tester.pumpWidget(_wrapWithTheme(
        const GlossButton(label: 'Loading', onPressed: null, isLoading: true),
      ));
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Loading'), findsNothing);
    });
  });

  group('GlossCard', () {
    testWidgets('renders child', (tester) async {
      await tester.pumpWidget(_wrapWithTheme(
        const GlossCard(child: Text('Card content')),
      ));
      expect(find.text('Card content'), findsOneWidget);
    });

    testWidgets('calls onTap when tapped', (tester) async {
      int taps = 0;
      await tester.pumpWidget(_wrapWithTheme(
        GlossCard(child: const Text('Tap'), onTap: () => taps++),
      ));
      await tester.tap(find.text('Tap'));
      expect(taps, 1);
    });
  });

  group('GlossTextField', () {
    testWidgets('renders hint', (tester) async {
      await tester.pumpWidget(_wrapWithTheme(
        const GlossTextField(hint: 'Enter text'),
      ));
      expect(find.text('Enter text'), findsOneWidget);
    });

    testWidgets('shows error text', (tester) async {
      await tester.pumpWidget(_wrapWithTheme(
        const GlossTextField(hint: 'Field', errorText: 'Invalid input'),
      ));
      expect(find.text('Invalid input'), findsOneWidget);
    });
  });

  group('GlossBadge', () {
    testWidgets('renders label', (tester) async {
      await tester.pumpWidget(_wrapWithTheme(
        const GlossBadge(label: 'New'),
      ));
      expect(find.text('New'), findsOneWidget);
    });

    testWidgets('renders success variant', (tester) async {
      await tester.pumpWidget(_wrapWithTheme(
        const GlossBadge(label: 'Done', variant: BadgeVariant.success),
      ));
      expect(find.text('Done'), findsOneWidget);
    });

    testWidgets('renders error variant', (tester) async {
      await tester.pumpWidget(_wrapWithTheme(
        const GlossBadge(label: 'Error', variant: BadgeVariant.error),
      ));
      expect(find.text('Error'), findsOneWidget);
    });

    testWidgets('factory .status parses status string', (tester) async {
      await tester.pumpWidget(_wrapWithTheme(
        GlossBadge.status('Tugallangan'),
      ));
      expect(find.text('Tugallangan'), findsOneWidget);
    });
  });

  group('GlossEmptyState', () {
    testWidgets('renders custom empty state', (tester) async {
      await tester.pumpWidget(_wrapWithTheme(
        const GlossEmptyState(
          icon: Icons.inbox,
          title: 'Nothing here',
          subtitle: 'Add items to get started',
        ),
      ));
      expect(find.text('Nothing here'), findsOneWidget);
      expect(find.text('Add items to get started'), findsOneWidget);
    });

    testWidgets('factory .orders renders correctly', (tester) async {
      await tester.pumpWidget(_wrapWithTheme(
        GlossEmptyState.orders(),
      ));
      expect(find.text("Buyurtmalar yo'q"), findsOneWidget);
    });

    testWidgets('factory .notifications renders correctly', (tester) async {
      await tester.pumpWidget(_wrapWithTheme(
        GlossEmptyState.notifications(),
      ));
      expect(find.text("Bildirishnomalar yo'q"), findsOneWidget);
    });

    testWidgets('factory .error renders correctly', (tester) async {
      await tester.pumpWidget(_wrapWithTheme(
        GlossEmptyState.error(message: 'Test error'),
      ));
      expect(find.text('Xatolik yuz berdi'), findsOneWidget);
      expect(find.text('Test error'), findsOneWidget);
    });

    testWidgets('factory .offline renders correctly', (tester) async {
      await tester.pumpWidget(_wrapWithTheme(
        GlossEmptyState.offline(),
      ));
      expect(find.text('Internetga ulanishda xatolik'), findsOneWidget);
      expect(find.text('Qayta urinish'), findsNothing);
    });

    testWidgets('factory .search renders correctly', (tester) async {
      await tester.pumpWidget(_wrapWithTheme(
        GlossEmptyState.search(query: 'test'),
      ));
      expect(find.text('"test" topilmadi'), findsOneWidget);
    });

    testWidgets('factory .comingSoon renders correctly', (tester) async {
      await tester.pumpWidget(_wrapWithTheme(
        GlossEmptyState.comingSoon(),
      ));
      expect(find.text('Tez orada'), findsOneWidget);
    });
  });

  group('GlossErrorView', () {
    testWidgets('renders default error', (tester) async {
      await tester.pumpWidget(_wrapWithTheme(
        const GlossErrorView(),
      ));
      expect(find.text('Xatolik yuz berdi'), findsOneWidget);
    });

    testWidgets('factory .connection renders correctly', (tester) async {
      await tester.pumpWidget(_wrapWithTheme(
        GlossErrorView.connection(),
      ));
      expect(find.text('Xatolik yuz berdi'), findsOneWidget);
      expect(find.text("Internetga ulanishda xatolik"), findsOneWidget);
    });

    testWidgets('renders retry button when onRetry provided', (tester) async {
      await tester.pumpWidget(_wrapWithTheme(
        GlossErrorView.connection(onRetry: () {}),
      ));
      expect(find.text("Qayta urinish"), findsOneWidget);
    });
  });

  group('GlossLoadingView', () {
    testWidgets('renders spinner', (tester) async {
      await tester.pumpWidget(_wrapWithTheme(
        const GlossLoadingView(),
      ));
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('renders message when provided', (tester) async {
      await tester.pumpWidget(_wrapWithTheme(
        const GlossLoadingView(message: 'Yuklanmoqda...'),
      ));
      expect(find.text('Yuklanmoqda...'), findsOneWidget);
    });
  });
}
