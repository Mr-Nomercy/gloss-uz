import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ui_kit/ui_kit.dart';

class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key});

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
          style: TextStyle(color: theme.text, fontWeight: FontWeight.w700, fontSize: 20),
        ),
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: theme.bg,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.arrow_back_ios_new_rounded, color: theme.text, size: 18),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildStatCards(theme),
            const SizedBox(height: 24),
            _buildWeeklyChart(theme),
            const SizedBox(height: 24),
            _buildPerformance(theme),
            const SizedBox(height: 16),
          ],
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
        _statCard(
          theme: theme,
          icon: Icons.receipt_long_rounded,
          label: 'Jami buyurtmalar',
          value: '247',
          iconColor: GlossColors.catBlue,
        ),
        _statCard(
          theme: theme,
          icon: Icons.account_balance_wallet_rounded,
          label: 'Jami daromad',
          value: "24 500 000 so'm",
          iconColor: theme.green,
        ),
        _statCard(
          theme: theme,
          icon: Icons.star_rounded,
          label: "O'rtacha reyting",
          value: '4.8',
          iconColor: theme.star,
          suffix: Text(' ⭐', style: TextStyle(fontSize: 14, color: theme.star)),
        ),
        _statCard(
          theme: theme,
          icon: Icons.calendar_today_rounded,
          label: 'Bu hafta',
          value: '12',
          iconColor: theme.orange,
        ),
      ],
    );
  }

  Widget _statCard({
    required GlossTheme theme,
    required IconData icon,
    required String label,
    required String value,
    required Color iconColor,
    Widget? suffix,
  }) {
    return GlossCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: iconColor.withAlpha(25),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: iconColor, size: 18),
          ),
          const Spacer(),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Flexible(
                child: Text(
                  value,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: theme.text,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (suffix != null) suffix,
            ],
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(fontSize: 11, color: theme.hint),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildWeeklyChart(GlossTheme theme) {
    final days = ['Du', 'Se', 'Ch', 'Pa', 'Ju', 'Sh', 'Ya'];
    final values = [0.6, 0.8, 0.45, 0.9, 0.7, 0.55, 0.75];

    return GlossCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Haftalik daromad',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: theme.text),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 160,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: List.generate(7, (index) {
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Flexible(
                          child: Container(
                            height: 120 * values[index],
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                                colors: [theme.green, theme.green.withAlpha(100)],
                              ),
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          days[index],
                          style: TextStyle(fontSize: 12, color: theme.hint),
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
          const SizedBox(height: 16),
          _perfRow(
            theme,
            icon: Icons.timer_outlined,
            label: "O'rtacha bajarish vaqti",
            value: '2.5 soat',
            iconColor: GlossColors.catOrange,
          ),
          const SizedBox(height: 14),
          Divider(color: theme.divider),
          const SizedBox(height: 14),
          _perfRow(
            theme,
            icon: Icons.check_circle_outline,
            label: 'Qabul qilish darajasi',
            value: '85%',
            iconColor: theme.green,
          ),
          const SizedBox(height: 14),
          Divider(color: theme.divider),
          const SizedBox(height: 14),
          _perfRow(
            theme,
            icon: Icons.refresh_rounded,
            label: 'Qayta buyurtmalar',
            value: '34%',
            iconColor: GlossColors.catBlue,
          ),
        ],
      ),
    );
  }

  Widget _perfRow(GlossTheme theme, {
    required IconData icon,
    required String label,
    required String value,
    required Color iconColor,
  }) {
    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: iconColor.withAlpha(25),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: iconColor, size: 18),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: TextStyle(fontSize: 14, color: theme.text),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: theme.text,
          ),
        ),
      ],
    );
  }
}
