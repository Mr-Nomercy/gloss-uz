import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ui_kit/ui_kit.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<Map<String, dynamic>> _activeOrders = [
    {
      'id': 'ORD-001',
      'service': 'Uy tozalash',
      'icon': Icons.cleaning_services_rounded,
      'address': "Mirzo Ulug'bek tumani, Mustaqillik 45",
      'price': "120 000 so'm",
      'status': 'Qabul qilingan',
    },
    {
      'id': 'ORD-002',
      'service': 'Deraza yuvish',
      'icon': Icons.window,
      'address': 'Yakkasaroy tumani, Bobur 18',
      'price': "80 000 so'm",
      'status': "Yo'lda",
    },
    {
      'id': 'ORD-003',
      'service': 'Mebel tozalash',
      'icon': Icons.chair_alt,
      'address': 'Chilonzor tumani, Farxod 22',
      'price': "150 000 so'm",
      'status': "Xizmat ko'rsatilmoqda",
    },
  ];

  final List<Map<String, dynamic>> _scheduledOrders = [
    {
      'id': 'ORD-004',
      'service': 'Ofis tozalash',
      'icon': Icons.business_rounded,
      'address': 'Shayxontohur tumani, Navoiy 55',
      'price': "250 000 so'm",
      'status': 'Rejalashtirilgan',
      'date': '18 Iyul 2026, 10:00',
    },
  ];

  final List<Map<String, dynamic>> _completedOrders = [
    {
      'id': 'ORD-005',
      'service': 'Uy tozalash',
      'icon': Icons.cleaning_services_rounded,
      'address': "Mirzo Ulug'bek tumani, Amir Temur 12",
      'price': "100 000 so'm",
      'status': 'Tugallangan',
    },
    {
      'id': 'ORD-006',
      'service': 'Deraza yuvish',
      'icon': Icons.window,
      'address': 'Mirobod tumani, Nukus 7',
      'price': "60 000 so'm",
      'status': 'Tugallangan',
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
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
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: theme.bg,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.arrow_back_ios_new_rounded, color: theme.text, size: 18),
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: theme.green,
          labelColor: theme.green,
          unselectedLabelColor: theme.hint,
          labelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
          tabs: const [
            Tab(text: 'Faol'),
            Tab(text: 'Rejalashtirilgan'),
            Tab(text: 'Tugallangan'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildOrdersList(_activeOrders, theme),
          _buildOrdersList(_scheduledOrders, theme),
          _buildOrdersList(_completedOrders, theme),
        ],
      ),
    );
  }

  Widget _buildOrdersList(List<Map<String, dynamic>> orders, GlossTheme theme) {
    if (orders.isEmpty) {
      return Center(child: GlossEmptyState.orders());
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: orders.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final order = orders[index];
        final status = order['status'] as String;

        return GlossCard(
          padding: const EdgeInsets.all(16),
          onTap: () => context.push('/orders/${order['id']}'),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: theme.greenBgLight,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(order['icon'] as IconData, color: theme.green, size: 22),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          order['service'] as String,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: theme.text,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          order['id'] as String,
                          style: TextStyle(fontSize: 12, color: theme.hint),
                        ),
                      ],
                    ),
                  ),
                  GlossBadge.status(status),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(Icons.location_on_outlined, size: 14, color: theme.hint),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      order['address'] as String,
                      style: TextStyle(fontSize: 12, color: theme.hint),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    order['price'] as String,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: theme.greenText,
                    ),
                  ),
                ],
              ),
              if (order.containsKey('date')) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.calendar_today_outlined, size: 13, color: theme.hint),
                    const SizedBox(width: 4),
                    Text(
                      order['date'] as String,
                      style: TextStyle(fontSize: 12, color: theme.hint),
                    ),
                  ],
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}