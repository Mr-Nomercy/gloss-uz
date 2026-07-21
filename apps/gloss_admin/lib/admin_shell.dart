import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ui_kit/ui_kit.dart';

class AdminShell extends StatefulWidget {
  final Widget child;
  const AdminShell({super.key, required this.child});

  @override
  State<AdminShell> createState() => _AdminShellState();
}

class _AdminShellState extends State<AdminShell> {
  int _currentIndex = 0;

  static const _tabs = [
    _TabInfo(0, '/dashboard', 'Boshqaruv', Icons.dashboard_rounded),
    _TabInfo(1, '/orders', 'Buyurtmalar', Icons.receipt_long_rounded),
    _TabInfo(2, '/tenants', 'Provayderlar', Icons.business_rounded),
    _TabInfo(3, '/more', 'Yana', Icons.grid_view_rounded),
  ];

  int _locationToIndex(String location) {
    for (final tab in _tabs) {
      if (location.startsWith(tab.path)) return tab.index;
    }
    return _currentIndex;
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.gloss;
    final location = GoRouterState.of(context).uri.toString();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final idx = _locationToIndex(location);
      if (idx != _currentIndex && mounted) {
        setState(() => _currentIndex = idx);
      }
    });

    return Scaffold(
      backgroundColor: Colors.white,
      body: widget.child,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(color: theme.blackTint4, blurRadius: 8, offset: const Offset(0, -1))],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Row(
              children: _tabs.map((tab) {
                final isActive = _currentIndex == tab.index;
                return Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() => _currentIndex = tab.index);
                      context.go(tab.path);
                    },
                    behavior: HitTestBehavior.opaque,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      decoration: BoxDecoration(
                        color: isActive ? Colors.white : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                      ),
                        child: Column(mainAxisSize: MainAxisSize.min, children: [
                        Icon(tab.icon, size: 22,                         color: isActive ? theme.green : theme.hint),
                        const SizedBox(height: 2),
                        Text(tab.label, style: TextStyle(fontSize: 10, fontWeight: isActive ? FontWeight.w700 : FontWeight.w500, color: isActive ? theme.green : theme.hint)),
                      ]),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }
}

class _TabInfo {
  final int index;
  final String path;
  final String label;
  final IconData icon;
  const _TabInfo(this.index, this.path, this.label, this.icon);
}
