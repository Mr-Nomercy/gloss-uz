import 'package:flutter/material.dart';
import 'package:ui_kit/ui_kit.dart';

class ProductDetailScreen extends StatefulWidget {
  final Map<String, dynamic>? product;
  final String? productId;

  const ProductDetailScreen({super.key, this.product, this.productId});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int _quantity = 1;
  bool _showAllReviews = false;
  bool _isFav = false;

  Map<String, dynamic> get _product => widget.product ?? {
    'id': 'unknown',
    'name': 'Mahsulot',
    'price': 0,
    'oldPrice': null,
    'rating': 0.0,
    'reviews': 0,
    'tags': <String>[],
  };

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

  int get _discountPercent {
    final old = _product['oldPrice'];
    if (old == null || (old as int) <= 0) return 0;
    return ((1 - (_product['price'] as int) / old) * 100).round();
  }

  final _reviews = [
    {'name': 'Aziz K.', 'rating': 5.0, 'text': "Juda sifatli mahsulot! Tozalash juda oson bo'ldi.", 'date': '2 kun oldin'},
    {'name': 'Sardor M.', 'rating': 4.0, 'text': 'Yaxshi mahsulot, lekin qadoqlash yaxshiroq bo\'lishi mumkin.', 'date': '5 kun oldin'},
    {'name': 'Nilufar R.', 'rating': 5.0, 'text': "Tavsiya qilaman! O'z oilamga ham oldim.", 'date': '1 hafta oldin'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GlossColors.bg,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            floating: true, snap: true, elevation: 0,
            backgroundColor: GlossColors.bg,
            leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: GlossColors.card, borderRadius: BorderRadius.circular(12), boxShadow: [BoxShadow(color: Colors.black.withAlpha(10), blurRadius: 4)]),
                child: const Icon(Icons.arrow_back_ios_new_rounded, color: GlossColors.text, size: 18),
              ),
            ),
            actions: [
              GestureDetector(
                onTap: () => setState(() => _isFav = !_isFav),
                child: Container(
                  margin: const EdgeInsets.only(right: 8),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(color: GlossColors.card, borderRadius: BorderRadius.circular(12), boxShadow: [BoxShadow(color: Colors.black.withAlpha(10), blurRadius: 4)]),
                  child: Icon(_isFav ? Icons.favorite_rounded : Icons.favorite_border_rounded, color: _isFav ? GlossColors.red : GlossColors.text, size: 18),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(right: 8),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: GlossColors.card, borderRadius: BorderRadius.circular(12), boxShadow: [BoxShadow(color: Colors.black.withAlpha(10), blurRadius: 4)]),
                child: const Icon(Icons.shopping_cart_outlined, color: GlossColors.text, size: 18),
              ),
              const SizedBox(width: 8),
            ],
          ),
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildProductImage(),
                _buildProductInfo(),
                _buildDescription(),
                _buildReviewsSection(),
                const SizedBox(height: 100),
              ],
            ),
          ),
        ],
      ),
      bottomSheet: _buildBottomBar(),
    );
  }

  Widget _buildProductImage() {
    return Container(
      height: 300,
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 0),
      decoration: BoxDecoration(color: GlossColors.greenBgLight, borderRadius: BorderRadius.circular(24)),
      child: Stack(
        children: [
          const Center(child: Icon(Icons.cleaning_services_rounded, color: GlossColors.green, size: 100)),
          if ((_product['tags'] as List).contains('premium'))
            Positioned(
              top: 16, right: 16,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(color: GlossColors.green, borderRadius: BorderRadius.circular(8)),
                child: const Text('Premium', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: Colors.white)),
              ),
            ),
          if (_discountPercent > 0)
            Positioned(
              top: 16, left: 16,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(color: GlossColors.red, borderRadius: BorderRadius.circular(8)),
                child: Text('-$_discountPercent%', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: Colors.white)),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildProductInfo() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(_product['name'] as String, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: GlossColors.text, height: 1.2)),
          const SizedBox(height: 8),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(color: GlossColors.green.withAlpha(20), borderRadius: BorderRadius.circular(8)),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.star_rounded, color: GlossColors.star, size: 16),
                    const SizedBox(width: 4),
                    Text('${_product['rating'] ?? 0}', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: GlossColors.green)),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Text('${_product['reviews']} ta sharh', style: TextStyle(fontSize: 14, color: Colors.grey[500])),
            ],
          ),
          const SizedBox(height: 16),
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.end,
            spacing: 8,
            children: [
              Text(formatPrice((_product['price'] as int).toDouble()), style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: GlossColors.green)),
              if (_product['oldPrice'] != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 3),
                  child: Text(formatPrice((_product['oldPrice'] as int).toDouble()), style: TextStyle(fontSize: 16, color: Colors.grey[400], decoration: TextDecoration.lineThrough)),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDescription() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Tavsif', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: GlossColors.text)),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: GlossColors.card, borderRadius: BorderRadius.circular(16)),
            child: const Text(
              'Professional tozalash vositasi. Barcha turdagi sirtlarni chuqur tozalash uchun maxsus ishlab chiqilgan. Ekologik toza tarkibiy qismalar. Bolalar va uy hayvonlari uchun xavfsiz.',
              style: TextStyle(fontSize: 14, color: GlossColors.hint, height: 1.6),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewsSection() {
    final reviews = _showAllReviews ? _reviews : _reviews.take(3).toList();
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Sharhlar (${_reviews.length})', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: GlossColors.text)),
              if (_reviews.length > 3)
                TextButton(
                  onPressed: () => setState(() => _showAllReviews = !_showAllReviews),
                  child: Text(_showAllReviews ? 'Kamroq' : 'Barchasi', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: GlossColors.green)),
                ),
            ],
          ),
          ...reviews.map((r) => _buildReviewCard(r)),
        ],
      ),
    );
  }

  Widget _buildReviewCard(Map<String, dynamic> r) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: GlossColors.card, borderRadius: BorderRadius.circular(14)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: GlossColors.green.withAlpha(20),
                child: Text((r['name'] as String)[0], style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: GlossColors.green)),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(r['name'] as String, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: GlossColors.text)),
                    Row(
                      children: List.generate(5, (i) => Icon(i < (r['rating'] as double) ? Icons.star_rounded : Icons.star_border_rounded, color: GlossColors.star, size: 14)),
                    ),
                  ],
                ),
              ),
              Text(r['date'] as String, style: TextStyle(fontSize: 11, color: Colors.grey[400])),
            ],
          ),
          const SizedBox(height: 10),
          Text(r['text'] as String, style: const TextStyle(fontSize: 13, color: GlossColors.hint, height: 1.5)),
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
    final totalPrice = (_product['price'] as int) * _quantity;
    return Container(
      padding: EdgeInsets.fromLTRB(16, 12, 16, MediaQuery.of(context).padding.bottom + 12),
      decoration: BoxDecoration(
        color: GlossColors.card,
        boxShadow: [BoxShadow(color: Colors.black.withAlpha(10), blurRadius: 10, offset: const Offset(0, -2))],
      ),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(color: GlossColors.bg, borderRadius: BorderRadius.circular(12)),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTap: () { if (_quantity > 1) setState(() => _quantity--); },
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Icon(Icons.remove_rounded, size: 20, color: _quantity > 1 ? GlossColors.text : Colors.grey[300]),
                  ),
                ),
                Text('$_quantity', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: GlossColors.text)),
                GestureDetector(
                  onTap: () => setState(() => _quantity++),
                  child: Padding(padding: const EdgeInsets.all(8), child: Icon(Icons.add_rounded, size: 20, color: GlossColors.green)),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: SizedBox(
              height: 48,
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${_product['name']} x$_quantity savatga qo\'shildi'),
                      backgroundColor: GlossColors.green,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: GlossColors.green,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  elevation: 0,
                ),
                child: Text(
                  'Savatga qo\'shish ($totalPrice so\'m)',
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
