import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ui_kit/ui_kit.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isOnline = true;

  @override
  Widget build(BuildContext context) {
    final theme = context.gloss;
    return Scaffold(
      backgroundColor: theme.bg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Gloss Deliver',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: theme.text, letterSpacing: -0.5),
        ),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: Icon(Icons.notifications_outlined, color: theme.text),
                onPressed: () {},
              ),
              Positioned(
                right: 8,
                top: 8,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: theme.red,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildOnlineToggle(theme),
          const SizedBox(height: 16),
          _buildBalanceCard(theme),
          const SizedBox(height: 16),
          _buildStatsRow(theme),
          const SizedBox(height: 20),
          _buildQuickActions(theme, context),
          const SizedBox(height: 20),
          _buildRecentDeliveries(theme),
        ],
      ),
    );
  }

  Widget _buildOnlineToggle(GlossTheme theme) {
    return GlossCard(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: _isOnline ? theme.greenBgLight : theme.orangeBgLight,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              _isOnline ? Icons.wifi : Icons.wifi_off,
              color: _isOnline ? theme.green : theme.orange,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _isOnline ? 'Holatingiz: Onlayn' : 'Holatingiz: Oflayn',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: theme.text),
                ),
                const SizedBox(height: 2),
                Text(
                  _isOnline ? 'Buyurtmalarni qabul qilishingiz mumkin' : 'Yangi buyurtmalar kelmaydi',
                  style: TextStyle(fontSize: 12, color: theme.hint),
                ),
              ],
            ),
          ),
          Switch(
            value: _isOnline,
            onChanged: (v) => setState(() => _isOnline = v),
            activeTrackColor: theme.green,
          ),
        ],
      ),
    );
  }

  Widget _buildBalanceCard(GlossTheme theme) {
    return Container(
      padding: const EdgeInsets.all(20),
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
                'Mavjud balans',
                style: TextStyle(color: Colors.white.withAlpha(200), fontSize: 14),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            "2 450 000 so'm",
            style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 40,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: theme.green,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 0,
                textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
              ),
              child: const Text('Pul chiqarish'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsRow(GlossTheme theme) {
    return Row(
      children: [
        _statItem(Icons.today, 'Bugun', '12', theme),
        _statItem(Icons.star, 'Reyting', '4.8', theme, suffix: '⭐'),
        _statItem(Icons.check_circle, 'Jami', '487', theme),
        _statItem(Icons.route, 'Masofa', '234 km', theme),
      ],
    );
  }

  Widget _statItem(IconData icon, String label, String value, GlossTheme theme, {String? suffix}) {
    return Expanded(
      child: GlossCard(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Column(
          children: [
            Icon(icon, color: theme.green, size: 22),
            const SizedBox(height: 6),
            Text(
              '$value${suffix ?? ''}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 2),
            Text(label, style: TextStyle(fontSize: 11, color: theme.hint)),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions(GlossTheme theme, BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _quickAction(Icons.receipt_long, 'Buyurtmalar', () => context.push('/orders'), theme),
        _quickAction(Icons.bar_chart, 'Statistika', () => context.push('/stats'), theme),
        _quickAction(Icons.help_outline, 'Yordam', () {}, theme),
        _quickAction(Icons.settings, 'Sozlamalar', () => context.push('/profile'), theme),
      ],
    );
  }

  Widget _quickAction(IconData icon, String label, VoidCallback onTap, GlossTheme theme) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: theme.greenBgLight,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: theme.green, size: 26),
            ),
            const SizedBox(height: 6),
            Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: theme.text)),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentDeliveries(GlossTheme theme) {
    final deliveries = [
      const _Delivery('iPhone 15 Pro', "Amir Temur 45 → Navoiy 12", "120 000", 'Yetkazilgan'),
      const _Delivery("Samsung Galaxy S24", "Bunyodkor 78 → Beruniy 5", "150 000", "Yo'lda"),
      const _Delivery('MacBook Pro', "Muqimiy 23 → Shota Rustaveli 8", "200 000", 'Qabul qilingan'),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Text(
            "So'nggi yetkazmalar",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: theme.text),
          ),
        ),
        ...deliveries.map((d) => Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: _deliveryTile(d, theme),
        )),
      ],
    );
  }

  Widget _deliveryTile(_Delivery d, GlossTheme theme) {
    final statusColor = switch (d.status) {
      'Yetkazilgan' => theme.green,
      "Yo'lda" => theme.orange,
      'Qabul qilingan' => GlossColors.catBlue,
      'Bekor qilingan' => theme.red,
      _ => theme.hint,
    };

    return GlossCard(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: theme.greenBgLight,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(Icons.inventory_2, color: theme.green, size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(d.name, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: theme.text)),
                const SizedBox(height: 2),
                Text(d.address, style: TextStyle(fontSize: 12, color: theme.hint), maxLines: 1, overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('${d.price} so\'m', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: theme.green)),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: statusColor.withAlpha(30),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(d.status, style: TextStyle(fontSize: 11, color: statusColor, fontWeight: FontWeight.w600)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Delivery {
  final String name;
  final String address;
  final String price;
  final String status;
  const _Delivery(this.name, this.address, this.price, this.status);
}
