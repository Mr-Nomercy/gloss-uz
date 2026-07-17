import 'package:flutter/material.dart';
import 'package:ui_kit/ui_kit.dart';
import 'address_search_screen.dart';
import 'order_success_screen.dart';

class CheckoutScreen extends StatefulWidget {
  final double subtotal;
  final double discount;
  final double delivery;
  final double total;
  final String? promoCode;

  const CheckoutScreen({
    super.key,
    required this.subtotal,
    required this.discount,
    required this.delivery,
    required this.total,
    this.promoCode,
  });

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  String _selectedPayment = 'cash';
  AddressResult? _addressResult;
  bool _addressError = false;
  bool _isPlacing = false;

  String formatPrice(double price) {
    final whole = price.toInt();
    final buf = StringBuffer();
    final s = whole.toString();
    for (int i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) buf.write(' ');
      buf.write(s[i]);
    }
    return "$buf so'm";
  }

  Future<void> _confirm() async {
    if (_addressResult == null) { setState(() => _addressError = true); return; }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Buyurtmani tasdiqlash', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Jami: ${formatPrice(widget.total)}', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
            const SizedBox(height: 4),
            Text('Manzil: ${_addressResult!.address}', style: TextStyle(fontSize: 13, color: Colors.grey[600])),
            const SizedBox(height: 4),
            Text("To'lov: ${_selectedPayment.toUpperCase()}", style: TextStyle(fontSize: 13, color: Colors.grey[600])),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text('Bekor qilish', style: TextStyle(color: Colors.grey[500]))),
          TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Tasdiqlash', style: TextStyle(color: GlossColors.green, fontWeight: FontWeight.w700))),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    setState(() => _isPlacing = true);
    await Future.delayed(const Duration(seconds: 1));
    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const OrderSuccessScreen(orderId: 'GLS-12345')),
      (route) => false,
    );
  }

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
        title: const Text("To'lov", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: GlossColors.text)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildAddressSection(),
            const SizedBox(height: 20),
            _buildPaymentSection(),
            const SizedBox(height: 20),
            _buildOrderSummary(),
            const SizedBox(height: 100),
          ],
        ),
      ),
      bottomSheet: _buildConfirmButton(),
    );
  }

  Widget _buildAddressSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Yetkazish manzili', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: GlossColors.text)),
        const SizedBox(height: 12),
        GestureDetector(
          onTap: () async {
            final result = await Navigator.push<AddressResult>(
              context,
              MaterialPageRoute(builder: (_) => const AddressSearchScreen()),
            );
            if (result != null) setState(() { _addressResult = result; _addressError = false; });
          },
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: GlossColors.card,
              borderRadius: BorderRadius.circular(16),
              border: _addressError ? Border.all(color: GlossColors.red, width: 1.5) : null,
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(color: GlossColors.green.withAlpha(20), borderRadius: BorderRadius.circular(10)),
                  child: const Icon(Icons.location_on_rounded, color: GlossColors.green, size: 22),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _addressResult == null ? 'Manzilni tanlang' : _addressResult!.address,
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: _addressResult == null ? Colors.grey[400] : GlossColors.text),
                      ),
                      if (_addressError)
                        const Padding(
                          padding: EdgeInsets.only(top: 4),
                          child: Text('Manzilni tanlash shart', style: TextStyle(fontSize: 12, color: GlossColors.red)),
                        ),
                    ],
                  ),
                ),
                Icon(Icons.chevron_right_rounded, color: Colors.grey[400], size: 24),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentSection() {
    final methods = [
      (id: 'cash', icon: Icons.money_rounded, title: 'Naqt pul', subtitle: 'Yetkazishda to\'lash'),
      (id: 'click', icon: Icons.mobile_friendly_rounded, title: 'Click', subtitle: 'Tez va oson'),
      (id: 'payme', icon: Icons.phone_iphone_rounded, title: 'Payme', subtitle: 'Mobil ilova orqali'),
      (id: 'card', icon: Icons.credit_card_rounded, title: 'Plastik karta', subtitle: 'Visa, MasterCard'),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("To'lov usuli", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: GlossColors.text)),
        const SizedBox(height: 12),
        ...methods.map((m) => _buildPaymentOption(m)),
      ],
    );
  }

  Widget _buildPaymentOption(({IconData icon, String id, String subtitle, String title}) m) {
    final selected = _selectedPayment == m.id;
    return GestureDetector(
      onTap: () => setState(() => _selectedPayment = m.id),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: GlossColors.card,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: selected ? GlossColors.green : GlossColors.border, width: selected ? 2 : 1),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: selected ? GlossColors.green.withAlpha(20) : GlossColors.bg, borderRadius: BorderRadius.circular(10)),
              child: Icon(m.icon, color: selected ? GlossColors.green : GlossColors.hint, size: 24),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(m.title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: GlossColors.text)),
                  Text(m.subtitle, style: TextStyle(fontSize: 12, color: Colors.grey[500])),
                ],
              ),
            ),
            Icon(selected ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded, color: selected ? GlossColors.green : Colors.grey[300], size: 22),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderSummary() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: GlossColors.card, borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Buyurtma xulosasi', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: GlossColors.text)),
          const SizedBox(height: 12),
          _priceRow('Mahsulotlar', formatPrice(widget.subtotal)),
          if (widget.discount > 0) _priceRow('Chegirma', '-${formatPrice(widget.discount)}', color: GlossColors.red),
          _priceRow('Yetkazish', widget.delivery == 0 ? 'Bepul' : formatPrice(widget.delivery), color: widget.delivery == 0 ? GlossColors.green : null),
          if (widget.promoCode != null)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Row(
                children: [
                  const Icon(Icons.local_offer_rounded, color: GlossColors.green, size: 14),
                  const SizedBox(width: 4),
                  Text(widget.promoCode!, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: GlossColors.green)),
                ],
              ),
            ),
          const Divider(height: 20),
          _priceRow('Jami', formatPrice(widget.total), bold: true),
        ],
      ),
    );
  }

  Widget _priceRow(String label, String value, {Color? color, bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: 14, color: color ?? GlossColors.hint, fontWeight: bold ? FontWeight.w700 : FontWeight.w400)),
          Text(value, style: TextStyle(fontSize: 14, color: color ?? GlossColors.text, fontWeight: bold ? FontWeight.w700 : FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _buildConfirmButton() {
    return Container(
      padding: EdgeInsets.fromLTRB(16, 12, 16, MediaQuery.of(context).padding.bottom + 12),
      decoration: BoxDecoration(color: GlossColors.card, boxShadow: [BoxShadow(color: Colors.black.withAlpha(10), blurRadius: 10, offset: const Offset(0, -2))]),
      child: SizedBox(
        width: double.infinity, height: 54,
        child: ElevatedButton(
          onPressed: _isPlacing ? null : _confirm,
          style: ElevatedButton.styleFrom(backgroundColor: GlossColors.green, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)), elevation: 0),
          child: _isPlacing
              ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5))
              : Text('Tasdiqlash — ${formatPrice(widget.total)}', style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700)),
        ),
      ),
    );
  }
}
