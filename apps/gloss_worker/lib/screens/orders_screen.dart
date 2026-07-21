import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gloss_worker/widgets/gloss_tap_scale.dart';
import 'package:gloss_worker/widgets/mock_async_loader.dart';
import 'package:ui_kit/ui_kit.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late AnimationController _shimmerController;
  late AnimationController _listAnimationController;
  int _previousTabIndex = 0;
  final _loaderKey = GlobalKey<MockAsyncLoaderState>();

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

  List<Map<String, dynamic>> get _currentOrders {
    switch (_tabController.index) {
      case 0:
        return _activeOrders;
      case 1:
        return _scheduledOrders;
      case 2:
        return _completedOrders;
      default:
        return _activeOrders;
    }
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(_onTabChanged);

    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _listAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

  }

  void _onTabChanged() {
    if (!_tabController.indexIsChanging &&
        _tabController.index != _previousTabIndex) {
      _previousTabIndex = _tabController.index;
      _loaderKey.currentState?.reload();
    }
  }

  Future<void> _onRefresh() async {
    await _loaderKey.currentState?.reload();
  }

  @override
  void dispose() {
    _tabController.removeListener(_onTabChanged);
    _tabController.dispose();
    _shimmerController.dispose();
    _listAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.gloss;
    return Scaffold(
      backgroundColor: theme.bg,
      appBar: GlossAppBar(
        title: 'Buyurtmalar',
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: theme.green,
          labelColor: theme.green,
          unselectedLabelColor: theme.hint,
          labelStyle:
              const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
          tabs: [
            _buildTab('Faol', _activeOrders.length),
            _buildTab('Rejalashtirilgan', _scheduledOrders.length),
            _buildTab('Tugallangan', _completedOrders.length),
          ],
        ),
      ),
      body: RefreshIndicator(
        color: theme.green,
        backgroundColor: theme.card,
        onRefresh: _onRefresh,
        child: MockAsyncLoader(
          key: _loaderKey,
          delay: const Duration(milliseconds: 600),
          loadingBuilder: (_) => _buildShimmerList(theme),
          contentBuilder: (_) => _buildOrdersWithAnimation(theme),
          errorBuilder: (_, onRetry) => GlossErrorView.connection(onRetry: onRetry),
          onLoadStart: () {
            _shimmerController.repeat();
            _listAnimationController.reset();
          },
          onLoaded: () {
            _shimmerController.stop();
            _listAnimationController.forward();
          },
        ),
      ),
    );
  }

  Widget _buildTab(String label, int count) {
    return Tab(
      child: FittedBox(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(label),
            const SizedBox(width: 6),
            Container(
            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
            decoration: BoxDecoration(
              color: context.gloss.green.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              '$count',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: context.gloss.green,
              ),
            ),
          ),
        ],
        ),
      ),
    );
  }

  Widget _buildOrdersWithAnimation(GlossTheme theme) {
    final orders = _currentOrders;
    if (orders.isEmpty) {
      return GlossEmptyState.orders();
    }

    final itemCount = orders.length;
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: itemCount,
      itemBuilder: (context, index) {
        final order = orders[index];
        return _buildOrderCard(order, index, itemCount, theme);
      },
    );
  }

  Widget _buildOrderCard(
    Map<String, dynamic> order,
    int index,
    int totalItems,
    GlossTheme theme,
  ) {
    final status = order['status'] as String;
    final borderColor = _statusBorderColor(status, theme);

    return _SlideItem(
      index: index,
      totalItems: totalItems,
      controller: _listAnimationController,
      child: GlossTapScale(
        curve: Curves.easeOutCubic,
        onTap: () => context.push('/orders/${order['id']}'),
        child: Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: theme.card,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: theme.blackTint10,
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(width: 4, color: borderColor),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: _CardContent(order: order, theme: theme),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _statusBorderColor(String status, GlossTheme theme) {
    final lower = status.toLowerCase();
    if (lower.contains('tugallangan') ||
        lower.contains('completed') ||
        lower.contains('baholangan') ||
        lower.contains('rated')) {
      return theme.grayMedium;
    }
    if (lower.contains('rejalashtirilgan') ||
        lower.contains('scheduled') ||
        lower.contains("yo'lda") ||
        lower.contains("en route") ||
        lower.contains("xizmat ko'rsatilmoqda") ||
        lower.contains('in progress') ||
        lower.contains('jarayonda')) {
      return theme.orange;
    }
    return theme.green;
  }

  Widget _buildShimmerList(GlossTheme theme) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 3,
      itemBuilder: (context, index) {
        return AnimatedBuilder(
          animation: _shimmerController,
          builder: (context, child) {
            final shimmerValue = _shimmerController.value;
            return Container(
              height: 110,
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: theme.card,
                borderRadius: BorderRadius.circular(12),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  color: theme.grayLight,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: 140,
                                      height: 14,
                                      decoration: BoxDecoration(
                                        color: theme.grayLight,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Container(
                                      width: 80,
                                      height: 10,
                                      decoration: BoxDecoration(
                                        color: theme.grayLight,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                width: 80,
                                height: 24,
                                decoration: BoxDecoration(
                                  color: theme.grayLight,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Container(
                                width: 14,
                                height: 14,
                                decoration: BoxDecoration(
                                  color: theme.grayLight,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Container(
                                  height: 10,
                                  decoration: BoxDecoration(
                                    color: theme.grayLight,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Container(
                                width: 70,
                                height: 14,
                                decoration: BoxDecoration(
                                  color: theme.grayLight,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      left: (shimmerValue * 2 - 1) * 400,
                      top: 0,
                      bottom: 0,
                      child: Container(
                        width: 60,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              theme.card.withValues(alpha: 0),
                              Colors.white.withValues(alpha: 0.5),
                              theme.card.withValues(alpha: 0),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class _CardContent extends StatelessWidget {
  final Map<String, dynamic> order;
  final GlossTheme theme;

  const _CardContent({required this.order, required this.theme});

  @override
  Widget build(BuildContext context) {
    return Column(
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
              child:
                  Icon(order['icon'] as IconData, color: theme.green, size: 22),
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
            GlossBadge.status(order['status'] as String),
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
              Icon(Icons.calendar_today_outlined,
                  size: 13, color: theme.hint),
              const SizedBox(width: 4),
              Text(
                order['date'] as String,
                style: TextStyle(fontSize: 12, color: theme.hint),
              ),
            ],
          ),
        ],
      ],
    );
  }
}

class _SlideItem extends StatelessWidget {
  final Widget child;
  final int index;
  final int totalItems;
  final AnimationController controller;

  const _SlideItem({
    required this.child,
    required this.index,
    required this.totalItems,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final step = 1.0 / math.max(totalItems, 1);
    final begin = (index * step * 0.6).clamp(0.0, 1.0);
    final end = ((index + 1) * step * 0.6 + 0.4).clamp(0.0, 1.0);

    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 0.15),
            end: Offset.zero,
          ).animate(
            CurvedAnimation(
              parent: controller,
              curve: Interval(begin, end, curve: Curves.easeOutCubic),
            ),
          ),
          child: FadeTransition(
            opacity: Tween<double>(begin: 0, end: 1).animate(
              CurvedAnimation(
                parent: controller,
                curve: Interval(begin, end),
              ),
            ),
            child: child,
          ),
        );
      },
      child: child,
    );
  }
}

