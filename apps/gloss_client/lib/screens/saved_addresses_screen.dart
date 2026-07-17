import 'package:flutter/material.dart';
import 'package:ui_kit/ui_kit.dart';

class SavedAddressesScreen extends StatefulWidget {
  const SavedAddressesScreen({super.key});

  @override
  State<SavedAddressesScreen> createState() => _SavedAddressesScreenState();
}

class _SavedAddressesScreenState extends State<SavedAddressesScreen> {
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
        title: const Text("Manzillarim", style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: GlossColors.text)),
      ),
      body: ListView(
        children: [
          SizedBox(height: MediaQuery.of(context).size.height * 0.3),
          const Center(
            child: Column(
              children: [
                Icon(Icons.location_on_rounded, size: 64, color: GlossColors.disabled),
                SizedBox(height: 16),
                Text("Manzillar yo'q", style: TextStyle(fontSize: 16, color: GlossColors.hint)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
