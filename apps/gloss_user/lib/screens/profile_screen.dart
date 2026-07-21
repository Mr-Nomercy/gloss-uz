import 'package:flutter/material.dart';
import 'package:ui_kit/ui_kit.dart';
import 'order_history_screen.dart';
import 'favorites_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.gloss.bg,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: context.gloss.bg,
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: context.gloss.bg,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.arrow_back_ios_new_rounded, color: context.gloss.text, size: 18),
          ),
        ),
        title: Text(
          'Profil',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: context.gloss.text),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 16),
            _buildProfileHeader(context),
            const SizedBox(height: 20),
            _buildMenuSection(context),
            const SizedBox(height: 24),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context) {
    return GlossCard(
      child: Row(
        children: [
          CircleAvatar(
            radius: 36,
            backgroundColor: context.gloss.green,
            child: Icon(Icons.person_rounded, color: context.gloss.card, size: 40),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Foydalanuvchi',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: context.gloss.text),
                ),
                const SizedBox(height: 4),
                Text(
                  '+998 xx xxx xx xx',
                  style: TextStyle(fontSize: 14, color: context.gloss.hint),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuSection(BuildContext context) {
    final menuItems = [
      (Icons.shopping_bag_rounded, "Buyurtmalarim", "O'tgan buyurtmalar"),
      (Icons.favorite_rounded, 'Sevimlilar', 'Saqlangan mahsulotlar'),
      (Icons.help_rounded, 'Yordam', "Ko'p beriladigan savollar"),
      (Icons.info_rounded, 'Ilova haqida', 'v1.0.0'),
    ];

    return GlossCard(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        children: menuItems.asMap().entries.map((entry) {
          final isLast = entry.key == menuItems.length - 1;
          final item = menuItems[entry.key];
          final (icon, title, subtitle) = item;
          return GlossMenuItem(
            icon: icon,
            title: title,
            subtitle: subtitle,
            showDivider: !isLast,
            iconColor: context.gloss.green,
            onTap: () {
              if (title == 'Buyurtmalarim') {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const OrderHistoryScreen()));
              } else if (title == 'Sevimlilar') {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const FavoritesScreen()));
              } else if (title == 'Yordam') {
                GlossSnackBar.showInfo(context, 'Yordam markazi tez orada');
              } else if (title == 'Ilova haqida') {
                showAboutDialog(
                  context: context,
                  applicationName: 'Gloss',
                  applicationVersion: '1.0.0',
                  applicationIcon: const Icon(Icons.cleaning_services_rounded, color: GlossColors.green, size: 40),
                  children: const [Text('Tozalash xizmatlari va mahsulotlari platformasi')],
                );
              }
            },
          );
        }).toList(),
      ),
    );
  }
}