import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ui_kit/ui_kit.dart';

final _courierOnlineProvider = StateProvider<bool>((ref) => true);

final _courierRecentProvider = Provider<List<_CourierRecentOrder>>((ref) {
  return const [
    _CourierRecentOrder('ORD-001245', 'Chilonzor 12/4', 'Mirzo Ulug\'bek 45', 'yetkazilgan', 85000, '14:25'),
    _CourierRecentOrder('ORD-001244', 'Sergeli 5/18', 'Yunusobod 7/12', 'yetkazilgan', 120000, '12:10'),
    _CourierRecentOrder('ORD-001243', 'Olmazor 3/2', 'Shayxontohur 9/5', 'bekor_qilingan', 45000, '10:45'),
  ];
});

class CourierHomeTab extends ConsumerWidget {
  const CourierHomeTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = context.gloss;
    final isOnline = ref.watch(_courierOnlineProvider);
    final recent = ref.watch(_courierRecentProvider);

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
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: isOnline ? theme.green.withValues(alpha: 0.06) : Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isOnline ? theme.green.withValues(alpha: 0.2) : theme.border,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isOnline ? theme.green : theme.grayMedium,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        isOnline ? 'Onlayn — buyurtmalar qabul qilinmoqda' : 'Oflayn',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: theme.text),
                      ),
                    ),
                    Switch(
                      value: isOnline,
                      onChanged: (v) => ref.read(_courierOnlineProvider.notifier).state = v,
                      activeTrackColor: theme.green,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              GlossBalanceCard(
                title: 'Joriy balans',
                balance: '3 450 000 so\'m',
                actionLabel: 'Pul yechish',
                onAction: () {},
              ),
              const SizedBox(height: 20),
              GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                childAspectRatio: 1.25,
                children: [
                  GlossStatCard(
                    label: 'Bugungi',
                    value: '12',
                    icon: Icons.receipt_long_rounded,
                    color: theme.green,
                  ),
                  GlossStatCard(
                    label: 'Daromad',
                    value: '345 000',
                    suffix: ' so\'m',
                    icon: Icons.payments_rounded,
                    color: GlossColors.catOrange,
                  ),
                  GlossStatCard(
                    label: 'Reyting',
                    value: '4.8',
                    icon: Icons.star_rounded,
                    color: GlossColors.star,
                  ),
                  GlossStatCard(
                    label: 'Masofa',
                    value: '45',
                    suffix: ' km',
                    icon: Icons.route_rounded,
                    color: GlossColors.catBlue,
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Text(
                'So\'nggi buyurtmalar',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: theme.text),
              ),
              const SizedBox(height: 12),
              ...recent.map((r) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: _RecentOrderCard(order: r, theme: theme),
              )),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

class _CourierRecentOrder {
  final String orderNumber;
  final String pickup;
  final String delivery;
  final String status;
  final int amount;
  final String time;
  const _CourierRecentOrder(this.orderNumber, this.pickup, this.delivery, this.status, this.amount, this.time);
}

class _RecentOrderCard extends StatelessWidget {
  final _CourierRecentOrder order;
  final GlossTheme theme;
  const _RecentOrderCard({required this.order, required this.theme});

  @override
  Widget build(BuildContext context) {
    final isDelivered = order.status == 'yetkazilgan';
    final isCancelled = order.status == 'bekor_qilingan';
    final statusColor = isDelivered ? theme.green : (isCancelled ? theme.red : theme.orange);
    final statusText = isDelivered ? 'Yetkazilgan' : (isCancelled ? 'Bekor qilingan' : 'Jarayonda');

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: theme.border),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: theme.green.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(Icons.inventory_2_outlined, color: theme.green, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text('#${order.orderNumber}', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: theme.text)),
                    const Spacer(),
                    Text(order.time, style: TextStyle(fontSize: 12, color: theme.hint)),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.circle, size: 6, color: theme.green),
                    const SizedBox(width: 4),
                    Expanded(child: Text(order.pickup, style: TextStyle(fontSize: 12, color: theme.hint), overflow: TextOverflow.ellipsis)),
                  ],
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Icon(Icons.circle, size: 6, color: theme.red),
                    const SizedBox(width: 4),
                    Expanded(child: Text(order.delivery, style: TextStyle(fontSize: 12, color: theme.hint), overflow: TextOverflow.ellipsis)),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: statusColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(statusText, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: statusColor)),
                    ),
                    const Spacer(),
                    Text(formatPrice(order.amount), style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: theme.text)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
