import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ui_kit/ui_kit.dart';

Widget wrapComponent(Widget child) {
  return MaterialApp(
    theme: AppTheme.light,
    home: Scaffold(
      body: Center(child: child),
    ),
  );
}

void main() {
  group('GlossButton', () {
    testWidgets('renders label text', (tester) async {
      await tester.pumpWidget(
        wrapComponent(const GlossButton(label: 'Test Button', onPressed: null)),
      );
      expect(find.text('Test Button'), findsOneWidget);
    });

    testWidgets('shows loading indicator', (tester) async {
      await tester.pumpWidget(
        wrapComponent(const GlossButton(label: 'Loading', isLoading: true, onPressed: null)),
      );
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('is disabled when onPressed is null', (tester) async {
      await tester.pumpWidget(
        wrapComponent(const GlossButton(label: 'Disabled', onPressed: null)),
      );
      final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      expect(button.onPressed, isNull);
    });

    testWidgets('calls onPressed when tapped', (tester) async {
      int tapCount = 0;
      await tester.pumpWidget(
        wrapComponent(GlossButton(
          label: 'Tap me',
          onPressed: () => tapCount++,
        )),
      );
      await tester.tap(find.text('Tap me'));
      expect(tapCount, 1);
    });

    testWidgets('renders with icon', (tester) async {
      await tester.pumpWidget(
        wrapComponent(const GlossButton(
          label: 'With Icon',
          icon: Icons.add,
          onPressed: null,
        )),
      );
      expect(find.byIcon(Icons.add), findsOneWidget);
    });

    testWidgets('renders outlined variant', (tester) async {
      await tester.pumpWidget(
        wrapComponent(const GlossButton(
          label: 'Outlined',
          isOutlined: true,
          onPressed: null,
        )),
      );
      expect(find.byType(OutlinedButton), findsOneWidget);
    });
  });

  group('GlossCard', () {
    testWidgets('renders child widget', (tester) async {
      await tester.pumpWidget(
        wrapComponent(const GlossCard(
          child: Text('Card Content'),
        )),
      );
      expect(find.text('Card Content'), findsOneWidget);
      expect(find.byType(Card), findsOneWidget);
    });

    testWidgets('applies custom padding', (tester) async {
      await tester.pumpWidget(
        wrapComponent(const GlossCard(
          padding: EdgeInsets.all(32),
          child: Text('Padded'),
        )),
      );
      final card = tester.widget<Card>(find.byType(Card));
      expect(card.elevation, 1);
    });

    testWidgets('calls onTap when tapped', (tester) async {
      int tapCount = 0;
      await tester.pumpWidget(
        wrapComponent(GlossCard(
          child: const Text('Tappable'),
          onTap: () => tapCount++,
        )),
      );
      await tester.tap(find.text('Tappable'));
      expect(tapCount, 1);
    });
  });

  group('GlossTextField', () {
    testWidgets('renders with label', (tester) async {
      await tester.pumpWidget(
        wrapComponent(const GlossTextField(label: 'Test Label')),
      );
      expect(find.text('Test Label'), findsOneWidget);
    });

    testWidgets('renders with hint', (tester) async {
      await tester.pumpWidget(
        wrapComponent(const GlossTextField(hint: 'Enter text')),
      );
      expect(find.text('Enter text'), findsOneWidget);
    });

    testWidgets('updates via controller', (tester) async {
      final controller = TextEditingController();
      await tester.pumpWidget(
        wrapComponent(GlossTextField(controller: controller)),
      );
      controller.text = 'Hello';
      await tester.pump();
      expect(find.text('Hello'), findsOneWidget);
    });

    testWidgets('shows error text', (tester) async {
      await tester.pumpWidget(
        wrapComponent(const GlossTextField(
          label: 'Field',
          errorText: 'This field is required',
        )),
      );
      expect(find.text('This field is required'), findsOneWidget);
    });

    testWidgets('obscureText hides input', (tester) async {
      await tester.pumpWidget(
        wrapComponent(const GlossTextField(
          label: 'Password',
          obscureText: true,
        )),
      );
      expect(find.byType(TextFormField), findsOneWidget);
    });

    testWidgets('calls onChanged when typing', (tester) async {
      String value = '';
      await tester.pumpWidget(
        wrapComponent(GlossTextField(
          label: 'Input',
          onChanged: (v) => value = v,
        )),
      );
      await tester.enterText(find.byType(TextFormField), 'test');
      expect(value, 'test');
    });

    testWidgets('respects readOnly', (tester) async {
      await tester.pumpWidget(
        wrapComponent(const GlossTextField(
          label: 'ReadOnly',
          readOnly: true,
        )),
      );
      expect(find.byType(TextFormField), findsOneWidget);
    });
  });

  group('GlossBadge', () {
    testWidgets('renders success badge', (tester) async {
      await tester.pumpWidget(
        wrapComponent(const GlossBadge(
          label: 'Success',
          variant: BadgeVariant.success,
        )),
      );
      expect(find.text('Success'), findsOneWidget);
    });

    testWidgets('renders warning badge', (tester) async {
      await tester.pumpWidget(
        wrapComponent(const GlossBadge(
          label: 'Warning',
          variant: BadgeVariant.warning,
        )),
      );
      expect(find.text('Warning'), findsOneWidget);
    });

    testWidgets('renders error badge', (tester) async {
      await tester.pumpWidget(
        wrapComponent(const GlossBadge(
          label: 'Error',
          variant: BadgeVariant.error,
        )),
      );
      expect(find.text('Error'), findsOneWidget);
    });

    testWidgets('renders info badge', (tester) async {
      await tester.pumpWidget(
        wrapComponent(const GlossBadge(
          label: 'Info',
          variant: BadgeVariant.info,
        )),
      );
      expect(find.text('Info'), findsOneWidget);
    });

    testWidgets('renders neutral badge', (tester) async {
      await tester.pumpWidget(
        wrapComponent(const GlossBadge(
          label: 'Neutral',
          variant: BadgeVariant.neutral,
        )),
      );
      expect(find.text('Neutral'), findsOneWidget);
    });

    testWidgets('status factory creates badge', (tester) async {
      await tester.pumpWidget(
        wrapComponent(GlossBadge.status('completed')),
      );
      expect(find.text('completed'), findsOneWidget);
    });
  });

  group('GlossLoadingView', () {
    testWidgets('renders with message', (tester) async {
      await tester.pumpWidget(
        wrapComponent(const GlossLoadingView(message: 'Loading data...')),
      );
      expect(find.text('Loading data...'), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('renders without message', (tester) async {
      await tester.pumpWidget(
        wrapComponent(const GlossLoadingView()),
      );
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
  });

  group('GlossErrorView', () {
    testWidgets('renders connection error', (tester) async {
      await tester.pumpWidget(
        wrapComponent(GlossErrorView.connection(onRetry: () {})),
      );
      expect(find.text("Internetga ulanishda xatolik"), findsOneWidget);
      expect(find.text("Qayta urinish"), findsOneWidget);
    });

    testWidgets('calls onRetry when retry tapped', (tester) async {
      int retryCount = 0;
      await tester.pumpWidget(
        wrapComponent(GlossErrorView.connection(onRetry: () => retryCount++)),
      );
      await tester.tap(find.text("Qayta urinish"));
      expect(retryCount, 1);
    });
  });

  group('GlossEmptyState', () {
    testWidgets('renders with title and subtitle', (tester) async {
      await tester.pumpWidget(
        wrapComponent(const GlossEmptyState(
          icon: Icons.inbox,
          title: 'No items',
          subtitle: 'Your list is empty',
        )),
      );
      expect(find.text('No items'), findsOneWidget);
      expect(find.text('Your list is empty'), findsOneWidget);
      expect(find.byIcon(Icons.inbox), findsOneWidget);
    });

    testWidgets('renders with action button', (tester) async {
      int actionCount = 0;
      await tester.pumpWidget(
        wrapComponent(GlossEmptyState(
          icon: Icons.error,
          title: 'Error',
          action: GlossButton(
            label: 'Retry',
            onPressed: () => actionCount++,
          ),
        )),
      );
      expect(find.text('Retry'), findsOneWidget);
      await tester.tap(find.text('Retry'));
      expect(actionCount, 1);
    });
  });

  group('GlossMenuItem', () {
    testWidgets('renders with title and icon', (tester) async {
      await tester.pumpWidget(
        wrapComponent(const GlossMenuItem(
          icon: Icons.settings,
          title: 'Settings',
        )),
      );
      expect(find.text('Settings'), findsOneWidget);
      expect(find.byIcon(Icons.settings), findsOneWidget);
    });

    testWidgets('calls onTap when tapped', (tester) async {
      int tapCount = 0;
      await tester.pumpWidget(
        wrapComponent(GlossMenuItem(
          icon: Icons.home,
          title: 'Home',
          onTap: () => tapCount++,
        )),
      );
      await tester.tap(find.text('Home'));
      expect(tapCount, 1);
    });

    testWidgets('destructive variant has red title', (tester) async {
      await tester.pumpWidget(
        wrapComponent(GlossMenuItem.destructive(
          icon: Icons.delete,
          title: 'Delete',
        )),
      );
      expect(find.text('Delete'), findsOneWidget);
    });
  });
}
