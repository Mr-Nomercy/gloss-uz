import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ui_kit/ui_kit.dart';

class PayoutsScreen extends ConsumerWidget {
  const PayoutsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: const GlossAppBar(title: 'To\'lovlar'),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: 8,
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemBuilder: (context, index) {
          return GlossCard(
            child: ListTile(
              leading: const Icon(Icons.payment, color: GlossColors.green),
              title: Text('Payout #${500 + index}'),
              subtitle: Text('Tenant ${index + 1}'),
              trailing: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${(50000 + index * 12000)} so\'m',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const Text(
                    'Paid',
                    style: TextStyle(fontSize: 12, color: GlossColors.green),
                  ),
                ],
              ),
              onTap: () {},
            ),
          );
        },
      ),
    );
  }
}
