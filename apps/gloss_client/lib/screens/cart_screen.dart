import 'package:flutter/material.dart';
import 'package:ui_kit/ui_kit.dart';
import 'checkout_screen.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final _promoController = TextEditingController();
  String? _appliedPromo;
  String? _promoError;

  final _cartItems = <Map<String, dynamic>>[
    {'id': 'p1', 'name': 'Universal tozalash vositasi', 'price': 25000, 'quantity': 2},
    {'id': 'p3', 'name': 'Mebel parisi', 'price': 32000, 'quantity': 1},
  ];

  @override
  void dispose() {
    _promoController.dispose();
    super.dispose();
  }

  void _applyPromo() {
    final code = _promoController.text.trim().toUpperCase();
    if (code.isEmpty) { setState(() => _promoError = 'Promo kodni kiriting'); return; }
    setState(() { _appliedPromo = code; _promoError = null; });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$code qo\'llanildi: 10% chegirma'), backgroundColor: GlossColors.green, behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
    );
  }

  void _removePromo() { setState(() { _appliedPromo = null; _promoController.clear(); _promoError = null; }); }

  String formatPrice(int price) {
    final buf = StringBuffer();
    final s = price.toString();
    for (int i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) buf.write(' ');
      buf.write(s[i]);
    }
    return "$buf so'm";
  }

  int get _subtotal => _cartItems.fold(0, (sum, item) => sum + (item['price'] as int) * (item['quantity'] as int));

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
        title: const Text('Savat', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: GlossColors.text)),
      ),
      body: _cartItems.isEmpty ? _buildEmptyCart() : Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _cartItems.length,
              itemBuilder: (context, i) => _buildCartItem(_cartItems[i]),
            ),
          ),
          _buildPromoSection(),
          _buildCheckoutBar(),
        ],
      ),
    );
  }

  Widget _buildEmptyCart() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(color: GlossColors.green.withAlpha(20), shape: BoxShape.circle),
            child: const Icon(Icons.shopping_cart_outlined, size: 64, color: GlossColors.green),
          ),
          const SizedBox(height: 20),
          const Text("Savat bo'sh", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: GlossColors.text)),
          const SizedBox(height: 8),
          Text("Mahsulotlarni savatga qo'shing", style: TextStyle(fontSize: 14, color: Colors.grey[500])),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: GlossColors.green, foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
            ),
            child: const Text("Xaridni boshlash", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }

  Widget _buildCartItem(Map<String, dynamic> item) {
    return Dismissible(
      key: Key(item['id'] as String),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(color: GlossColors.red, borderRadius: BorderRadius.circular(16)),
        child: const Icon(Icons.delete_outline_rounded, color: Colors.white, size: 28),
      ),
      onDismissed: (_) => setState(() => _cartItems.removeWhere((i) => i['id'] == item['id'])),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(color: GlossColors.card, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withAlpha(8), blurRadius: 8, offset: const Offset(0, 2))]),
        child: Row(
          children: [
            Container(
              width: 60, height: 60,
              decoration: BoxDecoration(color: GlossColors.greenBgLight, borderRadius: BorderRadius.circular(14)),
              child: const Icon(Icons.cleaning_services_rounded, color: GlossColors.green, size: 26),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(item['name'] as String, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: GlossColors.text), maxLines: 1, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 4),
                  Text(formatPrice(item['price'] as int), style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: GlossColors.green)),
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(color: GlossColors.bg, borderRadius: BorderRadius.circular(10)),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        if (item['quantity'] > 1) item['quantity'] = (item['quantity'] as int) - 1;
                        else _cartItems.removeWhere((i) => i['id'] == item['id']);
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Icon(Icons.remove_rounded, size: 16, color: (item['quantity'] as int) > 1 ? GlossColors.text : Colors.grey[300]),
                    ),
                  ),
                  Text('${item['quantity']}', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: GlossColors.text)),
                  GestureDetector(
                    onTap: () => setState(() => item['quantity'] = (item['quantity'] as int) + 1),
                    child: Padding(padding: const EdgeInsets.all(8), child: Icon(Icons.add_rounded, size: 16, color: GlossColors.green)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPromoSection() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: GlossColors.card, borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Promo kod', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: GlossColors.text)),
          const SizedBox(height: 8),
          if (_appliedPromo != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(color: GlossColors.green.withAlpha(15), borderRadius: BorderRadius.circular(12), border: Border.all(color: GlossColors.green.withAlpha(50))),
              child: Row(
                children: [
                  const Icon(Icons.local_offer_rounded, color: GlossColors.green, size: 18),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(_appliedPromo!, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: GlossColors.green)),
                      ],
                    ),
                  ),
                  GestureDetector(onTap: _removePromo, child: Icon(Icons.close_rounded, color: GlossColors.red, size: 20)),
                ],
              ),
            )
          else
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _promoController,
                    style: const TextStyle(fontSize: 14, color: GlossColors.text),
                    textCapitalization: TextCapitalization.characters,
                    decoration: InputDecoration(
                      hintText: 'Promo kod kiriting',
                      hintStyle: TextStyle(fontSize: 14, color: Colors.grey[400]),
                      errorText: _promoError,
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey[300]!)),
                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey[300]!)),
                      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: GlossColors.green)),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: _applyPromo,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(color: GlossColors.green, borderRadius: BorderRadius.circular(12)),
                    child: const Text("Qo'llash", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white)),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildCheckoutBar() {
    final subtotal = _subtotal;
    final discount = _appliedPromo != null ? (subtotal * 0.1).round() : 0;
    final delivery = subtotal > 100000 ? 0 : 15000;
    final total = subtotal - discount + delivery;

    return Container(
      padding: EdgeInsets.fromLTRB(16, 16, 16, MediaQuery.of(context).padding.bottom + 16),
      decoration: BoxDecoration(
        color: GlossColors.card,
        boxShadow: [BoxShadow(color: Colors.black.withAlpha(10), blurRadius: 10, offset: const Offset(0, -2))],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _priceRow('Jami (${_cartItems.length} ta)', formatPrice(subtotal)),
          if (discount > 0) _priceRow('Chegirma', '-${formatPrice(discount)}', color: GlossColors.red),
          _priceRow('Yetkazish', delivery == 0 ? 'Bepul' : formatPrice(delivery), color: delivery == 0 ? GlossColors.green : null),
          const Divider(height: 20),
          _priceRow("To'lash", formatPrice(total), bold: true),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity, height: 50,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(
                  builder: (_) => CheckoutScreen(
                    subtotal: subtotal.toDouble(),
                    discount: discount.toDouble(),
                    delivery: delivery.toDouble(),
                    total: total.toDouble(),
                    promoCode: _appliedPromo,
                  ),
                ));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: GlossColors.green, foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)), elevation: 0,
              ),
              child: const Text("To'lovga o'tish", style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _priceRow(String label, String value, {Color? color, bool bold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(fontSize: 14, color: color ?? GlossColors.hint, fontWeight: bold ? FontWeight.w700 : FontWeight.w400)),
        Text(value, style: TextStyle(fontSize: 14, color: color ?? GlossColors.text, fontWeight: bold ? FontWeight.w700 : FontWeight.w600)),
      ],
    );
  }
}
