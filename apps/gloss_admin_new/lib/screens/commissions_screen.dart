import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ui_kit/ui_kit.dart';

class CommissionsScreen extends ConsumerWidget {
  const CommissionsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: const GlossAppBar(title: 'Commisions'),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: 5,
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemBuilder: (context, index) {
          return GlossCard(
            child: ListTile(
              leading: const Icon(Icons.percent, color: GlossColors.green),
              title: Text('Service Type ${index + 1}'),
              subtitle: Text('Commission: ${(index + 1) * 5}%'),
              trailing: const Icon(Icons.edit, color: GlossColors.hint),
              onTap: () {},
            ),
          );
        },
      ),
    );
  }
}
