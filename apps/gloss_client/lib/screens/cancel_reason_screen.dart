import 'package:flutter/material.dart';
import 'package:ui_kit/ui_kit.dart';

class CancelReasonScreen extends StatefulWidget {
  final String orderId;
  final String? orderNumber;

  const CancelReasonScreen({
    super.key,
    this.orderId = '',
    this.orderNumber,
  });

  @override
  State<CancelReasonScreen> createState() => _CancelReasonScreenState();
}

class _CancelReasonScreenState extends State<CancelReasonScreen> {
  String? _selectedReason;
  final _noteController = TextEditingController();
  bool _needsNote = false;

  static const _reasons = [
    {'id': 'plans_changed', 'label': "Rejam o'zgardi", 'needsNote': false},
    {'id': 'found_cheaper', 'label': 'Arzonroq topdim', 'needsNote': false},
    {'id': 'wait_too_long', 'label': 'Juda uzoq kutdim', 'needsNote': false},
    {'id': 'wrong_address', 'label': "Manzil noto'g'ri", 'needsNote': true},
    {'id': 'no_longer_need', 'label': 'Xizmat kerak emas', 'needsNote': false},
    {'id': 'provider_issue', 'label': 'Provider bilan muammo', 'needsNote': true},
    {'id': 'other', 'label': 'Boshqa', 'needsNote': true},
  ];

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  void _onReasonChanged(String? value) {
    if (value == null) return;
    final reason = _reasons.firstWhere((r) => r['id'] == value);
    setState(() {
      _selectedReason = value;
      _needsNote = reason['needsNote'] as bool;
    });
  }

  void _confirm() {
    if (_selectedReason == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Iltimos, sabab tanlang'), backgroundColor: Colors.red),
      );
      return;
    }
    if (_needsNote && _noteController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Iltimos, izoh yozing'), backgroundColor: Colors.red),
      );
      return;
    }
    Navigator.pop(context, {
      'reason': _selectedReason,
      'note': _noteController.text.trim().isEmpty ? null : _noteController.text.trim(),
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GlossColors.bg,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: GlossColors.bg,
        title: const Text('Bekor qilish sababi'),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: GlossColors.bg, borderRadius: BorderRadius.circular(12)),
            child: const Icon(Icons.arrow_back_ios_new_rounded, color: GlossColors.text, size: 18),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (widget.orderNumber != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Text('Buyurtma #${widget.orderNumber}', style: const TextStyle(fontSize: 14, color: GlossColors.hint)),
                    ),
                  ..._reasons.map((reason) => _ReasonTile(
                        id: reason['id'] as String,
                        label: reason['label'] as String,
                        isSelected: _selectedReason == reason['id'],
                        onTap: () => _onReasonChanged(reason['id'] as String),
                      )),
                  if (_needsNote) ...[
                    const SizedBox(height: 20),
                    const Text('Izoh', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: GlossColors.text)),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _noteController,
                      maxLines: 3,
                      decoration: InputDecoration(
                        hintText: "Sababni tushuntiring...",
                        hintStyle: const TextStyle(color: GlossColors.hint),
                        filled: true,
                        fillColor: GlossColors.card,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: GlossColors.border),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: GlossColors.border),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _confirm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: GlossColors.red,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Bekor qilish', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ReasonTile extends StatelessWidget {
  final String id;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _ReasonTile({
    required this.id,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isSelected ? GlossColors.greenBgLight : GlossColors.card,
          border: Border.all(
            color: isSelected ? GlossColors.green : GlossColors.border,
            width: isSelected ? 1.5 : 1,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Icon(
              isSelected ? Icons.radio_button_checked_rounded : Icons.radio_button_unchecked_rounded,
              color: isSelected ? GlossColors.green : GlossColors.disabled,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: TextStyle(fontSize: 15, color: GlossColors.text, fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
