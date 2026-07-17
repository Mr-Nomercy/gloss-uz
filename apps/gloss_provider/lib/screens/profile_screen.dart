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
                  border: Border.all(color: theme.green.withAlpha(50), width: 3),
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
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: theme.greenBgLight,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              'Faol',
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: theme.green),
            ),
          ),
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
      padding: EdgeInsets.zero,
      child: Column(
        children: items.asMap().entries.map((entry) {
          final isLast = entry.key == items.length - 1;
          return Column(
            children: [
              ListTile(
                leading: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: theme.bg,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(entry.value['icon'] as IconData, color: theme.green, size: 18),
                ),
                title: Text(
                  entry.value['label'] as String,
                  style: TextStyle(fontSize: 14, color: theme.text),
                ),
                trailing: Icon(Icons.chevron_right, color: theme.hint),
                onTap: () {
                  final route = entry.value['route'] as String?;
                  if (route != null) {
                    context.push(route);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Tez orada'),
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
                      ),
                    );
                  }
                },
              ),
              if (!isLast) Divider(height: 1, indent: 68, color: theme.divider),
            ],
          );
        }).toList(),
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
