import 'package:flutter_test/flutter_test.dart';

import 'package:gloss_admin/main.dart';

void main() {
  testWidgets('App renders login screen', (WidgetTester tester) async {
    await tester.pumpWidget(const GlossAdminApp());
    expect(find.text('Gloss Admin'), findsOneWidget);
  });
}
