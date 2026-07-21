import 'package:flutter/material.dart';
import 'package:ui_kit/ui_kit.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen>
    with TickerProviderStateMixin {
  late final TabController _tabController;
  late final AnimationController _fadeController;
  late final Animation<double> _fadeAnimation;
  bool _isLoading = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    );
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });
    _fadeController.reset();
    try {
      await Future.delayed(const Duration(milliseconds: 300));
      if (mounted) {
        setState(() => _isLoading = false);
        _fadeController.forward();
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _hasError = true;
        });
      }
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _fadeController.dispose();
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
          style: TextStyle(
            color: theme.text,
            fontWeight: FontWeight.w700,
            fontSize: 20,
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: theme.green,
          labelColor: theme.green,
          unselectedLabelColor: theme.hint,
          labelStyle:
              const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
          tabs: const [
            Tab(text: 'Faol'),
            Tab(text: 'Tugallangan'),
          ],
        ),
      ),
      body: _isLoading
          ? const GlossLoadingView(message: 'Yuklanmoqda...')
          : _hasError
              ? GlossErrorView.connection(onRetry: _loadData)
              : FadeTransition(
                  opacity: _fadeAnimation,
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _buildOrderList(_activeOrders, theme),
                      _buildOrderList(_completedOrders, theme),
                    ],
                  ),
                ),
    );
  }

  Widget _buildOrderList(List<_Order> orders, GlossTheme theme) {
    if (orders.isEmpty) {
      return const SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: SizedBox(
          height: 400,
          child: GlossEmptyState(
            icon: Icons.receipt_long,
            title: 'Buyurtmalar mavjud emas',
            subtitle: 'Hozircha hech qanday buyurtma yo\'q',
          ),
        ),
      );
    }

    return RefreshIndicator(
      color: theme.green,
      onRefresh: () async {
        await Future.delayed(const Duration(seconds: 1));
      },
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        itemCount: orders.length,
        itemBuilder: (ctx, i) => _SlideInItem(
          index: i,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: _orderTile(orders[i], theme),
          ),
        ),
      ),
    );
  }

  Widget _orderTile(_Order o, GlossTheme theme) {
    final statusColor = switch (o.status) {
      'Qabul qilingan' => GlossColors.catBlue,
      "Yo'lda"       => theme.orange,
      'Yetkazilgan'   => theme.green,
      'Bekor qilingan' => theme.red,
      _              => theme.hint,
    };

    return GlossCard(
      padding: EdgeInsets.zero,
      onTap: () => _showOrderDetails(o, theme),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border(
            left: BorderSide(color: statusColor, width: 4),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
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
                    child: Icon(Icons.shopping_bag, color: statusColor, size: 26),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          o.product,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                            color: theme.text,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          o.price,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: theme.green,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 5),
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  color: theme.bg,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.location_on, size: 16, color: theme.red),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        o.from,
                        style: TextStyle(fontSize: 13, color: theme.text),
                      ),
                    ),
                    Icon(Icons.arrow_forward, size: 14, color: theme.hint),
                    const SizedBox(width: 4),
                    Icon(Icons.location_on, size: 16, color: theme.green),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        o.to,
                        style: TextStyle(fontSize: 13, color: theme.text),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showOrderDetails(_Order o, GlossTheme theme) {
    final statusColor = switch (o.status) {
      'Qabul qilingan' => GlossColors.catBlue,
      "Yo'lda"       => theme.orange,
      'Yetkazilgan'   => theme.green,
      'Bekor qilingan' => theme.red,
      _              => theme.hint,
    };

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Padding(
        padding: EdgeInsets.only(
          left: 24,
          right: 24,
          top: 24,
          bottom: MediaQuery.of(context).viewInsets.bottom + 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: theme.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.10),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(Icons.inventory_2, color: statusColor, size: 30),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        o.product,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: theme.text,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: statusColor.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: GlossBadge.status(o.status),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _detailRow(Icons.location_on, 'Manzil',
                '${o.from} → ${o.to}', theme),
            const SizedBox(height: 12),
            _detailRow(Icons.payment, 'Narx', o.price, theme),
            const SizedBox(height: 12),
            _detailRow(
                Icons.phone, 'Mijoz', '+998 93 123 45 67', theme),
            const SizedBox(height: 12),
            _detailRow(
                Icons.access_time, 'Vaqt', 'Bugun, 14:30', theme),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.green,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  elevation: 0,
                  textStyle: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w700),
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

  Widget _detailRow(
      IconData icon, String label, String value, GlossTheme theme) {
    return Row(
      children: [
        Icon(icon, size: 18, color: theme.hint),
        const SizedBox(width: 8),
        Text('$label: ',
            style: TextStyle(fontSize: 14, color: theme.hint)),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: theme.text,
            ),
          ),
        ),
      ],
    );
  }

  final _activeOrders = [
    const _Order('iPhone 15 Pro 256GB', 'Amir Temur', 'Navoiy',
        "120 000 so'm", 'Qabul qilingan'),
    const _Order("Samsung Galaxy S24", 'Bunyodkor', 'Beruniy',
        "150 000 so'm", "Yo'lda"),
    const _Order('MacBook Pro 14"', 'Muqimiy', 'Shota Rustaveli',
        "200 000 so'm", 'Qabul qilingan'),
    const _Order('Sony PlayStation 5', 'Chilonzor', 'Sergeli',
        "180 000 so'm", "Yo'lda"),
  ];

  final _completedOrders = [
    const _Order("Dyson V15 Vacuum", "Mirzo Ulug'bek", 'Yakkasaroy',
        "135 000 so'm", 'Yetkazilgan'),
    const _Order('iPad Air M2', 'Olmazor', 'Chilonzor',
        "110 000 so'm", 'Yetkazilgan'),
    const _Order('Asus ROG Laptop', 'Shayxontohur', 'Uchtepa',
        "160 000 so'm", 'Bekor qilingan'),
    const _Order('AirPods Pro', 'Yunusobod', "Mirzo Ulug'bek",
        "90 000 so'm", 'Yetkazilgan'),
  ];
}

class _SlideInItem extends StatefulWidget {
  final int index;
  final Widget child;

  const _SlideInItem({required this.index, required this.child});

  @override
  State<_SlideInItem> createState() => _SlideInItemState();
}

class _SlideInItemState extends State<_SlideInItem>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );
    _slide = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));

    Future.delayed(
        Duration(milliseconds: 80 * widget.index), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _slide,
      child: FadeTransition(
        opacity: _controller,
        child: widget.child,
      ),
    );
  }
}

class _Order {
  final String product;
  final String from;
  final String to;
  final String price;
  final String status;
  const _Order(
      this.product, this.from, this.to, this.price, this.status);
}
