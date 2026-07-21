import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ui_kit/ui_kit.dart';

class WorkerShell extends StatefulWidget {
  final Widget child;
  const WorkerShell({super.key, required this.child});

  @override
  State<WorkerShell> createState() => _WorkerShellState();
}

class _WorkerShellState extends State<WorkerShell> {
  int _currentIndex = 0;

  static const _tabs = [
    _ShellTab(0, '/worker/home', 'Asosiy', Icons.home_rounded),
    _ShellTab(1, '/worker/orders', 'Buyurtmalar', Icons.receipt_long_rounded),
    _ShellTab(2, '/worker/stats', 'Statistika', Icons.bar_chart_rounded),
    _ShellTab(3, '/worker/profile', 'Profil', Icons.person_rounded),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = context.gloss;
    final location = GoRouterState.of(context).uri.toString();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final idx = _tabs.indexWhere((t) => location.startsWith(t.path));
      if (idx >= 0 && idx != _currentIndex && mounted) {
        setState(() => _currentIndex = idx);
      }
    });

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: widget.child,
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: theme.blackTint4,
              blurRadius: 8,
              offset: const Offset(0, -1),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Row(
              children: _tabs.map((tab) {
                final active = _currentIndex == tab.index;
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
                        color: active ? theme.green.withValues(alpha: 0.08) : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(tab.icon, size: 22, color: active ? theme.green : theme.hint),
                          const SizedBox(height: 2),
                          Text(
                            tab.label,
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: active ? FontWeight.w700 : FontWeight.w500,
                              color: active ? theme.green : theme.hint,
                            ),
                          ),
                        ],
                      ),
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

class CourierShell extends StatefulWidget {
  final Widget child;
  const CourierShell({super.key, required this.child});

  @override
  State<CourierShell> createState() => _CourierShellState();
}

class _CourierShellState extends State<CourierShell> {
  int _currentIndex = 0;

  static const _tabs = [
    _ShellTab(0, '/courier/home', 'Asosiy', Icons.home_rounded),
    _ShellTab(1, '/courier/orders', 'Buyurtmalar', Icons.receipt_long_rounded),
    _ShellTab(2, '/courier/earnings', 'Daromad', Icons.account_balance_wallet_rounded),
    _ShellTab(3, '/courier/profile', 'Profil', Icons.person_rounded),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = context.gloss;
    final location = GoRouterState.of(context).uri.toString();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final idx = _tabs.indexWhere((t) => location.startsWith(t.path));
      if (idx >= 0 && idx != _currentIndex && mounted) {
        setState(() => _currentIndex = idx);
      }
    });

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: widget.child,
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: theme.blackTint4,
              blurRadius: 8,
              offset: const Offset(0, -1),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Row(
              children: _tabs.map((tab) {
                final active = _currentIndex == tab.index;
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
                        color: active ? theme.green.withValues(alpha: 0.08) : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(tab.icon, size: 22, color: active ? theme.green : theme.hint),
                          const SizedBox(height: 2),
                          Text(
                            tab.label,
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: active ? FontWeight.w700 : FontWeight.w500,
                              color: active ? theme.green : theme.hint,
                            ),
                          ),
                        ],
                      ),
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

class _ShellTab {
  final int index;
  final String path;
  final String label;
  final IconData icon;
  const _ShellTab(this.index, this.path, this.label, this.icon);
}
