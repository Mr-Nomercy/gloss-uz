import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ui_kit/ui_kit.dart';

class UsersScreen extends ConsumerWidget {
  const UsersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: const GlossAppBar(title: 'Foydalanuvchilar'),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: 15,
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemBuilder: (context, index) {
          return GlossCard(
            child: ListTile(
              leading: const CircleAvatar(
                backgroundColor: GlossColors.greenBgLight,
                child: Icon(Icons.person, color: GlossColors.green),
              ),
              title: Text('User ${index + 1}'),
              subtitle: Text('user${index + 1}@example.com'),
              trailing: Text(
                '${index * 3} orders',
                style: const TextStyle(color: GlossColors.hint),
              ),
              onTap: () {},
            ),
          );
        },
      ),
    );
  }
}
