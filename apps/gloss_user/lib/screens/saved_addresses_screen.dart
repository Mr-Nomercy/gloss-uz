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
      backgroundColor: context.gloss.bg,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: context.gloss.bg,
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
        title: Text("Manzillarim", style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: context.gloss.text)),
      ),
      body: Center(
        child: GlossEmptyState.addresses(
          onAction: () {
            GlossSnackBar.showInfo(context, 'Manzil qo\'shish');
          },
        ),
      ),
    );
  }
}