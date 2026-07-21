import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ui_kit/ui_kit.dart';

final _courierActiveProvider = Provider<List<_CourierOrderModel>>((ref) {
  return const [
    _CourierOrderModel('ORD-001246', 'Chilonzor 12/4', 'Mirzo Ulug\'bek 45', 95000, 'delivering', '14:30'),
    _CourierOrderModel('ORD-001247', 'Olmazor 3/2', 'Yunusobod 7/12', 67000, 'en_route_to_pickup', '14:45'),
    _CourierOrderModel('ORD-001248', 'Sergeli 5/18', 'Shayxontohur 9/5', 110000, 'accepted', '15:00'),
  ];
});

final _courierCompletedProvider = Provider<List<_CourierOrderModel>>((ref) {
  return const [
    _CourierOrderModel('ORD-001245', 'Chilonzor 12/4', 'Mirzo Ulug\'bek 45', 85000, 'delivered', '14:25'),
    _CourierOrderModel('ORD-001244', 'Sergeli 5/18', 'Yunusobod 7/12', 120000, 'delivered', '12:10'),
    _CourierOrderModel('ORD-001243', 'Olmazor 3/2', 'Shayxontohur 9/5', 45000, 'delivered', '10:45'),
    _CourierOrderModel('ORD-001242', 'Chilonzor 8/3', 'Mirzo Ulug\'bek 22', 78000, 'delivered', '09:20'),
    _CourierOrderModel('ORD-001241', 'Yunusobod 5/1', 'Sergeli 3/11', 93000, 'delivered', '08:00'),
  ];
});

class CourierOrdersTab extends ConsumerStatefulWidget {
  const CourierOrdersTab({super.key});

  @override
  ConsumerState<CourierOrdersTab> createState() => _CourierOrdersTabState();
}

class _CourierOrdersTabState extends ConsumerState<CourierOrdersTab> with SingleTickerProviderStateMixin {
  late final _tabController = TabController(length: 2, vsync: this);

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.gloss;
    final active = ref.watch(_courierActiveProvider);
    final completed = ref.watch(_courierCompletedProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: theme.bg,
                borderRadius: BorderRadius.circular(12),
              ),
              child: TabBar(
                controller: _tabController,
                indicator: BoxDecoration(
                  color: theme.green,
                  borderRadius: BorderRadius.circular(10),
                ),
                indicatorSize: TabBarIndicatorSize.tab,
                labelColor: Colors.white,
                unselectedLabelColor: theme.hint,
                labelStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                dividerHeight: 0,
                splashFactory: NoSplash.splashFactory,
                padding: const EdgeInsets.all(4),
                tabs: const [
                  Tab(text: 'Faol'),
                  Tab(text: 'Tugallangan'),
                ],
              ),
            ),
            const SizedBox(height: 4),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _CourierOrderList(orders: active, theme: theme),
                  _CourierOrderList(orders: completed, theme: theme),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CourierOrderModel {
  final String orderNumber;
  final String pickup;
  final String delivery;
  final int amount;
  final String status;
  final String time;
  const _CourierOrderModel(this.orderNumber, this.pickup, this.delivery, this.amount, this.status, this.time);
}

class _CourierOrderList extends StatelessWidget {
  final List<_CourierOrderModel> orders;
  final GlossTheme theme;
  const _CourierOrderList({required this.orders, required this.theme});

  @override
  Widget build(BuildContext context) {
    if (orders.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.inventory_2_outlined, size: 56, color: theme.disabled),
            const SizedBox(height: 12),
            Text('Buyurtmalar yo\'q', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: theme.hint)),
          ],
        ),
      );
    }
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: orders.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        final order = orders[index];
        return _CourierOrderTile(order: order, theme: theme);
      },
    );
  }
}

class _CourierOrderTile extends StatelessWidget {
  final _CourierOrderModel order;
  final GlossTheme theme;
  const _CourierOrderTile({required this.order, required this.theme});

  int _orderStep(String status) {
    switch (status) {
      case 'accepted': return 0;
      case 'en_route_to_pickup': return 1;
      case 'picked_up': return 2;
      case 'delivering': return 3;
      case 'delivered': return 4;
      default: return -1;
    }
  }

  String _statusLabel(String status) {
    switch (status) {
      case 'accepted': return 'Qabul qilingan';
      case 'en_route_to_pickup': return 'Pickupga ketmoqda';
      case 'picked_up': return 'Olib ketilgan';
      case 'delivering': return 'Yetkazilmoqda';
      case 'delivered': return 'Yetkazilgan';
      default: return status;
    }
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'accepted': return GlossColors.catBlue;
      case 'en_route_to_pickup': return GlossColors.catAmber;
      case 'picked_up': return GlossColors.catPurple;
      case 'delivering': return GlossColors.catOrange;
      case 'delivered': return theme.green;
      default: return theme.hint;
    }
  }

  @override
  Widget build(BuildContext context) {
    final step = _orderStep(order.status);
    final statusColor = _statusColor(order.status);
    final statusLabel = _statusLabel(order.status);

    return GestureDetector(
      onTap: () => context.push('/orders/${order.orderNumber}'),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: theme.border),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 28,
              child: _MiniTimeline(currentStep: step, color: statusColor),
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
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(Icons.circle, size: 6, color: theme.green),
                      const SizedBox(width: 4),
                      Expanded(child: Text(order.pickup, style: TextStyle(fontSize: 12, color: theme.hint), overflow: TextOverflow.ellipsis)),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Padding(
                    padding: const EdgeInsets.only(left: 2),
                    child: Icon(Icons.south_rounded, size: 14, color: theme.disabled),
                  ),
                  Row(
                    children: [
                      Icon(Icons.circle, size: 6, color: theme.red),
                      const SizedBox(width: 4),
                      Expanded(child: Text(order.delivery, style: TextStyle(fontSize: 12, color: theme.hint), overflow: TextOverflow.ellipsis)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: statusColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(statusLabel, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: statusColor)),
                      ),
                      const Spacer(),
                      Text(formatPrice(order.amount), style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: theme.text)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 4),
            Icon(Icons.chevron_right_rounded, color: theme.disabled, size: 20),
          ],
        ),
      ),
    );
  }
}

class _MiniTimeline extends StatelessWidget {
  final int currentStep;
  final Color color;
  const _MiniTimeline({required this.currentStep, required this.color});

  @override
  Widget build(BuildContext context) {
    final theme = context.gloss;
    const steps = ['accepted', 'en_route_to_pickup', 'picked_up', 'delivering', 'delivered'];
    return Column(
      children: List.generate(steps.length, (i) {
        final isPast = i <= currentStep;
        final isCurrent = i == currentStep;
        return SizedBox(
          height: i < steps.length - 1 ? 16 : 4,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  Container(
                    width: isCurrent ? 10 : 7,
                    height: isCurrent ? 10 : 7,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isPast ? color : theme.grayLight,
                      border: isCurrent ? Border.all(color: color.withValues(alpha: 0.3), width: 2) : null,
                    ),
                  ),
                  if (i < steps.length - 1)
                    Expanded(
                      child: Container(width: 2, color: isPast ? color : theme.grayLight),
                    ),
                ],
              ),
            ],
          ),
        );
      }),
    );
  }
}
