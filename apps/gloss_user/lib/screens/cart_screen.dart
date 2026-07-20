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
    if (code.isEmpty) {
      setState(() => _promoError = 'Promo kodni kiriting');
      return;
    }
    setState(() {
      _appliedPromo = code;
      _promoError = null;
    });
    GlossSnackBar.showSuccess(context, '$code qo\'llanildi: 10% chegirma');
  }

  void _removePromo() {
    setState(() {
      _appliedPromo = null;
      _promoController.clear();
      _promoError = null;
    });
  }

  int get _subtotal => _cartItems.fold(0, (sum, item) => sum + (item['price'] as int) * (item['quantity'] as int));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.gloss.bg,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: context.gloss.bg,
        centerTitle: true,
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
        title: Text('Savat', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: context.gloss.text)),
      ),
      body: _cartItems.isEmpty ? _buildEmptyCart(context) : Column(
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

  Widget _buildEmptyCart(BuildContext context) {
    return Center(
      child: GlossEmptyState.cart(
        onAction: () => Navigator.pop(context),
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
      child: GlossCard(
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: context.gloss.greenBgLight,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(Icons.cleaning_services_rounded, color: context.gloss.green, size: 26),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(item['name'] as String, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: context.gloss.text), maxLines: 1, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 4),
                  Text(formatPrice((item['price'] as int).toDouble()), style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: context.gloss.green)),
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(color: context.gloss.bg, borderRadius: BorderRadius.circular(10)),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        if (item['quantity'] > 1) {
                          item['quantity'] = (item['quantity'] as int) - 1;
                        } else {
                          _cartItems.removeWhere((i) => i['id'] == item['id']);
                        }
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Icon(Icons.remove_rounded, size: 16, color: (item['quantity'] as int) > 1 ? GlossColors.text : context.gloss.disabled),
                    ),
                  ),
                  Text('${item['quantity']}', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: context.gloss.text)),
                  GestureDetector(
                    onTap: () => setState(() => item['quantity'] = (item['quantity'] as int) + 1),
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Icon(Icons.add_rounded, size: 16, color: context.gloss.green),
                    ),
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
    return GlossCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Promo kod', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: context.gloss.text)),
          const SizedBox(height: 8),
          if (_appliedPromo != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: GlossColors.green.withValues(alpha: 0.06),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: GlossColors.green.withValues(alpha: 0.20)),
              ),
              child: Row(
                children: [
                  Icon(Icons.local_offer_rounded, color: context.gloss.green, size: 18),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(_appliedPromo!, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: context.gloss.green)),
                  ),
                  GestureDetector(onTap: _removePromo, child: Icon(Icons.close_rounded, color: context.gloss.red, size: 20)),
                ],
              ),
            )
          else
            Row(
              children: [
                Expanded(
                  child: GlossTextField(
                    hint: 'Promo kod kiriting',
                    controller: _promoController,
                    errorText: _promoError,
                    textCapitalization: TextCapitalization.characters,
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
        color: context.gloss.card,
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 10, offset: const Offset(0, -2))],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _priceRow('Jami (${_cartItems.length} ta)', formatPrice(subtotal.toDouble())),
          if (discount > 0) _priceRow('Chegirma', '-${formatPrice(discount.toDouble())}', color: GlossColors.red),
          _priceRow('Yetkazish', delivery == 0 ? 'Bepul' : formatPrice(delivery.toDouble()), color: delivery == 0 ? GlossColors.green : null),
          Divider(height: 20, color: context.gloss.divider),
          _priceRow("To'lash", formatPrice(total.toDouble()), bold: true),
          const SizedBox(height: 14),
          GlossButton(
            label: "To'lovga o'tish",
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