import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ui_kit/ui_kit.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

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
          children: [
            _buildProfileHeader(theme),
            const SizedBox(height: 16),
            _buildTeamBadge(theme),
            const SizedBox(height: 16),
            _buildMenuItems(theme, context),
            const SizedBox(height: 24),
            _buildLogoutButton(theme, context),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(GlossTheme theme) {
    return GlossCard(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                width: 88,
                height: 88,
                decoration: BoxDecoration(
                  color: theme.greenBgLight,
                  shape: BoxShape.circle,
                  border: Border.all(color: theme.green.withValues(alpha: 0.20), width: 3),
                ),
                child: Icon(Icons.person, size: 40, color: theme.green),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: theme.green,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: const Icon(Icons.camera_alt, size: 14, color: Colors.white),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            'Jasur Aliyev',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            '+998 90 123 45 67',
            style: TextStyle(fontSize: 14, color: theme.hint),
          ),
        ],
      ),
    );
  }

  Widget _buildTeamBadge(GlossTheme theme) {
    return GlossCard(
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
            child: Icon(Icons.group_rounded, color: theme.green, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Gloss Toshkent Jamoasi',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: theme.text),
                ),
                const SizedBox(height: 2),
                Text(
                  "Faol jamoa a'zosi",
                  style: TextStyle(fontSize: 12, color: theme.greenText),
                ),
              ],
            ),
          ),
          const GlossBadge(label: 'Faol'),
        ],
      ),
    );
  }

  Widget _buildMenuItems(GlossTheme theme, BuildContext context) {
    final items = [
      {'icon': Icons.person_outline, 'label': "Shaxsiy ma'lumotlar", 'route': null},
      {'icon': Icons.badge_outlined, 'label': "Team ma'lumotlari", 'route': null},
      {'icon': Icons.description_outlined, 'label': 'Hujjatlar', 'route': null},
      {'icon': Icons.settings_outlined, 'label': 'Sozlamalar', 'route': '/settings'},
    ];

    return GlossCard(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        children: items.asMap().entries.map((entry) {
          final isLast = entry.key == items.length - 1;
          final item = entry.value;
          return GlossMenuItem(
            icon: item['icon'] as IconData,
            title: item['label'] as String,
            showDivider: !isLast,
            iconColor: theme.green,
            onTap: () {
              final route = item['route'] as String?;
              if (route != null) {
                context.push(route);
              } else {
                GlossSnackBar.showInfo(context, 'Tez orada');
              }
            },
          );
        }).toList(),
      ),
    );
  }

  Widget _buildLogoutButton(GlossTheme theme, BuildContext context) {
    return SizedBox(
      height: 52,
      child: OutlinedButton(
        onPressed: () => _showLogoutDialog(theme, context),
        style: OutlinedButton.styleFrom(
          foregroundColor: theme.red,
          side: BorderSide(color: theme.red.withValues(alpha: 0.30)),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        child: const Text('Chiqish'),
      ),
    );
  }

  void _showLogoutDialog(GlossTheme theme, BuildContext context) {
    GlossDialog.show(
      context: context,
      title: 'Chiqish',
      content: 'Akkountingizdan chiqishni xohlaysizmi?',
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Bekor qilish'),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            context.go('/splash');
          },
          child: Text('Chiqish', style: TextStyle(color: theme.red)),
        ),
      ],
    );
  }
}