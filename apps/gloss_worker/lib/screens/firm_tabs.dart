import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'home_screen.dart';
import 'orders_screen.dart';
import 'stats_screen.dart';

class WorkerHomeTab extends StatelessWidget {
  const WorkerHomeTab({super.key});
  @override
  Widget build(BuildContext context) => const HomeScreen();
}

class WorkerOrdersTab extends StatelessWidget {
  const WorkerOrdersTab({super.key});
  @override
  Widget build(BuildContext context) => const OrdersScreen();
}

class WorkerStatsTab extends StatelessWidget {
  const WorkerStatsTab({super.key});
  @override
  Widget build(BuildContext context) => const StatsScreen();
}

class WorkerMoreTab extends StatelessWidget {
  const WorkerMoreTab({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Yana', style: TextStyle(fontWeight: FontWeight.w700))),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _MenuCard(Icons.account_balance_wallet_rounded, 'Hamyon', () => context.push('/wallet')),
          _MenuCard(Icons.calendar_month_rounded, 'Ish grafigi', () => context.push('/availability')),
          _MenuCard(Icons.person_rounded, 'Profil', () => context.push('/profile')),
          _MenuCard(Icons.notifications_rounded, 'Bildirishnomalar', () => context.push('/notifications')),
          _MenuCard(Icons.headset_mic_rounded, 'Yordam', () => context.push('/support')),
          _MenuCard(Icons.settings_rounded, 'Sozlamalar', () => context.push('/settings')),
        ],
      ),
    );
  }
}

class _MenuCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  const _MenuCard(this.icon, this.title, this.onTap);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(icon),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        trailing: const Icon(Icons.chevron_right_rounded),
        onTap: onTap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
