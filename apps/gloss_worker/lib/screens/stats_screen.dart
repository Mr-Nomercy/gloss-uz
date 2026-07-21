import 'package:flutter/material.dart';
import 'package:gloss_worker/widgets/gloss_tap_scale.dart';
import 'package:gloss_worker/widgets/mock_async_loader.dart';
import 'package:ui_kit/ui_kit.dart';

class StatsScreen extends StatefulWidget {
  const StatsScreen({super.key});

  @override
  State<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> with TickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _statsFade;
  late final Animation<double> _chartFade;
  late final Animation<double> _perfFade;
  final _loaderKey = GlobalKey<MockAsyncLoaderState>();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _statsFade = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.3, curve: Curves.easeOut),
    );
    _chartFade = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.5, 0.4, curve: Curves.easeOut),
    );
    _perfFade = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.25, 0.55, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.gloss;
    return Scaffold(
      backgroundColor: theme.bg,
      appBar: const GlossAppBar(title: 'Statistika'),
      body: RefreshIndicator(
        color: theme.green,
        backgroundColor: theme.card,
        onRefresh: () async => _loaderKey.currentState?.reload(),
        child: MockAsyncLoader(
          key: _loaderKey,
          delay: const Duration(milliseconds: 600),
          loadingBuilder: (_) => ListView(
            children: const [
              SizedBox(height: 200),
              GlossLoadingView(message: 'Yuklanmoqda...'),
            ],
          ),
          contentBuilder: (_) => SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                FadeTransition(
                    opacity: _statsFade, child: _buildStatCards(theme)),
                const SizedBox(height: 24),
                FadeTransition(
                    opacity: _chartFade,
                    child: _buildWeeklyChart(theme)),
                const SizedBox(height: 24),
                FadeTransition(
                    opacity: _perfFade,
                    child: _buildPerformance(theme)),
                const SizedBox(height: 16),
              ],
            ),
          ),
          errorBuilder: (_, onRetry) => ListView(
            children: [
              const SizedBox(height: 200),
              GlossErrorView.connection(onRetry: onRetry),
            ],
          ),
          onLoadStart: _controller.reset,
          onLoaded: _controller.forward,
        ),
      ),
    );
  }

  Widget _buildStatCards(GlossTheme theme) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.4,
      children: [
        _CountUpStatCard(
          icon: Icons.receipt_long_rounded,
          label: 'Jami buyurtmalar',
          endValue: 247,
          color: GlossColors.catBlue,
          formatValue: (v) => v.round().toString(),
        ),
        _CountUpStatCard(
          icon: Icons.account_balance_wallet_rounded,
          label: 'Jami daromad',
          endValue: 24500000,
          formatValue: (v) => formatPrice(v),
        ),
        _CountUpStatCard(
          icon: Icons.star_rounded,
          label: "O'rtacha reyting",
          endValue: 4.8,
          color: GlossColors.star,
          isFloat: true,
          formatValue: (v) => v.toStringAsFixed(1),
        ),
        _CountUpStatCard(
          icon: Icons.calendar_today_rounded,
          label: 'Bu hafta',
          endValue: 12,
          color: GlossColors.orange,
          formatValue: (v) => v.round().toString(),
        ),
      ],
    );
  }

  Widget _buildWeeklyChart(GlossTheme theme) {
    const labels = ['Du', 'Se', 'Ch', 'Pa', 'Ju', 'Sh', 'Ya'];
    const values = [0.6, 0.8, 0.45, 0.9, 0.7, 0.55, 0.75];
    const amounts = [120000, 160000, 90000, 180000, 140000, 110000, 150000];
    return GlossCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Haftalik daromad',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: theme.text),
          ),
          const SizedBox(height: 8),
          Text(
            'Jami: ${formatPrice(amounts.fold<int>(0, (s, v) => s + v))}',
            style: TextStyle(fontSize: 13, color: theme.hint),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 160,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: List.generate(7, (index) {
                final fraction = values[index];
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 3),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          '${(amounts[index] / 1000).round()}k',
                          style: TextStyle(fontSize: 9, color: theme.hint, fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(height: 4),
                        Flexible(
                          child: TweenAnimationBuilder<double>(
                            tween: Tween(begin: 0, end: fraction),
                            duration: const Duration(milliseconds: 900),
                            curve: Curves.easeOutCubic,
                            builder: (context, val, child) {
                              return FractionallySizedBox(
                                heightFactor: val,
                                child: Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.bottomCenter,
                                      end: Alignment.topCenter,
                                      colors: [theme.green, theme.green.withValues(alpha: 0.2)],
                                    ),
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(6),
                                      topRight: Radius.circular(6),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          labels[index],
                          style: TextStyle(fontSize: 11, color: theme.hint),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPerformance(GlossTheme theme) {
    return GlossCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Ko'rsatkichlar",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: theme.text),
          ),
          const SizedBox(height: 20),
          _AnimatedPerfRow(
            theme: theme,
            icon: Icons.timer_outlined,
            label: "O'rtacha bajarish vaqti",
            progress: 0.75,
            displayValue: '2.5 soat',
            iconColor: GlossColors.catOrange,
          ),
          const SizedBox(height: 18),
          _AnimatedPerfRow(
            theme: theme,
            icon: Icons.check_circle_outline,
            label: 'Qabul qilish darajasi',
            progress: 0.85,
            displayValue: '85%',
            iconColor: theme.green,
          ),
          const SizedBox(height: 18),
          _AnimatedPerfRow(
            theme: theme,
            icon: Icons.refresh_rounded,
            label: 'Qayta buyurtmalar',
            progress: 0.34,
            displayValue: '34%',
            iconColor: GlossColors.catBlue,
          ),
        ],
      ),
    );
  }
}

class _CountUpStatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final double endValue;
  final bool isFloat;
  final Color? color;
  final String Function(double value) formatValue;

  const _CountUpStatCard({
    required this.icon,
    required this.label,
    required this.endValue,
    required this.formatValue,
    this.color,
    this.isFloat = false,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: endValue),
      duration: const Duration(milliseconds: 1500),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return GlossTapScale(
          scale: 0.96,
          duration: const Duration(milliseconds: 120),
          curve: Curves.easeInOut,
          child: GlossStatCard(
            icon: icon,
            label: label,
            value: formatValue(value),
            color: color,
          ),
        );
      },
    );
  }
}


class _AnimatedPerfRow extends StatelessWidget {
  final GlossTheme theme;
  final IconData icon;
  final String label;
  final double progress;
  final String displayValue;
  final Color iconColor;

  const _AnimatedPerfRow({
    required this.theme,
    required this.icon,
    required this.label,
    required this.progress,
    required this.displayValue,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: iconColor, size: 18),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: TextStyle(fontSize: 13, color: theme.text),
              ),
            ),
            Text(
              displayValue,
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: theme.text),
            ),
          ],
        ),
        const SizedBox(height: 10),
        TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: progress),
          duration: const Duration(milliseconds: 1000),
          curve: Curves.easeOutCubic,
          builder: (context, value, child) {
            return ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: value,
                backgroundColor: theme.grayLight,
                valueColor: AlwaysStoppedAnimation(iconColor),
                minHeight: 6,
              ),
            );
          },
        ),
      ],
    );
  }
}

