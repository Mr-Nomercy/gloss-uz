import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ui_kit/ui_kit.dart';

final _workerStatsProvider = Provider<_WorkerStats>((ref) {
  return const _WorkerStats(
    totalOrders: 148,
    rating: 4.7,
    totalEarnings: 12450000,
    weeklyData: [
      _WeeklyBar('Dush', 8),
      _WeeklyBar('Sesh', 6),
      _WeeklyBar('Chor', 9),
      _WeeklyBar('Pay', 5),
      _WeeklyBar('Jum', 7),
      _WeeklyBar('Shan', 4),
      _WeeklyBar('Yak', 3),
    ],
  );
});

class WorkerStatsTab extends ConsumerWidget {
  const WorkerStatsTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = context.gloss;
    final stats = ref.watch(_workerStatsProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              Text(
                'Statistika',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: theme.text),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: GlossStatCard(
                      label: 'Jami buyurtmalar',
                      value: '${stats.totalOrders}',
                      icon: Icons.receipt_long_rounded,
                      color: theme.green,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: GlossStatCard(
                      label: 'Reyting',
                      value: '${stats.rating}',
                      icon: Icons.star_rounded,
                      color: GlossColors.star,
                      suffix: ' / 5',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: GlossStatCard(
                      label: 'Jami daromad',
                      value: formatPrice(stats.totalEarnings),
                      icon: Icons.payments_rounded,
                      color: GlossColors.catOrange,
                      valueFontSize: 15,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: GlossStatCard(
                      label: 'Shu oy',
                      value: '32',
                      icon: Icons.trending_up_rounded,
                      color: GlossColors.catBlue,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Text(
                'Haftalik hisobot',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: theme.text),
              ),
              const SizedBox(height: 4),
              Text(
                'Buyurtmalar soni',
                style: TextStyle(fontSize: 12, color: theme.hint),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: theme.border),
                ),
                child: SizedBox(
                  height: 180,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: stats.weeklyData.map((bar) {
                      final maxVal = stats.weeklyData.fold<int>(0, (max, b) => b.count > max ? b.count : max);
                      final ratio = maxVal > 0 ? bar.count / maxVal : 0.0;
                      return Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                '${bar.count}',
                                style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: theme.hint),
                              ),
                              const SizedBox(height: 4),
                              AnimatedContainer(
                                duration: const Duration(milliseconds: 600),
                                curve: Curves.easeOutCubic,
                                height: 120 * ratio,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.bottomCenter,
                                    end: Alignment.topCenter,
                                    colors: [theme.green, theme.green.withValues(alpha: 0.4)],
                                  ),
                                  borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                bar.day,
                                style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: theme.hint),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

class _WorkerStats {
  final int totalOrders;
  final double rating;
  final int totalEarnings;
  final List<_WeeklyBar> weeklyData;
  const _WorkerStats({required this.totalOrders, required this.rating, required this.totalEarnings, required this.weeklyData});
}

class _WeeklyBar {
  final String day;
  final int count;
  const _WeeklyBar(this.day, this.count);
}
