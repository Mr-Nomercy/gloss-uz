import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:go_router/go_router.dart';
import 'package:ui_kit/ui_kit.dart';
import '../providers/auth_provider.dart';

final _workerProfileStatsProvider = Provider<_WorkerProfileStats>((ref) {
  return const _WorkerProfileStats(totalOrders: 148, rating: 4.7, experience: '1 yil 4 oy');
});

class WorkerProfileTab extends ConsumerWidget {
  const WorkerProfileTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = context.gloss;
    final authState = ref.watch(authProvider);
    final stats = ref.watch(_workerProfileStatsProvider);
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
                  (user?.fullName ?? 'D')[0].toUpperCase(),
                  style: TextStyle(fontSize: 36, fontWeight: FontWeight.w700, color: theme.green),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                user?.fullName ?? 'Tozalash xodimi',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: theme.text),
              ),
              const SizedBox(height: 4),
              Text(
                user?.phone ?? '',
                style: TextStyle(fontSize: 14, color: theme.hint),
              ),
              const SizedBox(height: 8),
              RatingBar.builder(
                initialRating: 4.7,
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
              Text('4.7 (142 ta baho)', style: TextStyle(fontSize: 12, color: theme.hint)),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: _StatTile(icon: Icons.receipt_long_rounded, value: '${stats.totalOrders}', label: 'Buyurtmalar', color: theme.green),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _StatTile(icon: Icons.star_rounded, value: '${stats.rating}', label: 'Reyting', color: GlossColors.star),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _StatTile(icon: Icons.timer_rounded, value: stats.experience, label: 'Ish staji', color: GlossColors.catPurple),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              _MenuItem(icon: Icons.settings_rounded, label: 'Sozlamalar', theme: theme, onTap: () {}),
              _MenuItem(icon: Icons.help_outline_rounded, label: 'Yordam', theme: theme, onTap: () {}),
              _MenuItem(icon: Icons.info_outline_rounded, label: 'Dastur haqida', theme: theme, onTap: () {}, showDivider: false),
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

class _WorkerProfileStats {
  final int totalOrders;
  final double rating;
  final String experience;
  const _WorkerProfileStats({required this.totalOrders, required this.rating, required this.experience});
}

class _StatTile extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color color;

  const _StatTile({required this.icon, required this.value, required this.label, required this.color});

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

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final GlossTheme theme;
  final VoidCallback onTap;
  final bool showDivider;

  const _MenuItem({required this.icon, required this.label, required this.theme, required this.onTap, this.showDivider = true});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: theme.green.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: theme.green, size: 18),
          ),
          title: Text(label, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: theme.text)),
          trailing: Icon(Icons.chevron_right_rounded, color: theme.disabled, size: 20),
          onTap: onTap,
          contentPadding: EdgeInsets.zero,
        ),
        if (showDivider) Divider(height: 1, color: theme.divider),
      ],
    );
  }
}
