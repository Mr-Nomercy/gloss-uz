import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ui_kit/ui_kit.dart';
import '../providers/market_provider.dart';

class ProductFormScreen extends ConsumerStatefulWidget {
  final String? productId;
  const ProductFormScreen({super.key, this.productId});

  bool get isEditing => productId != null;

  @override
  ConsumerState<ProductFormScreen> createState() =>
      _ProductFormScreenState();
}

class _ProductFormScreenState extends ConsumerState<ProductFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _priceCtrl = TextEditingController();
  final _salePriceCtrl = TextEditingController();
  final _stockCtrl = TextEditingController();
  String? _selectedCategory;
  bool _isActive = true;

  static final _categories = [
    'Tozalash vositalari',
    'Tozalash anjomlari',
    'Ehtiyot qismlar',
    'Aksessuarlar',
  ];

  @override
  void initState() {
    super.initState();
    if (widget.isEditing) {
      _nameCtrl.text = 'Universal tozalash vositasi';
      _descCtrl.text = 'Barcha yuzalar uchun universal tozalash vositasi';
      _priceCtrl.text = '25000';
      _salePriceCtrl.text = '19900';
      _stockCtrl.text = '150';
      _selectedCategory = 'Tozalash vositalari';
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _descCtrl.dispose();
    _priceCtrl.dispose();
    _salePriceCtrl.dispose();
    _stockCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.gloss;

    return Scaffold(
      backgroundColor: theme.bg,
      appBar: GlossAppBar(
        title: widget.isEditing ? 'Mahsulotni tahrirlash' : 'Yangi mahsulot',
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: theme.grayLight,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: theme.border,
                      style: BorderStyle.solid,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add_photo_alternate_rounded,
                          size: 32, color: theme.hint),
                      const SizedBox(height: 4),
                      Text(
                        'Rasm yuklash',
                        style: TextStyle(fontSize: 12, color: theme.hint),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              const _Label('Mahsulot nomi'),
              const SizedBox(height: 8),
              GlossTextField(
                controller: _nameCtrl,
                hint: 'Nomi',
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Nomni kiriting' : null,
              ),
              const SizedBox(height: 16),
              const _Label('Tavsif'),
              const SizedBox(height: 8),
              GlossTextField(
                controller: _descCtrl,
                hint: 'Tavsif',
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              const _Label('Kategoriya'),
              const SizedBox(height: 8),
              GlossCard(
                accentColor: theme.orange,
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedCategory,
                    hint: Text(
                      'Kategoriyani tanlang',
                      style: TextStyle(color: theme.hint, fontSize: 14),
                    ),
                    isExpanded: true,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: GlossColors.text,
                    ),
                    items: _categories.map((c) {
                      return DropdownMenuItem(value: c, child: Text(c));
                    }).toList(),
                    onChanged: (v) => setState(() => _selectedCategory = v),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const _Label('Narxi'),
                        const SizedBox(height: 8),
                        GlossTextField(
                          controller: _priceCtrl,
                          hint: '0',
                          keyboardType: TextInputType.number,
                          validator: (v) => (v == null || v.trim().isEmpty)
                              ? 'Narxni kiriting'
                              : null,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const _Label('Chegirma narxi'),
                        const SizedBox(height: 8),
                        GlossTextField(
                          controller: _salePriceCtrl,
                          hint: '0',
                          keyboardType: TextInputType.number,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const _Label('Ombordagi soni'),
                        const SizedBox(height: 8),
                        GlossTextField(
                          controller: _stockCtrl,
                          hint: '0',
                          keyboardType: TextInputType.number,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const _Label('Holati'),
                        const SizedBox(height: 8),
                        GlossCard(
                          accentColor: theme.orange,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 12),
                          child: Row(
                            children: [
                              Text(
                                _isActive ? 'Aktiv' : 'Nofaol',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: _isActive
                                      ? theme.green
                                      : theme.hint,
                                ),
                              ),
                              const Spacer(),
                              Switch(
                                value: _isActive,
                                onChanged: (v) =>
                                    setState(() => _isActive = v),
                                 activeTrackColor: theme.green.withValues(alpha: 0.4),
                                 activeThumbColor: theme.green,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              Row(
                children: [
                  if (widget.isEditing)
                    Expanded(
                      child: GlossButton(
                        label: "O'chirish",
                        isOutlined: true,
                        onPressed: () async {
                          final confirmed = await GlossDialog.show<bool>(
                            context: context,
                            title: "O'chirishni tasdiqlash",
                            content: 'Mahsulotni o\'chirishni xohlaysizmi?',
                            confirmLabel: "O'chirish",
                            cancelLabel: 'Bekor qilish',
                          );
                          if (confirmed == true && mounted) {
                            await ref
                                .read(marketProvider.notifier)
                                .deleteProduct(widget.productId!);
                            if (mounted) Navigator.of(context).pop();
                          }
                        },
                      ),
                    ),
                  if (widget.isEditing) const SizedBox(width: 12),
                  Expanded(
                    child: GlossButton(
                      label: widget.isEditing ? 'Saqlash' : "Qo'shish",
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}

class _Label extends StatelessWidget {
  final String text;
  const _Label(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: GlossColors.text,
      ),
    );
  }
}
