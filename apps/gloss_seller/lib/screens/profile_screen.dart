import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ui_kit/ui_kit.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  void _showComingSoon(BuildContext context) {
    final theme = context.gloss;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Tez orada'),
        backgroundColor: theme.green,
        behavior: SnackBarBehavior.floating,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    final theme = context.gloss;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Chiqish'),
        content: const Text('Haqiqatan ham hisobdan chiqmoqchimisiz?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Bekor qilish', style: TextStyle(color: theme.hint)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              context.go('/auth/login');
            },
            child: Text('Chiqish', style: TextStyle(color: theme.red)),
          ),
        ],
      ),
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
                    Text(
                      '(12 ta sharh)',
                      style: TextStyle(fontSize: 12, color: theme.hint),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          GlossCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                _buildMenuItem(theme, Icons.store, "Do'kon ma'lumotlari", () {}),
                Divider(height: 1, color: theme.divider, indent: 56),
                _buildMenuItem(theme, Icons.description, 'KYC hujjatlari', () {}),
                Divider(height: 1, color: theme.divider, indent: 56),
                _buildMenuItem(theme, Icons.account_balance_wallet, "To'lov hisobi", () => _showComingSoon(context)),
                Divider(height: 1, color: theme.divider, indent: 56),
                _buildMenuItem(theme, Icons.help_outline, 'Yordam', () => _showComingSoon(context)),
                Divider(height: 1, color: theme.divider, indent: 56),
                _buildMenuItem(theme, Icons.logout, 'Chiqish', () => _showLogoutDialog(context), isDestructive: true),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(GlossTheme theme, IconData icon, String title, VoidCallback onTap, {bool isDestructive = false}) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Icon(icon, color: isDestructive ? theme.red : theme.green, size: 22),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: isDestructive ? theme.red : theme.text,
                ),
              ),
            ),
            Icon(Icons.chevron_right, color: theme.hint, size: 20),
          ],
        ),
      ),
    );
  }
}
