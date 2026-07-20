import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ui_kit/ui_kit.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  bool _isOnline = true;
  bool _isLoading = true;
  bool _hasError = false;
  late final AnimationController _fadeController;
  late final Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
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
          'Gloss Deliver',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            color: theme.text,
            letterSpacing: -0.5,
          ),
        ),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: Icon(Icons.notifications_outlined, color: theme.text),
                onPressed: () {},
              ),
              Positioned(
                right: 8,
                top: 8,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: theme.red,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: _isLoading
          ? const GlossLoadingView(message: 'Yuklanmoqda...')
          : _hasError
              ? GlossErrorView.connection(onRetry: _loadData)
              : FadeTransition(
                  opacity: _fadeAnimation,
                  child: RefreshIndicator(
                    color: theme.green,
                    onRefresh: _loadData,
                    child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _buildOnlineToggle(theme),
              const SizedBox(height: 16),
              _buildBalanceCard(theme),
              const SizedBox(height: 20),
              _buildStatsRow(theme),
              const SizedBox(height: 24),
              _buildQuickActions(theme),
              const SizedBox(height: 24),
              _buildRecentDeliveries(theme),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOnlineToggle(GlossTheme theme) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      child: GlossCard(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: _isOnline ? theme.greenBgLight : theme.orangeBgLight,
                borderRadius: BorderRadius.circular(12),
              ),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: Icon(
                  _isOnline ? Icons.wifi : Icons.wifi_off,
                  key: ValueKey(_isOnline),
                  color: _isOnline ? theme.green : theme.orange,
                  size: 28,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: Column(
                  key: ValueKey('status_$_isOnline'),
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _isOnline ? 'Holatingiz: Onlayn' : 'Holatingiz: Oflayn',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: theme.text,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _isOnline
                          ? 'Buyurtmalarni qabul qilishingiz mumkin'
                          : 'Yangi buyurtmalar kelmaydi',
                      style: TextStyle(fontSize: 12, color: theme.hint),
                    ),
                  ],
                ),
              ),
            ),
            Switch(
              value: _isOnline,
              onChanged: (v) => setState(() => _isOnline = v),
              activeTrackColor: theme.green,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBalanceCard(GlossTheme theme) {
    return GlossBalanceCard(
      title: 'Mavjud balans',
      balance: "2 450 000 so'm",
      actionLabel: 'Pul chiqarish',
      onAction: () {},
    );
  }

  Widget _buildStatsRow(GlossTheme theme) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _scaleTap(
                child: const GlossStatCard(
                  label: 'Bugun',
                  value: '12',
                  icon: Icons.today,
                  padding: EdgeInsets.symmetric(vertical: 14),
                ),
                onTap: () {},
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _scaleTap(
                child: GlossStatCard(
                  label: 'Reyting',
                  value: '4.8',
                  icon: Icons.star,
                  suffix: '⭐',
                  color: theme.star,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                onTap: () {},
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: _scaleTap(
                child: const GlossStatCard(
                  label: 'Jami',
                  value: '487',
                  icon: Icons.check_circle,
                  padding: EdgeInsets.symmetric(vertical: 14),
                ),
                onTap: () {},
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _scaleTap(
                child: const GlossStatCard(
                  label: 'Masofa',
                  value: '234 km',
                  icon: Icons.route,
                  padding: EdgeInsets.symmetric(vertical: 14),
                ),
                onTap: () {},
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildQuickActions(GlossTheme theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const GlossSectionHeader(title: 'TEZKOR AMALLAR'),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _quickAction(
                Icons.receipt_long, 'Buyurtmalar', () => context.push('/orders'), theme),
            _quickAction(
                Icons.bar_chart, 'Statistika', () => context.push('/stats'), theme),
            _quickAction(Icons.help_outline, 'Yordam', () {}, theme),
            _quickAction(
                Icons.settings, 'Sozlamalar', () => context.push('/profile'), theme),
          ],
        ),
      ],
    );
  }

  Widget _quickAction(
      IconData icon, String label, VoidCallback onTap, GlossTheme theme) {
    return _scaleTap(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: theme.greenBgLight,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: theme.green, size: 26),
            ),
            const SizedBox(height: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: theme.text,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentDeliveries(GlossTheme theme) {
    final deliveries = [
      const _Delivery(
          'iPhone 15 Pro', 'Amir Temur 45 → Navoiy 12', '120 000', 'Yetkazilgan'),
      const _Delivery("Samsung Galaxy S24", 'Bunyodkor 78 → Beruniy 5', '150 000',
          "Yo'lda"),
      const _Delivery('MacBook Pro', 'Muqimiy 23 → Shota Rustaveli 8', '200 000',
          'Qabul qilingan'),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const GlossSectionHeader(title: "SO'NGGI YETKAZMALAR"),
        const SizedBox(height: 8),
        if (deliveries.isEmpty)
          GlossEmptyState.orders()
        else
          ...deliveries.map(
            (d) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: _deliveryTile(d, theme),
            ),
          ),
      ],
    );
  }

  Widget _deliveryTile(_Delivery d, GlossTheme theme) {
    final statusColor = d.status == 'Yetkazilgan'
        ? theme.green
        : d.status == "Yo'lda"
            ? theme.orange
            : GlossColors.catBlue;

    return _scaleTap(
      onTap: () {},
      child: GlossCard(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: statusColor.withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(10),
              ),
              child:
                  Icon(Icons.inventory_2, color: statusColor, size: 24),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    d.name,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: theme.text,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    d.address,
                    style: TextStyle(fontSize: 12, color: theme.hint),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${d.price} so\'m',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                    color: theme.green,
                  ),
                ),
                const SizedBox(height: 4),
                GlossBadge.status(d.status),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _scaleTap({required Widget child, VoidCallback? onTap}) {
    return _ScaleTapWidget(onTap: onTap, child: child);
  }
}

class _ScaleTapWidget extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;

  const _ScaleTapWidget({required this.child, this.onTap});

  @override
  State<_ScaleTapWidget> createState() => _ScaleTapWidgetState();
}

class _ScaleTapWidgetState extends State<_ScaleTapWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
    );
    _scale = Tween<double>(begin: 1.0, end: 0.97).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) => _controller.reverse(),
      onTapCancel: () => _controller.reverse(),
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _scale,
        builder: (_, child) => Transform.scale(
          scale: _scale.value,
          child: child,
        ),
        child: widget.child,
      ),
    );
  }
}

class _Delivery {
  final String name;
  final String address;
  final String price;
  final String status;
  const _Delivery(this.name, this.address, this.price, this.status);
}
