import 'package:flutter/material.dart';
import 'package:ui_kit/ui_kit.dart';
import 'order_history_screen.dart';
import 'favorites_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GlossColors.bg,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: GlossColors.bg,
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: GlossColors.bg, borderRadius: BorderRadius.circular(12)),
            child: const Icon(Icons.arrow_back_ios_new_rounded, color: GlossColors.text, size: 18),
          ),
        ),
        title: const Text(
          'Profil',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: GlossColors.text),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 16),
            _buildProfileHeader(),
            const SizedBox(height: 20),
            _buildMenuSection(context),
            const SizedBox(height: 24),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: GlossColors.card,
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Row(
        children: [
          CircleAvatar(
            radius: 36,
            backgroundColor: GlossColors.green,
            child: Icon(Icons.person_rounded, color: GlossColors.card, size: 40),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Foydalanuvchi',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: GlossColors.text),
                ),
                SizedBox(height: 4),
                Text(
                  '+998 xx xxx xx xx',
                  style: TextStyle(fontSize: 14, color: Colors.black54),
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

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: GlossColors.card,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: menuItems.map((item) {
          final (icon, title, subtitle) = item;
          final isLast = item == menuItems.last;
          return Column(
            children: [
              ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: GlossColors.bg,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: GlossColors.green, size: 22),
                ),
                title: Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: GlossColors.text)),
                subtitle: Text(subtitle, style: TextStyle(fontSize: 12, color: Colors.grey[500])),
                trailing: const Icon(Icons.chevron_right_rounded, color: GlossColors.disabled, size: 22),
                onTap: () {
                  if (title == 'Buyurtmalarim') {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const OrderHistoryScreen()));
                  } else if (title == 'Sevimlilar') {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const FavoritesScreen()));
                  } else if (title == 'Yordam') {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Yordam markazi tez orada'), behavior: SnackBarBehavior.floating),
                    );
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
              ),
              if (!isLast)
                Divider(height: 1, indent: 56, color: Colors.grey[200]),
            ],
          );
        }).toList(),
      ),
    );
  }
}
