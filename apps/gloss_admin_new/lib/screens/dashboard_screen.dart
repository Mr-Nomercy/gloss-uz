import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ui_kit/ui_kit.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: const GlossAppBar(title: 'Dashboard'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1.6,
              children: const [
                GlossStatCard(
                  label: 'Total Revenue',
                  value: '142,500,000',
                  suffix: "so'm",
                  icon: Icons.trending_up,
                ),
                GlossStatCard(
                  label: 'Total Orders',
                  value: '2,847',
                  suffix: 'this month',
                  icon: Icons.shopping_cart,
                ),
                GlossStatCard(
                  label: 'Tenants',
                  value: '24',
                  suffix: 'active firms',
                  icon: Icons.business,
                ),
                GlossStatCard(
                  label: 'Users',
                  value: '12,430',
                  suffix: 'registered',
                  icon: Icons.people,
                ),
              ],
            ),
            const SizedBox(height: 24),
            const GlossSectionHeader(title: 'Revenue Overview'),
            const SizedBox(height: 12),
            Container(
              height: 200,
              decoration: BoxDecoration(
                color: GlossColors.surface,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(child: Text('Revenue Chart')),
            ),
          ],
        ),
      ),
    );
  }
}
