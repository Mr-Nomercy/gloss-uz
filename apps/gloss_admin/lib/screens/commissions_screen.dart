import 'package:flutter/material.dart';
import 'package:ui_kit/ui_kit.dart';
import '../providers/commissions_provider.dart';

class CommissionsScreen extends StatefulWidget {
  const CommissionsScreen({super.key});

  @override
  State<CommissionsScreen> createState() =>
      _CommissionsScreenState();
}

class _CommissionsScreenState extends State<CommissionsScreen> {
  late final List<CommissionConfig> _commissions;
  late final Map<String, double> _selectedRates;

  @override
  void initState() {
    super.initState();
    _commissions = [
      const CommissionConfig(
        id: '1', serviceTypeId: 'st1', serviceTypeName: 'Uy tozalash',
        rate: 0.20, minOrderAmount: 30000,
      ),
      const CommissionConfig(
        id: '2', serviceTypeId: 'st2', serviceTypeName: 'Ofis tozalash',
        rate: 0.15, minOrderAmount: 50000,
      ),
      const CommissionConfig(
        id: '3', serviceTypeId: 'st3', serviceTypeName: 'Deraza yuvish',
        rate: 0.18, minOrderAmount: 20000,
      ),
      const CommissionConfig(
        id: '4', serviceTypeId: 'st4', serviceTypeName: 'Gilam tozalash',
        rate: 0.10, minOrderAmount: 25000,
      ),
      const CommissionConfig(
        id: '5', serviceTypeId: 'st5', serviceTypeName: 'Mebel tozalash',
        rate: 0.15, minOrderAmount: 35000,
      ),
      const CommissionConfig(
        id: '6', serviceTypeId: 'mp1', serviceTypeName: 'Mahsulot savdosi',
        rate: 0.12, minOrderAmount: 20000,
      ),
    ];
    _selectedRates = {
      for (final c in _commissions) c.id: c.rate,
    };
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.gloss;

    const rates = [8, 10, 12, 15, 18, 20, 25];

    return Scaffold(
      backgroundColor: theme.bg,
      appBar: const GlossAppBar(title: 'Komissiyalar'),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _commissions.length + 1,
        itemBuilder: (_, i) {
          if (i == _commissions.length) {
            return Padding(
              padding: const EdgeInsets.only(top: 24),
              child: GlossButton(label: 'Saqlash', onPressed: () {}),
            );
          }
          final config = _commissions[i];
          final currentRate = _selectedRates[config.id] ?? config.rate;
          return _buildCommissionCard(theme, config, currentRate, rates);
        },
      ),
    );
  }

  Widget _buildCommissionCard(
    GlossTheme theme,
    CommissionConfig config,
    double currentRate,
    List<int> rates,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: GlossCard(
        accentColor: theme.red,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              config.serviceTypeName,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: GlossColors.text,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Min. buyurtma: ${formatPrice(config.minOrderAmount.toInt())}',
              style: TextStyle(fontSize: 13, color: theme.hint),
            ),
            const SizedBox(height: 12),
            Text(
              "Komissiya: ${(currentRate * 100).toInt()}%",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: theme.green,
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 36,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: rates.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (_, j) {
                  final rate = rates[j] / 100.0;
                  final isSelected = (currentRate - rate).abs() < 0.001;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedRates[config.id] = rate;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 6),
                      decoration: BoxDecoration(
                        color: isSelected ? theme.green : theme.grayLight,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(
                          '${rates[j]}%',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: isSelected ? Colors.white : theme.text,
                          ),
                        ),
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
