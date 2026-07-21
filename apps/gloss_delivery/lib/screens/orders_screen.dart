import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ui_kit/ui_kit.dart';
import '../providers/order_provider.dart';

class OrdersScreen extends ConsumerStatefulWidget {
  const OrdersScreen({super.key});

  @override
  ConsumerState<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends ConsumerState<OrdersScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  String _statusLabel(String status) {
    return switch (status) {
      'pending' => 'Kutilmoqda',
      'accepted' => 'Qabul qilingan',
      'picked_up' => "Yo'lda",
      'delivered' => 'Yetkazilgan',
      'cancelled' => 'Bekor qilingan',
      _ => status,
    };
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.gloss;
    final orderState = ref.watch(orderProvider);

    ref.listen<OrderState>(orderProvider, (prev, next) {
      if (next.error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.error!), backgroundColor: theme.red),
        );
        ref.read(orderProvider.notifier).clearError();
      }
    });

    return Scaffold(
      backgroundColor: theme.bg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Buyurtmalar',
          style: TextStyle(color: theme.text, fontWeight: FontWeight.w700, fontSize: 20),
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: theme.green,
          labelColor: theme.green,
          unselectedLabelColor: theme.hint,
          labelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
          tabs: const [
            Tab(text: 'Mavjud'),
            Tab(text: 'Mening ishim'),
          ],
        ),
      ),
      body: orderState.isLoading
          ? const GlossLoadingView(message: 'Yuklanmoqda...')
          : RefreshIndicator(
              color: theme.green,
              onRefresh: () => ref.read(orderProvider.notifier).loadAssignments(),
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildPendingList(orderState.pendingAssignments, theme),
                  _buildActiveJob(orderState.activeAssignment, theme, orderState.isLoadingAction),
                ],
              ),
            ),
    );
  }

  Widget _buildPendingList(List<DeliveryAssignment> assignments, GlossTheme theme) {
    if (assignments.isEmpty) {
      return const SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: SizedBox(
          height: 400,
          child: GlossEmptyState(
            icon: Icons.receipt_long,
            title: 'Hozircha buyurtma yo\'q',
            subtitle: "Yangi buyurtmalar shu yerda ko'rinadi",
          ),
        ),
      );
    }

    return ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(16),
      itemCount: assignments.length,
      itemBuilder: (ctx, i) => Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: _assignmentCard(
          assignments[i],
          theme,
          actionLabel: 'Qabul qilish',
          onAction: () => ref.read(orderProvider.notifier).acceptAssignment(assignments[i].id),
        ),
      ),
    );
  }

  Widget _buildActiveJob(DeliveryAssignment? assignment, GlossTheme theme, bool isLoadingAction) {
    if (assignment == null) {
      return const SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: SizedBox(
          height: 400,
          child: GlossEmptyState(
            icon: Icons.local_shipping_outlined,
            title: 'Faol ish yo\'q',
            subtitle: "Mavjud buyurtmalardan birini qabul qiling",
          ),
        ),
      );
    }

    final nextStatus = switch (assignment.status) {
      'accepted' => 'picked_up',
      'picked_up' => 'delivered',
      _ => null,
    };
    final nextLabel = switch (nextStatus) {
      'picked_up' => "Oldim (yo'lga chiqdim)",
      'delivered' => 'Yetkazdim',
      _ => null,
    };

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: _assignmentCard(
        assignment,
        theme,
        actionLabel: nextLabel,
        isLoadingAction: isLoadingAction,
        onAction: nextStatus == null
            ? null
            : () => ref
                .read(orderProvider.notifier)
                .updateAssignmentStatus(assignment.id, nextStatus),
      ),
    );
  }

  Widget _assignmentCard(
    DeliveryAssignment a,
    GlossTheme theme, {
    String? actionLabel,
    VoidCallback? onAction,
    bool isLoadingAction = false,
  }) {
    final statusColor = switch (a.status) {
      'pending' => theme.hint,
      'accepted' => GlossColors.catBlue,
      'picked_up' => theme.orange,
      'delivered' => theme.green,
      _ => theme.hint,
    };

    return GlossCard(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(Icons.inventory_2, color: statusColor, size: 26),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Buyurtma #${a.marketOrder}",
                      style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15, color: theme.text),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "${a.totalPrice} so'm",
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: theme.green),
                    ),
                  ],
                ),
              ),
              GlossBadge.status(_statusLabel(a.status)),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(color: theme.bg, borderRadius: BorderRadius.circular(8)),
            child: Row(
              children: [
                Icon(Icons.location_on, size: 16, color: theme.green),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(a.address, style: TextStyle(fontSize: 13, color: theme.text)),
                ),
              ],
            ),
          ),
          if (actionLabel != null && onAction != null) ...[
            const SizedBox(height: 12),
            GlossButton(label: actionLabel, isLoading: isLoadingAction, onPressed: onAction),
          ],
        ],
      ),
    );
  }
}
