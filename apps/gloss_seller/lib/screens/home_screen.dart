import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ui_kit/ui_kit.dart';
import 'animations.dart';
import 'profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final _pages = [
    const _ProductsTab(),
    const Scaffold(body: Center(child: Text('Buyurtmalar'))),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = context.gloss;
    return Scaffold(
      backgroundColor: theme.bg,
      body: _pages[_currentIndex],
      bottomNavigationBar: NavigationBar(
        backgroundColor: theme.card,
        selectedIndex: _currentIndex,
        onDestinationSelected: (i) => setState(() => _currentIndex = i),
        indicatorColor: theme.greenBgLight,
        destinations: [
          NavigationDestination(
            icon: Icon(Icons.inventory_outlined, color: theme.hint),
            selectedIcon: Icon(Icons.inventory, color: theme.green),
            label: 'Mahsulotlar',
          ),
          NavigationDestination(
            icon: Icon(Icons.receipt_outlined, color: theme.hint),
            selectedIcon: Icon(Icons.receipt, color: theme.green),
            label: 'Buyurtmalar',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline, color: theme.hint),
            selectedIcon: Icon(Icons.person, color: theme.green),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}

class _ProductsTab extends StatefulWidget {
  const _ProductsTab();

  @override
  State<_ProductsTab> createState() => _ProductsTabState();
}

class _ProductsTabState extends State<_ProductsTab> {
  bool _isLoading = true;
  bool _hasError = false;

  final List<Map<String, dynamic>> _products = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });
    try {
      await Future.delayed(const Duration(milliseconds: 400));
      if (mounted) {
        _products.clear();
        for (int i = 0; i < 5; i++) {
          _products.add({
            'name': 'Mahsulot ${i + 1}',
            'price': '\$${(i + 1) * 10}.000',
          });
        }
        setState(() => _isLoading = false);
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
          'Mahsulotlar',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: theme.text),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.dashboard, color: theme.text),
            onPressed: () => context.go('/seller/dashboard'),
            tooltip: 'Panel',
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadData,
        color: theme.green,
        backgroundColor: theme.card,
        child: _isLoading
            ? const GlossLoadingView(message: 'Yuklanmoqda...')
            : _hasError
                ? GlossErrorView.connection(onRetry: _loadData)
                : _products.isEmpty
                    ? ListView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        children: const [
                          SizedBox(height: 120),
                          GlossEmptyState(
                            icon: Icons.inventory_2_outlined,
                            title: 'Mahsulotlar yo\'q',
                            subtitle: 'Hozircha hech qanday mahsulot mavjud emas',
                          ),
                        ],
                      )
                    : ListView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: const EdgeInsets.all(16),
                        children: [
                          FadeSlideOnMount(
                            child: ScaleTap(
                              onTap: () => context.go('/seller/add-product'),
                              child: GlossCard(
                                padding: const EdgeInsets.all(16),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 44,
                                      height: 44,
                                      decoration: BoxDecoration(
                                        color: theme.greenBgLight,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Icon(Icons.add_circle_outline, color: theme.green, size: 24),
                                    ),
                                    const SizedBox(width: 14),
                                    Expanded(
                                      child: Text(
                                        'Yangi mahsulot qo\'shish',
                                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: theme.text),
                                      ),
                                    ),
                                    Icon(Icons.chevron_right, color: theme.hint, size: 20),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          ..._products.asMap().entries.map((entry) {
                            final i = entry.key;
                            final product = entry.value;
                            final delay = Duration(milliseconds: 100 + i * 80);
                            return FadeSlideOnMount(
                              delay: delay,
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: ScaleTap(
                                  onTap: () => context.go('/seller/add-product'),
                                  child: GlossCard(
                                    padding: const EdgeInsets.all(16),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 52,
                                          height: 52,
                                          decoration: BoxDecoration(
                                            color: theme.greenBgPale,
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          child: Icon(Icons.inventory_2, color: theme.green, size: 28),
                                        ),
                                        const SizedBox(width: 14),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                product['name'] as String,
                                                style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w600,
                                                  color: theme.text,
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                product['price'] as String,
                                                style: TextStyle(
                                                  fontSize: 13,
                                                  color: theme.greenText,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Icon(Icons.chevron_right, color: theme.hint, size: 20),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }),
                        ],
                      ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.go('/seller/add-product'),
        backgroundColor: theme.green,
        foregroundColor: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        child: const Icon(Icons.add),
      ),
    );
  }
}
