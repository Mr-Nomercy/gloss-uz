import 'package:flutter/material.dart';
import 'package:ui_kit/ui_kit.dart';
import '../providers/payouts_provider.dart';
import '../utils/status_labels.dart';

class PayoutsScreen extends StatefulWidget {
  const PayoutsScreen({super.key});

  @override
  State<PayoutsScreen> createState() => _PayoutsScreenState();
}

class _PayoutsScreenState extends State<PayoutsScreen> {
  String? _activeStatusFilter;

  static final _mockPayouts = [
    Payout(
      id: 'p1', providerId: '1', providerName: 'Gloss Clean Pro',
      amount: 2500000, cardNumber: '8600 **** 1234',
      status: 'pending', createdAt: DateTime.now().subtract(const Duration(hours: 2)),
    ),
    Payout(
      id: 'p2', providerId: '2', providerName: 'Clean Service Tashkent',
      amount: 1800000, cardNumber: '8600 **** 5678',
      status: 'pending', createdAt: DateTime.now().subtract(const Duration(hours: 5)),
    ),
    Payout(
      id: 'p3', providerId: '1', providerName: 'Gloss Clean Pro',
      amount: 1200000, cardNumber: '8600 **** 1234',
      status: 'approved', adminNote: "To'lov amalga oshirildi",
      processedAt: DateTime.now().subtract(const Duration(days: 1)),
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
    ),
    Payout(
      id: 'p4', providerId: '3', providerName: 'Mega Clean Group',
      amount: 800000, cardNumber: '8600 **** 9012',
      status: 'rejected', adminNote: "Hujjatlar yetarli emas",
      processedAt: DateTime.now().subtract(const Duration(days: 3)),
      createdAt: DateTime.now().subtract(const Duration(days: 4)),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = context.gloss;

    return Scaffold(
      backgroundColor: theme.bg,
      appBar: const GlossAppBar(title: "To'lovlar"),
      body: Column(
        children: [
          SizedBox(
            height: 44,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              children: [
                _statusChip('Barchasi', 'all', theme),
                _statusChip('Kutilmoqda', 'pending', theme),
                _statusChip('Tasdiqlangan', 'approved', theme),
                _statusChip('Rad etilgan', 'rejected', theme),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
              itemCount: _filteredPayouts.length,
              itemBuilder: (_, i) {
                final payout = _filteredPayouts[i];
                return _buildPayoutCard(theme, payout);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _statusChip(String label, String status, GlossTheme theme) {
    final isSelected = _activeStatusFilter == status;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label, style: const TextStyle(fontSize: 12)),
        selected: isSelected,
        onSelected: (_) {
          setState(() {
            _activeStatusFilter = status;
          });
        },
        selectedColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.08),
        checkmarkColor: theme.green,
        backgroundColor: Colors.white,
        labelStyle: TextStyle(
          color: isSelected ? theme.green : theme.hint,
          fontWeight: FontWeight.w600,
        ),
        side: BorderSide(color: isSelected ? theme.green : theme.border),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  List<Payout> get _filteredPayouts {
    final filter = _activeStatusFilter;
    if (filter == null || filter == 'all') return _mockPayouts;
    return _mockPayouts.where((p) => p.status == filter).toList();
  }

  Widget _buildPayoutCard(GlossTheme theme, Payout payout) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: GlossCard(
        accentColor: GlossColors.catBlue,
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(Icons.payment_rounded, size: 20, color: theme.green),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        payout.providerName,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: GlossColors.text,
                        ),
                      ),
                      Text(
                        payout.cardNumber,
                        style: TextStyle(fontSize: 12, color: theme.hint),
                      ),
                    ],
                  ),
                ),
                GlossBadge(
                  label: payoutStatusLabel(payout.status),
                  variant: payout.status == 'approved'
                      ? BadgeVariant.success
                      : payout.status == 'rejected'
                          ? BadgeVariant.error
                          : BadgeVariant.warning,
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Text(
                  formatPrice(payout.amount.toInt()),
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: theme.green,
                  ),
                ),
                const Spacer(),
                Text(
                  payout.createdAt.toString().substring(0, 16),
                  style: TextStyle(fontSize: 12, color: theme.hint),
                ),
              ],
            ),
            if (payout.adminNote != null) ...[
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: payout.status == 'rejected'
                      ? theme.red.withValues(alpha: 0.05)
                      : Theme.of(context).colorScheme.primary.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  payout.adminNote!,
                  style: TextStyle(
                    fontSize: 12,
                    color: payout.status == 'rejected'
                        ? theme.red
                        : theme.green,
                  ),
                ),
              ),
            ],
            if (payout.status == 'pending') ...[
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: GlossButton(
                      label: 'Rad etish',
                      isOutlined: true,
                      onPressed: () {},
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: GlossButton(
                      label: 'Tasdiqlash',
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

}
