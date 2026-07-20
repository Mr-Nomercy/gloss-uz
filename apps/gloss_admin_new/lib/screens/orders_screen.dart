import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ui_kit/ui_kit.dart';

class OrdersScreen extends ConsumerWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: const GlossAppBar(title: 'Buyurtmalar'),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: 20,
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemBuilder: (context, index) {
          return GlossCard(
            child: ListTile(
              leading: const Icon(Icons.receipt_long, color: GlossColors.green),
              title: Text('Order #${2000 + index}'),
              subtitle: const Text('Status: Completed'),
              trailing: Text(
                '${(10000 + index * 5000)} so\'m',
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              onTap: () {},
            ),
          );
        },
      ),
    );
  }
}
