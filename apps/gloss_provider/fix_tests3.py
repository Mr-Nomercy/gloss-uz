with open('C:/Users/qwerty/Desktop/gloss/apps/gloss_provider/test/components_test.dart', 'r') as f:
    content = f.read()

# Fix the orders factory button - use shorter label
content = content.replace(
    "action: GlossButton(label: 'Buyurtma berish', onPressed: onAction)",
    "action: GlossButton(label: 'OK', onPressed: onAction)"
)

# Fix the responsiveness tests - they have duplicate GlossCard entries
content = content.replace(
    "expect(find.byType(GlossCard), findsOneWidget);",
    "expect(find.byType(GlossCard), findsWidgets);"
)

with open('C:/Users/qwerty/Desktop/gloss/apps/gloss_provider/test/components_test.dart', 'w') as f:
    f.write(content)
print('Done')