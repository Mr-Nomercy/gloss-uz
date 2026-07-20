import 'package:flutter/material.dart';
import 'package:ui_kit/ui_kit.dart';

class StatsScreen extends StatefulWidget {
  const StatsScreen({super.key});

  @override
  State<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _fadeController;
  late final Animation<double> _fadeAnimation;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    );
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    _fadeController.reset();
    await Future.delayed(const Duration(milliseconds: 300));
    if (mounted) {
      setState(() => _isLoading = false);
      _fadeController.forward();
    }
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.gloss;
    return Scaffold(
      backgroundColor: theme.bg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Statistika',
          style: TextStyle(
            color: theme.text,
            fontWeight: FontWeight.w700,
            fontSize: 20,
          ),
        ),
      ),
      body: _isLoading
          ? const GlossLoadingView(message: 'Yuklanmoqda...')
          : FadeTransition(
              opacity: _fadeAnimation,
              child: RefreshIndicator(
                color: theme.green,
                onRefresh: _loadData,
                child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _buildStatCardsRow(theme),
              const SizedBox(height: 16),
              _buildPeriodRow(theme),
              const SizedBox(height: 24),
              _buildBarChart(theme),
              const SizedBox(height: 24),
              _buildWeeklySummary(theme),
              const SizedBox(height: 24),
              _buildMonthlyEarnings(theme),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCardsRow(GlossTheme theme) {
    return Row(
      children: [
        Expanded(
          child: GlossStatCard(
            label: 'Jami buyurtmalar',
            value: '487',
            icon: Icons.receipt_long,
            color: theme.green,
            padding: const EdgeInsets.all(14),
            onTap: () {},
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: GlossStatCard(
            label: 'Jami daromad',
            value: '24.5M',
            icon: Icons.payments,
            color: theme.green,
            padding: const EdgeInsets.all(14),
            onTap: () {},
          ),
        ),
      ],
    );
  }

  Widget _buildPeriodRow(GlossTheme theme) {
    return Row(
      children: [
        Expanded(
          child: GlossStatCard(
            label: "O'rtacha reyting",
            value: '4.8',
            icon: Icons.star,
            color: GlossColors.star,
            suffix: '⭐',
            padding: const EdgeInsets.all(14),
            onTap: () {},
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: GlossStatCard(
            label: 'Bu hafta',
            value: '32 ta',
            icon: Icons.calendar_today,
            color: GlossColors.green,
            padding: const EdgeInsets.all(14),
            onTap: () {},
          ),
        ),
      ],
    );
  }

  Widget _buildBarChart(GlossTheme theme) {
    final days = ['Du', 'Se', 'Ch', 'Pa', 'Ju', 'Sh', 'Ya'];
    final values = [12, 18, 8, 15, 22, 10, 5];
    final maxVal = values.reduce((a, b) => a > b ? a : b);

    return GlossCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Haftalik buyurtmalar',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: theme.text,
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 140,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: List.generate(7, (i) {
                final ratio = values[i] / maxVal;
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 3),
                    child: _BarChartItem(
                      value: values[i],
                      ratio: ratio,
                      gradientColors: [theme.green, theme.darkGreen],
                      theme: theme,
                      index: i,
                    ),
                  ),
                );
              }),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: days
                .map((d) => Expanded(
                      child: Text(
                        d,
                        style: TextStyle(
                          fontSize: 10,
                          color: theme.hint,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildWeeklySummary(GlossTheme theme) {
    return Row(
      children: [
        Expanded(
          child: _summaryCard(
              'Eng ko\'p', 'Chorshanba', '22 ta', theme.green, theme),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _summaryCard(
              'Eng kam', 'Yakshanba', '5 ta', theme.red, theme),
        ),
      ],
    );
  }

  Widget _summaryCard(String label, String sub, String value, Color color,
      GlossTheme theme) {
    return GlossCard(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color: color,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: theme.text,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            sub,
            style: TextStyle(fontSize: 12, color: theme.hint),
          ),
        ],
      ),
    );
  }

  Widget _buildMonthlyEarnings(GlossTheme theme) {
    final months = [
      ('Yan', 3.2),
      ('Fev', 4.1),
      ('Mar', 3.8),
      ('Apr', 5.2),
      ('May', 4.5),
      ('Iyn', 6.8),
      ('Iyl', 5.1),
    ];

    return GlossCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Oylik daromad (mln)',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: theme.text,
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 160,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: months.asMap().entries.map((entry) {
                final (label, value) = entry.value;
                const maxEarning = 7.0;

                return Expanded(
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 2),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          '${value}M',
                          style: TextStyle(
                            fontSize: 9,
                            color: theme.hint,
                          ),
                        ),
                        const SizedBox(height: 4),
                        AnimatedContainer(
                          duration:
                              const Duration(milliseconds: 600),
                          curve: Curves.easeOut,
                          height:
                              100 * (value / maxEarning).clamp(0.0, 1.0),
                          width: double.infinity,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [
                                theme.green,
                                theme.green.withValues(alpha: 0.5),
                              ],
                            ),
                            borderRadius:
                                const BorderRadius.vertical(
                              top: Radius.circular(6),
                            ),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          label,
                          style: TextStyle(
                            fontSize: 9,
                            color: theme.hint,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class _BarChartItem extends StatefulWidget {
  final int value;
  final double ratio;
  final List<Color> gradientColors;
  final GlossTheme theme;
  final int index;

  const _BarChartItem({
    required this.value,
    required this.ratio,
    required this.gradientColors,
    required this.theme,
    required this.index,
  });

  @override
  State<_BarChartItem> createState() => _BarChartItemState();
}

class _BarChartItemState extends State<_BarChartItem>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _heightAnim;
  late final Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _heightAnim = Tween<double>(begin: 0.0, end: widget.ratio).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );
    _fadeAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    Future.delayed(
        Duration(milliseconds: 100 * widget.index), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, __) => Opacity(
        opacity: _fadeAnim.value,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              widget.value.toString(),
              style: TextStyle(
                  fontSize: 10, color: widget.theme.hint),
            ),
            const SizedBox(height: 6),
            Flexible(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final maxHeight =
                      constraints.maxHeight - 24;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 600),
                    curve: Curves.easeOutBack,
                    height: (maxHeight * _heightAnim.value)
                        .clamp(0.0, maxHeight),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: widget.gradientColors,
                      ),
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(8),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

