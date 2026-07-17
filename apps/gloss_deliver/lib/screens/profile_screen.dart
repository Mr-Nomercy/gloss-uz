import 'package:flutter/material.dart';
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
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildProfileHeader(theme),
          const SizedBox(height: 24),
          _buildMenuSection(theme),
          const SizedBox(height: 24),
          _buildLogoutButton(theme, context),
        ],
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
            'Jasur Qurbonov',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            '+998 93 123 45 67',
            style: TextStyle(fontSize: 14, color: theme.hint),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.star, size: 16, color: GlossColors.star),
              const SizedBox(width: 4),
              const Text('4.8', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
              Text(' (487 ta buyurtma)', style: TextStyle(fontSize: 13, color: theme.hint)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMenuSection(GlossTheme theme) {
    final items = [
      (Icons.person_outline, "Shaxsiy ma'lumotlar"),
      (Icons.directions_car_outlined, "Transport ma'lumotlari"),
      (Icons.description_outlined, 'Hujjatlar'),
      (Icons.help_outline, 'Yordam'),
      (Icons.info_outline, 'Ilova haqida'),
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
                  child: Icon(entry.value.$1, color: theme.green, size: 18),
                ),
                title: Text(entry.value.$2, style: TextStyle(fontSize: 14, color: theme.text)),
                trailing: Icon(Icons.chevron_right, color: theme.hint, size: 20),
                onTap: () {},
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
        onPressed: () => _showLogoutDialog(context, theme),
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

  void _showLogoutDialog(BuildContext context, GlossTheme theme) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Chiqishni tasdiqlash'),
        content: const Text('Haqiqatan ham akkauntdan chiqmoqchimisiz?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text("Yo'q", style: TextStyle(color: theme.hint)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx),
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.red,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              elevation: 0,
            ),
            child: const Text('Chiqish'),
          ),
        ],
      ),
    );
  }
}
