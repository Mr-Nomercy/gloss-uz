import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ui_kit/ui_kit.dart';

Widget wrapWithProviders(Widget child) {
  return ProviderScope(
    child: MaterialApp(
      theme: AppTheme.light,
      home: child,
    ),
  );
}

void main() {
  testWidgets('ProviderScope wraps a MaterialApp', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          theme: AppTheme.light,
          home: const Scaffold(body: Center(child: Text('Hello'))),
        ),
      ),
    );
    expect(find.text('Hello'), findsOneWidget);
  });

  testWidgets('Scaffold with GlossButton renders', (tester) async {
    await tester.pumpWidget(
      wrapWithProviders(
        const Scaffold(
          body: Center(
            child: GlossButton(label: 'Test', onPressed: null),
          ),
        ),
      ),
    );
    expect(find.text('Test'), findsOneWidget);
  });

  testWidgets('Scaffold with GlossCard renders', (tester) async {
    await tester.pumpWidget(
      wrapWithProviders(
        const Scaffold(
          body: Center(
            child: GlossCard(child: Text('Card Content')),
          ),
        ),
      ),
    );
    expect(find.text('Card Content'), findsOneWidget);
  });

  testWidgets('Scaffold with GlossTextField renders', (tester) async {
    await tester.pumpWidget(
      wrapWithProviders(
        const Scaffold(
          body: Center(
            child: GlossTextField(label: 'Name', hint: 'Enter name'),
          ),
        ),
      ),
    );
    expect(find.text('Name'), findsOneWidget);
  });
}
