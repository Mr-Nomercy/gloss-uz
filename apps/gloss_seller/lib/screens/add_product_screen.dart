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
                Text('Mahsulot nomi', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: theme.hint)),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _nameController,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: theme.text),
                  decoration: InputDecoration(
                    hintText: 'Mahsulot nomini kiriting',
                    hintStyle: TextStyle(color: theme.hint),
                    filled: true,
                    fillColor: theme.bg,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: theme.border),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: theme.border),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: theme.green, width: 2),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                  ),
                ),
                const SizedBox(height: 16),
                Text('Narxi (so\'m)', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: theme.hint)),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _priceController,
                  keyboardType: TextInputType.number,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: theme.text),
                  decoration: InputDecoration(
                    hintText: '0',
                    hintStyle: TextStyle(color: theme.hint),
                    filled: true,
                    fillColor: theme.bg,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: theme.border),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: theme.border),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: theme.green, width: 2),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                  ),
                ),
                const SizedBox(height: 16),
                Text('Soni', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: theme.hint)),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _stockController,
                  keyboardType: TextInputType.number,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: theme.text),
                  decoration: InputDecoration(
                    hintText: '0',
                    hintStyle: TextStyle(color: theme.hint),
                    filled: true,
                    fillColor: theme.bg,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: theme.border),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: theme.border),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: theme.green, width: 2),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                  ),
                ),
                const SizedBox(height: 16),
                Text('Tavsifi', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: theme.hint)),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _descController,
                  maxLines: 3,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: theme.text),
                  decoration: InputDecoration(
                    hintText: 'Mahsulot tavsifini kiriting',
                    hintStyle: TextStyle(color: theme.hint),
                    filled: true,
                    fillColor: theme.bg,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: theme.border),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: theme.border),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: theme.green, width: 2),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                  ),
                ),
                const SizedBox(height: 16),
                Text('Kategoriya', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: theme.hint)),
                const SizedBox(height: 12),
                TextFormField(
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: theme.text),
                  decoration: InputDecoration(
                    hintText: 'Kategoriyani tanlang',
                    hintStyle: TextStyle(color: theme.hint),
                    filled: true,
                    fillColor: theme.bg,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: theme.border),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: theme.border),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: theme.green, width: 2),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                    suffixIcon: Icon(Icons.arrow_drop_down, color: theme.hint),
                  ),
                  readOnly: true,
                  onTap: () {},
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 52,
            child: ElevatedButton(
              onPressed: _isLoading ? null : () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.green,
                foregroundColor: Colors.white,
                disabledBackgroundColor: theme.disabled,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                elevation: 0,
                textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              ),
              child: _isLoading
                  ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                  : const Text('Saqlash'),
            ),
          ),
        ],
      ),
    );
  }
}
