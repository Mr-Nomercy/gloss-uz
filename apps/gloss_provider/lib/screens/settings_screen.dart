// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ui_kit/ui_kit.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  bool _soundEnabled = true;
  String _selectedLanguage = "O'zbekcha";

  @override
  Widget build(BuildContext context) {
    final theme = context.gloss;
    return Scaffold(
      backgroundColor: theme.bg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Sozlamalar',
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
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildSection(
              theme: theme,
              title: 'Umumiy',
              children: [
                _buildLanguageTile(theme),
                _buildDivider(theme),
                _buildSwitchTile(
                  theme: theme,
                  icon: Icons.notifications_outlined,
                  title: 'Bildirishnomalar',
                  value: _notificationsEnabled,
                  onChanged: (v) => setState(() => _notificationsEnabled = v),
                ),
                _buildDivider(theme),
                _buildSwitchTile(
                  theme: theme,
                  icon: Icons.volume_up_outlined,
                  title: 'Ovoz',
                  value: _soundEnabled,
                  onChanged: (v) => setState(() => _soundEnabled = v),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildSection(
              theme: theme,
              title: 'Huquqiy',
              children: [
                _buildLinkTile(
                  theme: theme,
                  icon: Icons.description_outlined,
                  title: 'Foydalanish shartlari',
                  onTap: () {},
                ),
                _buildDivider(theme),
                _buildLinkTile(
                  theme: theme,
                  icon: Icons.privacy_tip_outlined,
                  title: 'Maxfiylik siyosati',
                  onTap: () {},
                ),
                _buildDivider(theme),
                _buildLinkTile(
                  theme: theme,
                  icon: Icons.info_outline,
                  title: 'Dastur haqida',
                  onTap: () => _showAboutDialog(context, theme),
                ),
              ],
            ),
            const SizedBox(height: 24),
            _buildLogoutButton(theme, context),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({
    required GlossTheme theme,
    required String title,
    required List<Widget> children,
  }) {
    return GlossCard(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text(
              title,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: theme.hint,
              ),
            ),
          ),
          ...children,
        ],
      ),
    );
  }

  Widget _buildDivider(GlossTheme theme) {
    return Divider(height: 1, indent: 56, color: theme.divider);
  }

  Widget _buildLanguageTile(GlossTheme theme) {
    return ListTile(
      leading: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: theme.greenBgLight,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(Icons.language_rounded, color: theme.green, size: 18),
      ),
      title: const Text('Til'),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            _selectedLanguage,
            style: TextStyle(fontSize: 14, color: theme.hint),
          ),
          const SizedBox(width: 4),
          Icon(Icons.chevron_right, color: theme.hint),
        ],
      ),
      onTap: () => _showLanguageSheet(context, theme),
    );
  }

  Widget _buildSwitchTile({
    required GlossTheme theme,
    required IconData icon,
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return ListTile(
      leading: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: theme.greenBgLight,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: theme.green, size: 18),
      ),
      title: Text(title, style: TextStyle(fontSize: 14, color: theme.text)),
      trailing: Switch(
        value: value,
        activeTrackColor: theme.green,
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildLinkTile({
    required GlossTheme theme,
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: theme.greenBgLight,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: theme.green, size: 18),
      ),
      title: Text(title, style: TextStyle(fontSize: 14, color: theme.text)),
      trailing: Icon(Icons.chevron_right, color: theme.hint, size: 20),
      onTap: onTap,
    );
  }

  void _showLanguageSheet(BuildContext context, GlossTheme theme) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: theme.grayMedium,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Tilni tanlang',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: theme.text,
                  ),
                ),
                const SizedBox(height: 16),
                RadioListTile<String>(
                  title: const Text("O'zbekcha"),
                  value: "O'zbekcha",
                  groupValue: _selectedLanguage,
                  toggleable: true,
                  activeColor: theme.green,
                  onChanged: (v) {
                    setState(() => _selectedLanguage = v!);
                    Navigator.pop(ctx);
                  },
                ),
                RadioListTile<String>(
                  title: const Text('Русский'),
                  value: 'Русский',
                  groupValue: _selectedLanguage,
                  toggleable: true,
                  activeColor: theme.green,
                  onChanged: (v) {
                    setState(() => _selectedLanguage = v!);
                    Navigator.pop(ctx);
                  },
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showAboutDialog(BuildContext context, GlossTheme theme) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.cleaning_services_rounded, color: theme.green),
            const SizedBox(width: 8),
            const Text('Gloss Provider'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Versiya: 1.0.0', style: TextStyle(color: theme.text)),
            const SizedBox(height: 8),
            Text(
              'Gloss tozalash xizmati yetkazib beruvchilari uchun maxsus dastur.',
              style: TextStyle(color: theme.hint, fontSize: 13),
            ),
            const SizedBox(height: 8),
            Text(
              '© 2026 Gloss. Barcha huquqlar himoyalangan.',
              style: TextStyle(color: theme.hint, fontSize: 12),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Yopish', style: TextStyle(color: theme.green)),
          ),
        ],
      ),
    );
  }

  Widget _buildLogoutButton(GlossTheme theme, BuildContext context) {
    return SizedBox(
      height: 52,
      child: OutlinedButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              title: const Text('Chiqish'),
              content: const Text('Akkountingizdan chiqishni xohlaysizmi?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text('Bekor qilish'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(ctx);
                    context.go('/splash');
                  },
                  child: Text('Chiqish', style: TextStyle(color: theme.red)),
                ),
              ],
            ),
          );
        },
        style: OutlinedButton.styleFrom(
          foregroundColor: theme.red,
          side: BorderSide(color: theme.red.withAlpha(75)),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        child: const Text('Chiqish'),
      ),
    );
  }
}
