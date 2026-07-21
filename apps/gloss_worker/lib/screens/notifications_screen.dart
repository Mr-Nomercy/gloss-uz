import 'package:flutter/material.dart';
import 'package:gloss_worker/widgets/gloss_tap_scale.dart';
import 'package:gloss_worker/widgets/mock_async_loader.dart';
import 'package:ui_kit/ui_kit.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen>
    with TickerProviderStateMixin {
  final List<_NotificationItem> _notifications = [
    _NotificationItem(
      type: 'order',
      icon: Icons.receipt_long_rounded,
      title: 'Yangi buyurtma',
      message: "Yangi buyurtma keldi: Uy tozalash, 120 000 so'm",
      time: '2 daqiqa oldin',
      isRead: false,
    ),
    _NotificationItem(
      type: 'payment',
      icon: Icons.payment_rounded,
      title: "To'lov qabul qilindi",
      message: "ORD-005 uchun 100 000 so'm to'lov tasdiqlandi",
      time: '1 soat oldin',
      isRead: false,
    ),
    _NotificationItem(
      type: 'system',
      icon: Icons.info_outline,
      title: 'Tizim yangilanishi',
      message: 'Yangi versiya mavjud: 1.1.0. Iltimos, yangilang',
      time: '3 soat oldin',
      isRead: true,
    ),
    _NotificationItem(
      type: 'order',
      icon: Icons.receipt_long_rounded,
      title: 'Buyurtma bekor qilindi',
      message: 'ORD-003 buyurtmasini mijoz bekor qildi',
      time: '5 soat oldin',
      isRead: true,
    ),
    _NotificationItem(
      type: 'payment',
      icon: Icons.payment_rounded,
      title: 'Pul chiqarish',
      message: "500 000 so'm kartangizga o'tkazildi",
      time: 'Kecha, 14:30',
      isRead: true,
    ),
    _NotificationItem(
      type: 'system',
      icon: Icons.info_outline,
      title: 'Hisob tekshiruvi',
      message: 'Hisobingiz tasdiqlandi. Barcha funksiyalar mavjud',
      time: 'Kecha, 10:00',
      isRead: true,
    ),
  ];

  late final AnimationController _fadeController;
  late final Animation<double> _fadeAnimation;
  final _loaderKey = GlobalKey<MockAsyncLoaderState>();

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _fadeAnimation =
        CurvedAnimation(parent: _fadeController, curve: Curves.easeOutCubic);
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  int get _unreadCount => _notifications.where((n) => !n.isRead).length;

  Color _typeColor(GlossTheme theme, String type) {
    switch (type) {
      case 'order':
        return GlossColors.catBlue;
      case 'payment':
        return theme.green;
      case 'system':
        return theme.orange;
      default:
        return theme.hint;
    }
  }

  void _markAllRead() {
    setState(() {
      for (final n in _notifications) {
        n.isRead = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.gloss;
    return Scaffold(
      backgroundColor: theme.bg,
      appBar: GlossAppBar(
        title: 'Bildirishnomalar',
        actions: [
          if (_notifications.isNotEmpty) ...[
            if (_unreadCount > 0)
              TextButton(
                onPressed: _markAllRead,
                child: Text(
                  'Barchasini o\'qish',
                  style: TextStyle(color: theme.green, fontSize: 13),
                ),
              ),
            TextButton(
              onPressed: () {
                setState(() => _notifications.clear());
                GlossSnackBar.showSuccess(
                    context, "Bildirishnomalar tozalandi");
              },
              child: Text(
                'Tozalash',
                style: TextStyle(color: theme.red, fontSize: 13),
              ),
            ),
          ],
        ],
      ),
      body: RefreshIndicator(
        color: theme.green,
        backgroundColor: theme.card,
        onRefresh: () async => _loaderKey.currentState?.reload(),
        child: MockAsyncLoader(
          key: _loaderKey,
          delay: const Duration(milliseconds: 150),
          loadingBuilder: (_) =>
              const GlossLoadingView(message: 'Yuklanmoqda...'),
          contentBuilder: (_) => _notifications.isEmpty
              ? FadeTransition(
                  opacity: _fadeAnimation,
                  child: GlossEmptyState.notifications(),
                )
              : FadeTransition(
                  opacity: _fadeAnimation,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _notifications.length,
                    itemBuilder: (context, index) {
                      final notif = _notifications[index];
                      final typeColor =
                          _typeColor(theme, notif.type);
                      return _NotificationTile(
                        notification: notif,
                        typeColor: typeColor,
                        theme: theme,
                        onTap: () {
                          setState(() => notif.isRead = true);
                        },
                        onDismissed: () {
                          setState(() => _notifications.removeAt(index));
                        },
                        index: index,
                        controller: _fadeController,
                      );
                    },
                  ),
                ),
          errorBuilder: (_, onRetry) =>
              GlossErrorView.connection(onRetry: onRetry),
          onLoadStart: _fadeController.reset,
          onLoaded: _fadeController.forward,
        ),
      ),
    );
  }
}

class _NotificationTile extends StatefulWidget {
  final _NotificationItem notification;
  final Color typeColor;
  final GlossTheme theme;
  final VoidCallback onTap;
  final VoidCallback onDismissed;
  final int index;
  final AnimationController controller;

  const _NotificationTile({
    required this.notification,
    required this.typeColor,
    required this.theme,
    required this.onTap,
    required this.onDismissed,
    required this.index,
    required this.controller,
  });

  @override
  State<_NotificationTile> createState() => _NotificationTileState();
}

class _NotificationTileState extends State<_NotificationTile>
    with TickerProviderStateMixin {
  late final AnimationController _dismissController;

  @override
  void initState() {
    super.initState();
    _dismissController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
  }

  @override
  void dispose() {
    _dismissController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = widget.theme;
    final notif = widget.notification;
    final typeColor = widget.typeColor;

    final staggeredAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: widget.controller,
        curve: Interval(
          (widget.index * 0.08).clamp(0.0, 1.0),
          (widget.index * 0.08 + 0.3).clamp(0.0, 1.0),
          curve: Curves.easeOutCubic,
        ),
      ),
    );

    return AnimatedBuilder(
      animation: staggeredAnimation,
      builder: (context, child) {
        return Opacity(
          opacity: staggeredAnimation.value,
          child: Transform.translate(
            offset: Offset(30 * (1 - staggeredAnimation.value), 0),
            child: child,
          ),
        );
      },
      child: Dismissible(
        key: ValueKey(notif.hashCode),
        direction: DismissDirection.endToStart,
        confirmDismiss: (_) async {
          await _dismissController.forward();
          return true;
        },
        background: AnimatedBuilder(
          animation: _dismissController,
          builder: (context, child) {
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: theme.red.withValues(alpha: _dismissController.value),
                borderRadius: BorderRadius.circular(12),
              ),
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: 20),
              child: const Icon(Icons.delete_outline, color: Colors.white),
            );
          },
        ),
        onDismissed: (_) => widget.onDismissed(),
        child: GlossTapScale(
          scale: 0.98,
          duration: const Duration(milliseconds: 100),
          onTap: widget.onTap,
          child: Container(
              margin: const EdgeInsets.only(bottom: 12),
              child: GlossCard(
                padding: const EdgeInsets.all(16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: typeColor.withValues(alpha: 0.10),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            notif.icon,
                            color: typeColor,
                            size: 20,
                          ),
                        ),
                        if (!notif.isRead)
                          Positioned(
                            top: 0,
                            right: 0,
                            child: Container(
                              width: 12,
                              height: 12,
                              decoration: BoxDecoration(
                                color: theme.red,
                                shape: BoxShape.circle,
                                border: Border.all(
                                    color: theme.card, width: 2),
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  notif.title,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: !notif.isRead
                                        ? FontWeight.w700
                                        : FontWeight.w600,
                                    color: theme.text,
                                  ),
                                ),
                              ),
                              Text(
                                notif.time,
                                style: TextStyle(
                                    fontSize: 11, color: theme.hint),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            notif.message,
                            style: TextStyle(
                              fontSize: 13,
                              color: theme.hint,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
    );
  }
}

class _NotificationItem {
  final String type;
  final IconData icon;
  final String title;
  final String message;
  final String time;
  bool isRead;

  _NotificationItem({
    required this.type,
    required this.icon,
    required this.title,
    required this.message,
    required this.time,
    required this.isRead,
  });
}
