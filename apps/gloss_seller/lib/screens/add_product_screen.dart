import 'package:flutter/material.dart';
import 'package:ui_kit/ui_kit.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _stockController = TextEditingController();
  final _descController = TextEditingController();
  final bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _stockController.dispose();
    _descController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.gloss;
    return Scaffold(
      backgroundColor: theme.bg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "Mahsulot qo'shish",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: theme.text),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            height: 200,
            decoration: BoxDecoration(
              color: theme.greenBgPale,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: theme.greenBorderLight, width: 1.5),
            ),
            child: const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add_photo_alternate, size: 48, color: Color(0xFFBDBDBD)),
                  SizedBox(height: 8),
                  Text('Rasm qo\'shish', style: TextStyle(color: Color(0xFFBDBDBD), fontSize: 14)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          GlossCard(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GlossTextField(
                  label: 'Mahsulot nomi',
                  hint: 'Mahsulot nomini kiriting',
                  controller: _nameController,
                ),
                const SizedBox(height: 16),
                GlossTextField(
                  label: 'Narxi (so\'m)',
                  hint: '0',
                  controller: _priceController,
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                GlossTextField(
                  label: 'Soni',
                  hint: '0',
                  controller: _stockController,
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                GlossTextField(
                  label: 'Tavsifi',
                  hint: 'Mahsulot tavsifini kiriting',
                  controller: _descController,
                  maxLines: 3,
                ),
                const SizedBox(height: 16),
                GlossTextField(
                  label: 'Kategoriya',
                  hint: 'Kategoriyani tanlang',
                  suffixIcon: Icon(Icons.arrow_drop_down, color: context.gloss.hint),
                  filled: false,
                  readOnly: true,
                  onTap: () {},
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          GlossButton(
            label: 'Saqlash',
            isLoading: _isLoading,
            onPressed: _isLoading ? null : () {},
          ),
        ],
      ),
    );
  }
}