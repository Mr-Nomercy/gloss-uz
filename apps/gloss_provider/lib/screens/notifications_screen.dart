import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ui_kit/ui_kit.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final List<Map<String, dynamic>> _notifications = [
    {
      'type': 'order',
      'icon': Icons.receipt_long_rounded,
      'title': 'Yangi buyurtma',
      'message': "Yangi buyurtma keldi: Uy tozalash, 120 000 so'm",
      'time': '2 daqiqa oldin',
    },
    {
      'type': 'payment',
      'icon': Icons.payment_rounded,
      'title': "To'lov qabul qilindi",
      'message': "ORD-005 uchun 100 000 so'm to'lov tasdiqlandi",
      'time': '1 soat oldin',
    },
    {
      'type': 'system',
      'icon': Icons.info_outline,
      'title': 'Tizim yangilanishi',
      'message': 'Yangi versiya mavjud: 1.1.0. Iltimos, yangilang',
      'time': '3 soat oldin',
    },
    {
      'type': 'order',
      'icon': Icons.receipt_long_rounded,
      'title': 'Buyurtma bekor qilindi',
      'message': 'ORD-003 buyurtmasini mijoz bekor qildi',
      'time': '5 soat oldin',
    },
    {
      'type': 'payment',
      'icon': Icons.payment_rounded,
      'title': 'Pul chiqarish',
      'message': "500 000 so'm kartangizga o'tkazildi",
      'time': 'Kecha, 14:30',
    },
    {
      'type': 'system',
      'icon': Icons.info_outline,
      'title': 'Hisob tekshiruvi',
      'message': 'Hisobingiz tasdiqlandi. Barcha funksiyalar mavjud',
      'time': 'Kecha, 10:00',
    },
  ];

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

  @override
  Widget build(BuildContext context) {
    final theme = context.gloss;
    return Scaffold(
      backgroundColor: theme.bg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Bildirishnomalar',
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
        actions: [
          if (_notifications.isNotEmpty)
            TextButton(
              onPressed: () {
                setState(() => _notifications.clear());
                GlossSnackBar.showSuccess(context, "Bildirishnomalar tozalandi");
              },
              child: Text(
                'Tozalash',
                style: TextStyle(color: theme.red, fontSize: 14),
              ),
            ),
        ],
      ),
      body: _notifications.isEmpty
          ? Center(child: GlossEmptyState.notifications())
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _notifications.length,
              itemBuilder: (context, index) {
                final notif = _notifications[index];
                final typeColor = _typeColor(theme, notif['type'] as String);

                return Dismissible(
                  key: Key('notif_$index'),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: theme.red,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20),
                    child: const Icon(Icons.delete_outline, color: Colors.white),
                  ),
                  onDismissed: (_) {
                    setState(() => _notifications.removeAt(index));
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: GlossCard(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: typeColor.withValues(alpha: 0.10),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              notif['icon'] as IconData,
                              color: typeColor,
                              size: 20,
                            ),
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
                                        notif['title'] as String,
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: theme.text,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      notif['time'] as String,
                                      style: TextStyle(fontSize: 11, color: theme.hint),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  notif['message'] as String,
                                  style: TextStyle(fontSize: 13, color: theme.hint, height: 1.4),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}