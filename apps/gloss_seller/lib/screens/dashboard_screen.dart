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
              Expanded(child: _buildStatCard(theme, 'Mahsulotlar', '12', Icons.inventory)),
              const SizedBox(width: 12),
              Expanded(child: _buildStatCard(theme, 'Buyurtmalar', '45', Icons.receipt)),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _buildStatCard(theme, 'Daromad', '2.5M', Icons.money)),
              const SizedBox(width: 12),
              Expanded(child: _buildStatCard(theme, 'Reyting', '4.8', Icons.star)),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 52,
            child: ElevatedButton(
              onPressed: () => context.go('/seller/add-product'),
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.green,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                elevation: 0,
                textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              ),
              child: const Text("Mahsulot qo'shish"),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 52,
            child: OutlinedButton(
              onPressed: () => context.go('/seller/kyc'),
              style: OutlinedButton.styleFrom(
                foregroundColor: theme.green,
                side: BorderSide(color: theme.green.withAlpha(75)),
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

  Widget _buildStatCard(GlossTheme theme, String title, String value, IconData icon) {
    return GlossCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Icon(icon, color: theme.green, size: 28),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: theme.text, height: 1.3),
          ),
          Text(
            title,
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.normal, color: theme.hint, height: 1.4),
          ),
        ],
      ),
    );
  }
}
