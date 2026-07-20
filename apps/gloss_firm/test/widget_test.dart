import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gloss_firm/main.dart';

void main() {
  testWidgets('App renders without errors', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: GlossFirmApp()));
    await tester.pump(const Duration(seconds: 2));
    expect(tester.takeException(), isNull);
  });
}
