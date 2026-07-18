import 'package:flutter/material.dart';
import 'package:ui_kit/ui_kit.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> with SingleTickerProviderStateMixin {
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

  @override
  Widget build(BuildContext context) {
    final theme = context.gloss;
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
            Tab(text: 'Faol'),
            Tab(text: 'Tugallangan'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildOrderList(_activeOrders, theme),
          _buildOrderList(_completedOrders, theme),
        ],
      ),
    );
  }

  Widget _buildOrderList(List<_Order> orders, GlossTheme theme) {
    if (orders.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.receipt_long, size: 64, color: theme.grayLight),
            const SizedBox(height: 12),
            Text('Buyurtmalar mavjud emas', style: TextStyle(color: theme.hint, fontSize: 16)),
          ],
        ),
      );
    }
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: orders.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (ctx, i) => _orderTile(orders[i], theme),
    );
  }

  Widget _orderTile(_Order o, GlossTheme theme) {
    final statusColor = switch (o.status) {
      'Qabul qilingan' => GlossColors.catBlue,
      "Yo'lda" => theme.orange,
      'Yetkazilgan' => theme.green,
      'Bekor qilingan' => theme.red,
      _ => theme.hint,
    };

    return GlossCard(
      padding: const EdgeInsets.all(14),
      onTap: () => _showOrderDetails(o, theme),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: theme.greenBgLight,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(Icons.shopping_bag, color: theme.green, size: 26),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(o.product, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15, color: theme.text)),
                    const SizedBox(height: 4),
                    Text(o.price, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: theme.green)),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: GlossBadge.status(o.status),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: theme.bg,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(Icons.location_on, size: 16, color: theme.red),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(o.from, style: TextStyle(fontSize: 13, color: theme.text)),
                ),
                Icon(Icons.arrow_forward, size: 14, color: theme.hint),
                const SizedBox(width: 4),
                Icon(Icons.location_on, size: 16, color: theme.green),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(o.to, style: TextStyle(fontSize: 13, color: theme.text)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showOrderDetails(_Order o, GlossTheme theme) {
    final statusColor = switch (o.status) {
      'Qabul qilingan' => GlossColors.catBlue,
      "Yo'lda" => theme.orange,
      'Yetkazilgan' => theme.green,
      'Bekor qilingan' => theme.red,
      _ => theme.hint,
    };

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40, height: 4,
                decoration: BoxDecoration(color: theme.border, borderRadius: BorderRadius.circular(2)),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Container(
                  width: 56, height: 56,
                  decoration: BoxDecoration(color: theme.greenBgLight, borderRadius: BorderRadius.circular(14)),
                  child: Icon(Icons.inventory_2, color: theme.green, size: 30),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(o.product, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: theme.text)),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(color: statusColor.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(6)),
                        child: GlossBadge.status(o.status),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _detailRow(Icons.location_on, 'Manzil', '${o.from} → ${o.to}', theme),
            const SizedBox(height: 12),
            _detailRow(Icons.payment, 'Narx', o.price, theme),
            const SizedBox(height: 12),
            _detailRow(Icons.phone, 'Mijoz', '+998 93 123 45 67', theme),
            const SizedBox(height: 12),
            _detailRow(Icons.access_time, 'Vaqt', 'Bugun, 14:30', theme),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.green,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  elevation: 0,
                  textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
                child: const Text('Yopish'),
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Widget _detailRow(IconData icon, String label, String value, GlossTheme theme) {
    return Row(
      children: [
        Icon(icon, size: 18, color: theme.hint),
        const SizedBox(width: 8),
        Text('$label: ', style: TextStyle(fontSize: 14, color: theme.hint)),
        Expanded(
          child: Text(value, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: theme.text)),
        ),
      ],
    );
  }

  final _activeOrders = [
    const _Order('iPhone 15 Pro 256GB', 'Amir Temur', 'Navoiy', "120 000 so'm", 'Qabul qilingan'),
    const _Order("Samsung Galaxy S24", 'Bunyodkor', 'Beruniy', "150 000 so'm", "Yo'lda"),
    const _Order('MacBook Pro 14"', 'Muqimiy', 'Shota Rustaveli', "200 000 so'm", 'Qabul qilingan'),
    const _Order('Sony PlayStation 5', 'Chilonzor', 'Sergeli', "180 000 so'm", "Yo'lda"),
  ];

  final _completedOrders = [
    const _Order("Dyson V15 Vacuum", "Mirzo Ulug'bek", 'Yakkasaroy', "135 000 so'm", 'Yetkazilgan'),
    const _Order('iPad Air M2', 'Olmazor', 'Chilonzor', "110 000 so'm", 'Yetkazilgan'),
    const _Order('Asus ROG Laptop', 'Shayxontohur', 'Uchtepa', "160 000 so'm", 'Bekor qilingan'),
    const _Order('AirPods Pro', 'Yunusobod', "Mirzo Ulug'bek", "90 000 so'm", 'Yetkazilgan'),
  ];
}

class _Order {
  final String product;
  final String from;
  final String to;
  final String price;
  final String status;
  const _Order(this.product, this.from, this.to, this.price, this.status);
}
