import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ui_kit/ui_kit.dart';

class WalletScreen extends StatelessWidget {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.gloss;
    return Scaffold(
      backgroundColor: theme.bg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Hamyon',
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
            _buildBalanceHeader(theme),
            const SizedBox(height: 16),
            _buildWithdrawCard(theme, context),
            const SizedBox(height: 20),
            _buildTransactionHistory(theme),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildBalanceHeader(GlossTheme theme) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [theme.green, theme.darkGreen],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.account_balance_wallet_outlined, color: Colors.white.withAlpha(200), size: 20),
              const SizedBox(width: 8),
              Text(
                'Joriy balans',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white.withAlpha(200),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            "2 450 000 so'm",
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWithdrawCard(GlossTheme theme, BuildContext context) {
    return GlossCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Pul chiqarish',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 4),
          Text(
            "Minimal summa: 100 000 so'm",
            style: TextStyle(fontSize: 13, color: theme.hint),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 48,
            child: ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text("Pul chiqarish so'rovi yuborildi"),
                    backgroundColor: theme.green,
                    behavior: SnackBarBehavior.floating,
                    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.green,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                elevation: 0,
                textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
              ),
              child: const Text('Pul chiqarish'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionHistory(GlossTheme theme) {
    final transactions = [
      {
        'date': '15 Iyul 2026',
        'desc': 'Buyurtma #ORD-005',
        'amount': "+100 000 so'm",
        'positive': true,
      },
      {
        'date': '14 Iyul 2026',
        'desc': 'Buyurtma #ORD-003',
        'amount': "+150 000 so'm",
        'positive': true,
      },
      {
        'date': '12 Iyul 2026',
        'desc': 'Pul chiqarish',
        'amount': "-500 000 so'm",
        'positive': false,
      },
      {
        'date': '10 Iyul 2026',
        'desc': 'Buyurtma #ORD-002',
        'amount': "+80 000 so'm",
        'positive': true,
      },
      {
        'date': '08 Iyul 2026',
        'desc': 'Buyurtma #ORD-001',
        'amount': "+120 000 so'm",
        'positive': true,
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Text(
            "Tranzaksiyalar tarixi",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: theme.text),
          ),
        ),
        ...transactions.map((t) => Container(
              margin: const EdgeInsets.only(bottom: 8),
              child: GlossCard(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: (t['positive'] as bool) ? theme.greenBgLight : theme.red.withAlpha(25),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        (t['positive'] as bool) ? Icons.arrow_downward_rounded : Icons.arrow_upward_rounded,
                        color: (t['positive'] as bool) ? theme.green : theme.red,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            t['desc'] as String,
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: theme.text),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            t['date'] as String,
                            style: TextStyle(fontSize: 12, color: theme.hint),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      t['amount'] as String,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: (t['positive'] as bool) ? theme.greenText : theme.red,
                      ),
                    ),
                  ],
                ),
              ),
            )),
      ],
    );
  }
}
