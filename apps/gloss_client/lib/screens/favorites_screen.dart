import 'package:flutter/material.dart';
import 'package:ui_kit/ui_kit.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GlossColors.bg,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: GlossColors.bg,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: GlossColors.bg, borderRadius: BorderRadius.circular(12)),
            child: const Icon(Icons.arrow_back_ios_new_rounded, color: GlossColors.text, size: 18),
          ),
        ),
        title: const Text(
          'Sevimlilar',
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: GlossColors.text),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(color: GlossColors.red.withAlpha(16), shape: BoxShape.circle),
              child: const Icon(Icons.favorite_border_rounded, size: 56, color: GlossColors.red),
            ),
            const SizedBox(height: 20),
            const Text(
              "Sevimlilar bo'sh",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: GlossColors.text),
            ),
            const SizedBox(height: 8),
            const Text(
              'Mahsulotlardagi ❤️ tugmasini bosing',
              style: TextStyle(fontSize: 14, color: GlossColors.hint),
            ),
          ],
        ),
      ),
    );
  }
}
