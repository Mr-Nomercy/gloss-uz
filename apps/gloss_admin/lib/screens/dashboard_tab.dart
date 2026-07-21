import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ui_kit/ui_kit.dart';

class DashboardTab extends StatelessWidget {
  const DashboardTab({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.gloss;

    return RefreshIndicator(
      onRefresh: () async {},
      color: theme.green,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(12, 16, 12, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildRevenueCard(context, theme),
            const SizedBox(height: 20),
            Text('Boshqaruv', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: theme.text)),
            const SizedBox(height: 12),
            _buildManagementGrid(context),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("So'nggi buyurtmalar", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: theme.text)),
                TextButton(onPressed: () => context.push('/orders'), child: const Text('Barchasi', style: TextStyle(fontWeight: FontWeight.w600))),
              ],
            ),
            const SizedBox(height: 8),
            ..._recentOrders.map((o) => _buildOrderItem(theme, o)),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildRevenueCard(BuildContext context, GlossTheme theme) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [GlossColors.green, GlossColors.darkGreen],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: GlossColors.green.withValues(alpha: 0.3), blurRadius: 16, offset: const Offset(0, 6))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40, height: 40,
                decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(10)),
                child: const Icon(Icons.trending_up_rounded, color: Colors.white, size: 22),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(8)),
                child: const Text('Bu oy', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600)),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text('Jami daromad', style: TextStyle(fontSize: 13, color: Colors.white70)),
          const SizedBox(height: 4),
          const Text("45 600 000 so'm", style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: Colors.white, letterSpacing: -0.5)),
          const SizedBox(height: 4),
          Text("O'tgan oyga nisbatan +12.5%", style: TextStyle(fontSize: 12, color: Colors.white.withValues(alpha: 0.85))),
          const SizedBox(height: 20),
          Container(height: 1, color: Colors.white.withValues(alpha: 0.2)),
          const SizedBox(height: 16),
          Row(
            children: [
              _statChip(Icons.receipt_long_rounded, '42', 'Buyurtmalar'),
              _dividerChip(),
              _statChip(Icons.business_rounded, '18', 'Provayderlar'),
              _dividerChip(),
              _statChip(Icons.people_rounded, '1 250', 'Foydalanuvchilar'),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _statChip(Icons.delivery_dining_rounded, '8', 'Kuryerlar'),
              _dividerChip(),
              _statChip(Icons.percent_rounded, '6.8M', 'Komissiya'),
              _dividerChip(),
              _statChip(Icons.store_rounded, '156', 'Mahsulotlar'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _statChip(IconData icon, String value, String label) {
    return Expanded(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 13, color: Colors.white70),
              const SizedBox(width: 4),
              Text(value, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.white)),
            ],
          ),
          const SizedBox(height: 2),
          Text(label, style: TextStyle(fontSize: 10, color: Colors.white.withValues(alpha: 0.7)), textAlign: TextAlign.center),
        ],
      ),
    );
  }

  Widget _dividerChip() {
    return Container(width: 1, height: 32, color: Colors.white.withValues(alpha: 0.2));
  }

  Widget _buildManagementGrid(BuildContext context) {
    final items = [
      _MgmtItem(Icons.people_rounded, 'Foydalanuvchilar', const Color(0xFF6366F1), '/users'),
      _MgmtItem(Icons.store_rounded, 'Market', const Color(0xFFF43F5E), '/market'),
      _MgmtItem(Icons.percent_rounded, 'Komissiyalar', const Color(0xFFF59E0B), '/commissions'),
      _MgmtItem(Icons.payment_rounded, "To'lovlar", const Color(0xFF10B981), '/payouts'),
    ];

    final width = MediaQuery.of(context).size.width;
    final isTablet = width >= 600;
    final crossAxisCount = isTablet ? 4 : 2;
    final aspectRatio = isTablet ? 3.0 : 2.4;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: aspectRatio,
      ),
      itemCount: items.length,
      itemBuilder: (ctx, i) {
        final item = items[i];
        return GlossCard(
          accentColor: item.color,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          onTap: () => context.push(item.route),
          child: Row(
            children: [
              Container(
                width: 36, height: 36,
                decoration: BoxDecoration(
                  color: item.color,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [BoxShadow(color: item.color.withValues(alpha: 0.35), blurRadius: 6, offset: const Offset(0, 2))],
                ),
                child: Icon(item.icon, color: Colors.white, size: 18),
              ),
              const SizedBox(width: 10),
              Text(item.label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: GlossColors.text)),
            ],
          ),
        );
      },
    );
  }

  Widget _buildOrderItem(GlossTheme theme, _RecentOrder order) {
    final isService = order.type == 'service';
    final color = isService ? theme.green : theme.orange;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: GlossCard(
        accentColor: color,
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Container(
              width: 38, height: 38,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [BoxShadow(color: color.withValues(alpha: 0.3), blurRadius: 6, offset: const Offset(0, 2))],
              ),
              child: Icon(isService ? Icons.cleaning_services_rounded : Icons.shopping_bag_rounded, size: 18, color: Colors.white),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(order.orderNumber, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: theme.text)),
                const SizedBox(height: 2),
                Text(order.clientName, style: TextStyle(fontSize: 12, color: theme.hint)),
              ]),
            ),
            Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
              Text(order.amount, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: color)),
              const SizedBox(height: 4),
              GlossBadge(label: _label(order.status), variant: order.status == 'completed' ? BadgeVariant.success : order.status == 'in_progress' ? BadgeVariant.warning : BadgeVariant.neutral, fontSize: 10),
            ]),
          ],
        ),
      ),
    );
  }

  String _label(String s) {
    switch (s) {
      case 'completed': return 'Yakunlangan';
      case 'in_progress': return 'Jarayonda';
      case 'pending': return 'Kutilmoqda';
      default: return s;
    }
  }

  static final _recentOrders = [
    _RecentOrder('GL-0042', 'Aziz Karimov', "85 000 so'm", 'completed', 'service'),
    _RecentOrder('GL-0041', 'Dilnoza Rahimova', "120 000 so'm", 'in_progress', 'service'),
    _RecentOrder('GL-0040', 'Jamshid Aliyev', "45 000 so'm", 'pending', 'product'),
  ];
}

class _RecentOrder {
  final String orderNumber, clientName, amount, status, type;
  const _RecentOrder(this.orderNumber, this.clientName, this.amount, this.status, this.type);
}

class _MgmtItem {
  final IconData icon;
  final String label;
  final Color color;
  final String route;
  const _MgmtItem(this.icon, this.label, this.color, this.route);
}
