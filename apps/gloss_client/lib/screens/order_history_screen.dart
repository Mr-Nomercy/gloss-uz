import 'package:flutter/material.dart';
import 'package:ui_kit/ui_kit.dart';

class OrderHistoryScreen extends StatefulWidget {
  const OrderHistoryScreen({super.key});

  @override
  State<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
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
        title: const Text("Buyurtmalarim", style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: GlossColors.text)),
      ),
      body: ListView(
        children: [
          SizedBox(height: MediaQuery.of(context).size.height * 0.2),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(color: GlossColors.green.withAlpha(16), shape: BoxShape.circle),
                  child: const Icon(Icons.shopping_bag_rounded, size: 56, color: GlossColors.green),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Buyurtmalar yo'q",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: GlossColors.text),
                ),
                const SizedBox(height: 8),
                const Text(
                  "Xizmat buyurtma qiling va tarixda ko'ring",
                  style: TextStyle(fontSize: 14, color: GlossColors.hint),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
