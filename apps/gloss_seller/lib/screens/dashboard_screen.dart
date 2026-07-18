import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ui_kit/ui_kit.dart';

class SellerDashboardScreen extends StatelessWidget {
  const SellerDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.gloss;
    return Scaffold(
      backgroundColor: theme.bg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Panel',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: theme.text),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          GlossCard(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: theme.greenBgLight,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.store, color: theme.green, size: 32),
                ),
                const SizedBox(height: 12),
                Text(
                  "Mening do'konim",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: theme.text, height: 1.4),
                ),
                const SizedBox(height: 4),
                Text(
                  '@mening_dokonim',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.normal, color: theme.hint, height: 1.4),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: GlossStatCard(
                  label: 'Mahsulotlar',
                  value: '12',
                  icon: Icons.inventory,
                  padding: const EdgeInsets.symmetric(vertical: 20),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: GlossStatCard(
                  label: 'Buyurtmalar',
                  value: '45',
                  icon: Icons.receipt,
                  padding: const EdgeInsets.symmetric(vertical: 20),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: GlossStatCard(
                  label: 'Daromad',
                  value: '2.5M',
                  icon: Icons.money,
                  padding: const EdgeInsets.symmetric(vertical: 20),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: GlossStatCard(
                  label: 'Reyting',
                  value: '4.8',
                  icon: Icons.star,
                  color: GlossColors.star,
                  padding: const EdgeInsets.symmetric(vertical: 20),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          GlossButton(
            label: "Mahsulot qo'shish",
            onPressed: () => context.go('/seller/add-product'),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 52,
            child: OutlinedButton(
              onPressed: () => context.go('/seller/kyc'),
              style: OutlinedButton.styleFrom(
                foregroundColor: theme.green,
                side: BorderSide(color: theme.green.withValues(alpha: 0.30)),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              child: const Text('KYC tekshiruvi'),
            ),
          ),
        ],
      ),
    );
  }
}