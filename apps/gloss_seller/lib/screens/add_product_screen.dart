import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:ui_kit/ui_kit.dart';
import 'animations.dart';

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
  final _categoryController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _submitError = false;
  String? _nameError;
  String? _priceError;
  String? _stockError;
  String? _selectedCategory;

  final _categories = [
    'Elektronika',
    'Kiyim-kechak',
    'Oziq-ovqat',
    'Mebel',
    'Kitoblar',
    'Sport mollari',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _stockController.dispose();
    _descController.dispose();
    _categoryController.dispose();
    super.dispose();
  }

  bool _validate() {
    bool valid = true;
    setState(() {
      _nameError = null;
      _priceError = null;
      _stockError = null;
    });

    if (_nameController.text.trim().isEmpty) {
      _nameError = 'Mahsulot nomini kiriting';
      valid = false;
    }
    if (_priceController.text.trim().isEmpty) {
      _priceError = 'Narxni kiriting';
      valid = false;
    }
    if (_stockController.text.trim().isEmpty) {
      _stockError = 'Soni kiriting';
      valid = false;
    }
    return valid;
  }

  void _handleSave() {
    if (!_validate()) return;
    setState(() {
      _isLoading = true;
      _submitError = false;
    });
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() => _isLoading = false);
        GlossSnackBar.showInfo(context, 'Mahsulot saqlandi');
        context.pop();
      }
    }).catchError((_) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _submitError = true;
        });
      }
    });
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
          FadeSlideOnMount(
            child: DashedBorder(
              color: theme.greenBorderLight,
              strokeWidth: 2,
              child: Container(
                height: 200,
                decoration: BoxDecoration(
                  color: theme.greenBgPale,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(14),
                    onTap: () {},
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 56,
                            height: 56,
                            decoration: BoxDecoration(
                              color: theme.green.withValues(alpha: 0.1),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(Icons.add_photo_alternate, size: 28, color: theme.green),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Rasm qo\'shish',
                            style: TextStyle(color: theme.hint, fontSize: 14, fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'PNG, JPG (max 5MB)',
                            style: TextStyle(color: theme.disabled, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          FadeSlideOnMount(
            delay: const Duration(milliseconds: 100),
            child: GlossCard(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GlossTextField(
                      label: 'Mahsulot nomi',
                      hint: 'Mahsulot nomini kiriting',
                      controller: _nameController,
                      errorText: _nameError,
                      textCapitalization: TextCapitalization.sentences,
                      onChanged: (_) {
                        if (_nameError != null) {
                          setState(() => _nameError = null);
                        }
                      },
                    ),
                    const SizedBox(height: 16),
                    GlossTextField(
                      label: 'Narxi (so\'m)',
                      hint: '0',
                      controller: _priceController,
                      keyboardType: TextInputType.number,
                      errorText: _priceError,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      onChanged: (_) {
                        if (_priceError != null) {
                          setState(() => _priceError = null);
                        }
                      },
                    ),
                    const SizedBox(height: 16),
                    GlossTextField(
                      label: 'Soni',
                      hint: '0',
                      controller: _stockController,
                      keyboardType: TextInputType.number,
                      errorText: _stockError,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      onChanged: (_) {
                        if (_stockError != null) {
                          setState(() => _stockError = null);
                        }
                      },
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
                      controller: _categoryController,
                      suffixIcon: Icon(Icons.arrow_drop_down, color: context.gloss.hint),
                      filled: false,
                      readOnly: true,
                      onTap: _showCategoryPicker,
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          if (_submitError)
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: GlossErrorView.connection(
                onRetry: _handleSave,
              ),
            ),
          FadeSlideOnMount(
            delay: const Duration(milliseconds: 200),
            child: GlossButton(
              label: 'Saqlash',
              isLoading: _isLoading,
              onPressed: _isLoading ? null : _handleSave,
            ),
          ),
        ],
      ),
    );
  }

  void _showCategoryPicker() {
    final theme = context.gloss;
    showModalBottomSheet(
      context: context,
      backgroundColor: theme.card,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 8),
              Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: theme.disabled,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Text(
                      'Kategoriyani tanlang',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: theme.text),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              ..._categories.map(
                (c) => ListTile(
                  title: Text(c, style: TextStyle(fontSize: 15, color: theme.text)),
                  trailing: _selectedCategory == c
                      ? Icon(Icons.check_circle, color: theme.green)
                      : null,
                  onTap: () {
                    setState(() {
                      _selectedCategory = c;
                      _categoryController.text = c;
                    });
                    Navigator.pop(context);
                  },
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }
}
