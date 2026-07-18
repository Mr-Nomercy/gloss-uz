import 'package:flutter/material.dart';
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
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildStatCardsRow(theme),
          const SizedBox(height: 20),
          _buildPeriodRow(theme),
          const SizedBox(height: 20),
          _buildBarChart(theme),
          const SizedBox(height: 20),
          _buildWeeklySummary(theme),
        ],
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
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: GlossStatCard(
            label: 'Bu hafta',
            value: '32 ta',
            icon: Icons.calendar_today,
            color: theme.green,
            padding: const EdgeInsets.all(14),
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
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: theme.text),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 160,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: List.generate(7, (i) {
                final ratio = values[i] / maxVal;
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(values[i].toString(), style: TextStyle(fontSize: 11, color: theme.hint)),
                        const SizedBox(height: 6),
                        Container(
                          height: 120 * ratio,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [theme.green, theme.darkGreen],
                            ),
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(days[i], style: TextStyle(fontSize: 12, color: theme.hint)),
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

  Widget _buildWeeklySummary(GlossTheme theme) {
    return Row(
      children: [
        Expanded(child: _summaryCard('Eng ko\'p', 'Chorshanba', '22 ta', theme.green, theme)),
        const SizedBox(width: 10),
        Expanded(child: _summaryCard('Eng kam', 'Yakshanba', '5 ta', theme.red, theme)),
      ],
    );
  }

  Widget _summaryCard(String label, String sub, String value, Color color, GlossTheme theme) {
    return GlossCard(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(label, style: TextStyle(fontSize: 11, color: color, fontWeight: FontWeight.w600)),
          ),
          const SizedBox(height: 10),
          Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: theme.text)),
          const SizedBox(height: 2),
          Text(sub, style: TextStyle(fontSize: 12, color: theme.hint)),
        ],
      ),
    );
  }
}
