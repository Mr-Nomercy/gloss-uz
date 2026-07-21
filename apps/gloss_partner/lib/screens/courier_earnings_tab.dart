import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ui_kit/ui_kit.dart';

final _courierBalanceVisibleProvider = StateProvider<bool>((ref) => true);

final _courierEarningsProvider = Provider<_EarningsData>((ref) {
  return const _EarningsData(
    totalBalance: 3450000,
    thisWeek: 875000,
    transactions: [
      _TxData('20.07.2026', '+85 000 so\'m', 'Buyurtma #ORD-001245', true),
      _TxData('20.07.2026', '+120 000 so\'m', 'Buyurtma #ORD-001244', true),
      _TxData('19.07.2026', '-200 000 so\'m', 'Pul yechish — UzCard *1234', false),
      _TxData('19.07.2026', '+45 000 so\'m', 'Buyurtma #ORD-001243', true),
      _TxData('18.07.2026', '+78 000 so\'m', 'Buyurtma #ORD-001242', true),
      _TxData('18.07.2026', '+93 000 so\'m', 'Buyurtma #ORD-001241', true),
      _TxData('17.07.2026', '-150 000 so\'m', 'Pul yechish — UzCard *1234', false),
      _TxData('17.07.2026', '+67 000 so\'m', 'Buyurtma #ORD-001240', true),
    ],
  );
});

class CourierEarningsTab extends ConsumerWidget {
  const CourierEarningsTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = context.gloss;
    final balanceVisible = ref.watch(_courierBalanceVisibleProvider);
    final data = ref.watch(_courierEarningsProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [Color(0xFF16A34A), Color(0xFF166534)],
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.account_balance_wallet_outlined, color: Colors.white, size: 18),
                        const SizedBox(width: 8),
                        Text('Jami balans', style: TextStyle(fontSize: 14, color: Colors.white.withValues(alpha: 0.78))),
                        const Spacer(),
                        GestureDetector(
                          onTap: () => ref.read(_courierBalanceVisibleProvider.notifier).state = !balanceVisible,
                          child: Icon(
                            balanceVisible ? Icons.visibility_off_rounded : Icons.visibility_rounded,
                            color: Colors.white.withValues(alpha: 0.7),
                            size: 20,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      balanceVisible ? '3 450 000 so\'m' : '••••••••',
                      style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: theme.green,
                          minimumSize: const Size(double.infinity, 44),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                        ),
                        child: const Text('Pul yechish'),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: theme.green.withValues(alpha: 0.04),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: theme.green.withValues(alpha: 0.12)),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(color: theme.green, borderRadius: BorderRadius.circular(12)),
                      child: const Icon(Icons.calendar_today_rounded, color: Colors.white, size: 20),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Shu hafta daromadi', style: TextStyle(fontSize: 13, color: theme.hint)),
                        const SizedBox(height: 2),
                        Text('875 000 so\'m', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: theme.text)),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Text('Tranzaksiyalar tarixi', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: theme.text)),
              const SizedBox(height: 12),
              ...data.transactions.map((tx) => _TxTile(tx: tx, theme: theme)),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

class _EarningsData {
  final int totalBalance;
  final int thisWeek;
  final List<_TxData> transactions;
  const _EarningsData({required this.totalBalance, required this.thisWeek, required this.transactions});
}

class _TxData {
  final String date;
  final String amount;
  final String description;
  final bool isIncome;
  const _TxData(this.date, this.amount, this.description, this.isIncome);
}

class _TxTile extends StatelessWidget {
  final _TxData tx;
  final GlossTheme theme;
  const _TxTile({required this.tx, required this.theme});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      margin: const EdgeInsets.only(bottom: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.border),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: tx.isIncome ? theme.green.withValues(alpha: 0.08) : theme.red.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              tx.isIncome ? Icons.arrow_downward_rounded : Icons.arrow_upward_rounded,
              color: tx.isIncome ? theme.green : theme.red,
              size: 18,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(tx.description, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: theme.text)),
                const SizedBox(height: 2),
                Text(tx.date, style: TextStyle(fontSize: 11, color: theme.hint)),
              ],
            ),
          ),
          Text(tx.amount, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: tx.isIncome ? theme.green : theme.red)),
        ],
      ),
    );
  }
}
