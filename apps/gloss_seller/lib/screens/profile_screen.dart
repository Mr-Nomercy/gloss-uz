import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ui_kit/ui_kit.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  void _showComingSoon(BuildContext context) {
    GlossSnackBar.showInfo(context, 'Tez orada');
  }

  void _showLogoutDialog(BuildContext context) {
    final theme = context.gloss;
    GlossDialog.show(
      context: context,
      title: 'Chiqish',
      content: 'Haqiqatan ham hisobdan chiqmoqchimisiz?',
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Bekor qilish', style: TextStyle(color: theme.hint)),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            context.go('/auth/login');
          },
          child: Text('Chiqish', style: TextStyle(color: theme.red)),
        ),
      ],
    );
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
          'Profil',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: theme.text),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const SizedBox(height: 8),
          Center(
            child: Column(
              children: [
                Container(
                  width: 88,
                  height: 88,
                  decoration: BoxDecoration(
                    color: theme.green,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.store, size: 44, color: Colors.white),
                ),
                const SizedBox(height: 16),
                Text(
                  "Mening do'konim",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: theme.text, height: 1.3),
                ),
                const SizedBox(height: 4),
                Text(
                  '+998 XX XXX XX XX',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal, color: theme.hint, height: 1.5),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.star, size: 18, color: theme.star),
                    const SizedBox(width: 4),
                    Text('4.8', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: theme.text)),
                    const SizedBox(width: 4),
                    Text('(12 ta sharh)', style: TextStyle(fontSize: 12, color: theme.hint)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          GlossCard(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Column(
              children: [
                GlossMenuItem(
                  icon: Icons.store,
                  title: "Do'kon ma'lumotlari",
                  onTap: () {},
                  showDivider: true,
                ),
                GlossMenuItem(
                  icon: Icons.description,
                  title: 'KYC hujjatlari',
                  onTap: () {},
                  showDivider: true,
                ),
                GlossMenuItem(
                  icon: Icons.account_balance_wallet,
                  title: "To'lov hisobi",
                  onTap: () => _showComingSoon(context),
                  showDivider: true,
                ),
                GlossMenuItem(
                  icon: Icons.help_outline,
                  title: 'Yordam',
                  onTap: () => _showComingSoon(context),
                  showDivider: true,
                ),
                GlossMenuItem.destructive(
                  icon: Icons.logout,
                  title: 'Chiqish',
                  onTap: () => _showLogoutDialog(context),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}