import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:go_router/go_router.dart';
import 'package:ui_kit/ui_kit.dart';
import '../providers/auth_provider.dart';

final _courierProfileStatsProvider = Provider<_CourierProfileStats>((ref) {
  return const _CourierProfileStats(totalDeliveries: 486, totalDistance: 3285, memberSince: 'Mart 2025');
});

class CourierProfileTab extends ConsumerWidget {
  const CourierProfileTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = context.gloss;
    final authState = ref.watch(authProvider);
    final stats = ref.watch(_courierProfileStatsProvider);
    final user = authState.user;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              const SizedBox(height: 16),
              CircleAvatar(
                radius: 44,
                backgroundColor: theme.green.withValues(alpha: 0.1),
                child: Text(
                  (user?.fullName ?? 'J')[0].toUpperCase(),
                  style: TextStyle(fontSize: 36, fontWeight: FontWeight.w700, color: theme.green),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                user?.fullName ?? 'Kuryer',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: theme.text),
              ),
              const SizedBox(height: 4),
              Text(
                user?.phone ?? '',
                style: TextStyle(fontSize: 14, color: theme.hint),
              ),
              const SizedBox(height: 8),
              RatingBar.builder(
                initialRating: 4.8,
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                itemSize: 22,
                ignoreGestures: true,
                itemBuilder: (context, _) => const Icon(Icons.star_rounded, color: Color(0xFFFFB300)),
                onRatingUpdate: (_) {},
              ),
              const SizedBox(height: 4),
              Text('4.8 (186 ta baho)', style: TextStyle(fontSize: 12, color: theme.hint)),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: theme.border),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Transport', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: theme.text)),
                    const SizedBox(height: 12),
                    _InfoRow(icon: Icons.directions_car_rounded, label: 'Model', value: 'Chevrolet Spark'),
                    const SizedBox(height: 8),
                    _InfoRow(icon: Icons.confirmation_number_rounded, label: 'Raqam', value: '01A234BC'),
                    const SizedBox(height: 8),
                    _InfoRow(icon: Icons.color_lens_rounded, label: 'Rangi', value: 'Oq'),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(child: _StatsTile(icon: Icons.inventory_2_rounded, value: '${stats.totalDeliveries}', label: 'Buyurtmalar', color: theme.green)),
                  const SizedBox(width: 10),
                  Expanded(child: _StatsTile(icon: Icons.route_rounded, value: '${stats.totalDistance} km', label: 'Masofa', color: GlossColors.catBlue)),
                  const SizedBox(width: 10),
                  Expanded(child: _StatsTile(icon: Icons.calendar_month_rounded, value: stats.memberSince, label: 'A\'zo', color: GlossColors.catPurple)),
                ],
              ),
              const SizedBox(height: 24),
              GlossButton(
                label: 'Chiqish',
                isOutlined: true,
                onPressed: () {
                  ref.read(authProvider.notifier).logout();
                  context.go('/login');
                },
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

class _CourierProfileStats {
  final int totalDeliveries;
  final int totalDistance;
  final String memberSince;
  const _CourierProfileStats({required this.totalDeliveries, required this.totalDistance, required this.memberSince});
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _InfoRow({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final theme = context.gloss;
    return Row(
      children: [
        Icon(icon, size: 18, color: theme.hint),
        const SizedBox(width: 10),
        Text('$label:', style: TextStyle(fontSize: 13, color: theme.hint)),
        const SizedBox(width: 6),
        Text(value, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: theme.text)),
      ],
    );
  }
}

class _StatsTile extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color color;
  const _StatsTile({required this.icon, required this.value, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    final theme = context.gloss;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withValues(alpha: 0.12)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(value, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: theme.text)),
          ),
          const SizedBox(height: 2),
          Text(label, style: TextStyle(fontSize: 11, color: theme.hint)),
        ],
      ),
    );
  }
}
