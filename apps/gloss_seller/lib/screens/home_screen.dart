import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ui_kit/ui_kit.dart';
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

class _ProductsTab extends StatelessWidget {
  const _ProductsTab();

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
        onRefresh: () => Future.delayed(const Duration(seconds: 1)),
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            GlossCard(
              padding: const EdgeInsets.all(16),
              onTap: () => context.go('/seller/add-product'),
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
            const SizedBox(height: 16),
            ...List.generate(5, (i) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
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
                            'Mahsulot ${i + 1}',
                            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: theme.text),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '\$${(i + 1) * 10}.000',
                            style: TextStyle(fontSize: 13, color: theme.greenText, fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                    Icon(Icons.chevron_right, color: theme.hint, size: 20),
                  ],
                ),
              ),
            )),
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
