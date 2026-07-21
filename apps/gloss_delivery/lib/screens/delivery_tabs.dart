import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'home_screen.dart';
import 'orders_screen.dart';
import 'stats_screen.dart';
import 'profile_screen.dart';

class DeliveryHomeTab extends ConsumerWidget {
  const DeliveryHomeTab({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) => const HomeScreen();
}

class DeliveryOrdersTab extends ConsumerWidget {
  const DeliveryOrdersTab({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) => const OrdersScreen();
}

class DeliveryStatsTab extends ConsumerWidget {
  const DeliveryStatsTab({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) => const StatsScreen();
}

class DeliveryProfileTab extends ConsumerWidget {
  const DeliveryProfileTab({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) => const ProfileScreen();
}
