import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ui_kit/ui_kit.dart';

final _workerActiveOrdersProvider = Provider<List<_WorkerOrder>>((ref) {
  return const [
    _WorkerOrder('ORD-0051', 'Haftalik tozalash', 'Chilonzor 12/4', 180000, 'in_progress', 'Bugun 15:00'),
    _WorkerOrder('ORD-0050', 'Ofis tozalash', 'Mirzo Ulug\'bek 22', 250000, 'en_route', 'Bugun 14:00'),
  ];
});

final _workerScheduledOrdersProvider = Provider<List<_WorkerOrder>>((ref) {
  return const [
    _WorkerOrder('ORD-0052', 'General tozalash', 'Olmazor 5/2', 350000, 'scheduled', 'Ertaga 09:00'),
    _WorkerOrder('ORD-0053', 'Kvartira tozalash', 'Yunusobod 7/12', 150000, 'scheduled', '22.07.2026 11:00'),
  ];
});

final _workerCompletedOrdersProvider = Provider<List<_WorkerOrder>>((ref) {
  return const [
    _WorkerOrder('ORD-0049', 'Kvartira tozalash', 'Sergeli 5/18', 120000, 'completed', '20.07.2026'),
    _WorkerOrder('ORD-0048', 'Uy tozalash', 'Chilonzor 8/3', 200000, 'completed', '19.07.2026'),
    _WorkerOrder('ORD-0047', 'Ofis tozalash', 'Olmazor 3/2', 300000, 'completed', '18.07.2026'),
    _WorkerOrder('ORD-0046', 'General tozalash', 'Yunusobod 5/1', 450000, 'completed', '17.07.2026'),
  ];
});

class WorkerOrdersTab extends ConsumerStatefulWidget {
  const WorkerOrdersTab({super.key});

  @override
  ConsumerState<WorkerOrdersTab> createState() => _WorkerOrdersTabState();
}

class _WorkerOrdersTabState extends ConsumerState<WorkerOrdersTab> with SingleTickerProviderStateMixin {
  late final _tabController = TabController(length: 3, vsync: this);

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.gloss;
    final active = ref.watch(_workerActiveOrdersProvider);
    final scheduled = ref.watch(_workerScheduledOrdersProvider);
    final completed = ref.watch(_workerCompletedOrdersProvider);

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
                  Tab(text: 'Rejalashtirilgan'),
                  Tab(text: 'Tugallangan'),
                ],
              ),
            ),
            const SizedBox(height: 4),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _OrderList(orders: active, theme: theme),
                  _OrderList(orders: scheduled, theme: theme),
                  _OrderList(orders: completed, theme: theme),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _WorkerOrder {
  final String id;
  final String service;
  final String address;
  final int amount;
  final String status;
  final String date;
  const _WorkerOrder(this.id, this.service, this.address, this.amount, this.status, this.date);
}

class _OrderList extends StatelessWidget {
  final List<_WorkerOrder> orders;
  final GlossTheme theme;
  const _OrderList({required this.orders, required this.theme});

  @override
  Widget build(BuildContext context) {
    if (orders.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.receipt_long_outlined, size: 56, color: theme.disabled),
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
        return _OrderTile(order: order, theme: theme);
      },
    );
  }
}

class _OrderTile extends StatelessWidget {
  final _WorkerOrder order;
  final GlossTheme theme;
  const _OrderTile({required this.order, required this.theme});

  String _statusLabel(String status) {
    switch (status) {
      case 'en_route': return 'Yo\'lda';
      case 'in_progress': return 'Jarayonda';
      case 'scheduled': return 'Rejalashtirilgan';
      case 'completed': return 'Tugallangan';
      default: return status;
    }
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'en_route': return GlossColors.catBlue;
      case 'in_progress': return GlossColors.catOrange;
      case 'scheduled': return GlossColors.catPurple;
      case 'completed': return theme.green;
      default: return theme.hint;
    }
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = _statusColor(order.status);
    final statusLabel = _statusLabel(order.status);

    return GestureDetector(
      onTap: () => context.push('/orders/${order.id}'),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: theme.border),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: statusColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(Icons.cleaning_services_rounded, color: statusColor, size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text('#${order.id}', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: theme.text)),
                      const Spacer(),
                      Text(order.date, style: TextStyle(fontSize: 12, color: theme.hint)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(order.service, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: theme.text)),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Icon(Icons.location_on_outlined, size: 14, color: theme.hint),
                      const SizedBox(width: 2),
                      Expanded(
                        child: Text(order.address, style: TextStyle(fontSize: 12, color: theme.hint), overflow: TextOverflow.ellipsis),
                      ),
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
