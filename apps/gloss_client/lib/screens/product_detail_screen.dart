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
      backgroundColor: context.gloss.bg,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            floating: true,
            snap: true,
            elevation: 0,
            backgroundColor: context.gloss.bg,
            leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: context.gloss.card,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 4)],
                ),
                child: Icon(Icons.arrow_back_ios_new_rounded, color: context.gloss.text, size: 18),
              ),
            ),
            actions: [
              GestureDetector(
                onTap: () => setState(() => _isFav = !_isFav),
                child: Container(
                  margin: const EdgeInsets.only(right: 8),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: context.gloss.card,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 4)],
                  ),
                  child: Icon(_isFav ? Icons.favorite_rounded : Icons.favorite_border_rounded, color: _isFav ? context.gloss.red : context.gloss.text, size: 18),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(right: 8),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: context.gloss.card,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 4)],
                ),
                child: Icon(Icons.shopping_cart_outlined, color: context.gloss.text, size: 18),
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
      decoration: BoxDecoration(
        color: context.gloss.greenBgLight,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Stack(
        children: [
          Center(child: Icon(Icons.cleaning_services_rounded, color: context.gloss.green, size: 100)),
          if ((_product['tags'] as List).contains('premium'))
            const Positioned(
              top: 16,
              right: 16,
              child: GlossBadge(label: 'Premium'),
            ),
          if (_discountPercent > 0)
            Positioned(
              top: 16,
              left: 16,
              child: GlossBadge(
                label: '-$_discountPercent%',
                variant: BadgeVariant.error,
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
          Text(_product['name'] as String, style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: context.gloss.text, height: 1.2)),
          const SizedBox(height: 8),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: GlossColors.green.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.star_rounded, color: GlossColors.star, size: 16),
                    const SizedBox(width: 4),
                    Text('${_product['rating'] ?? 0}', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: context.gloss.green)),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Text('${_product['reviews']} ta sharh', style: TextStyle(fontSize: 14, color: context.gloss.hint)),
            ],
          ),
          const SizedBox(height: 16),
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.end,
            spacing: 8,
            children: [
              Text(formatPrice((_product['price'] as int).toDouble()), style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: context.gloss.green)),
              if (_product['oldPrice'] != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 3),
                  child: Text(
                    formatPrice((_product['oldPrice'] as int).toDouble()),
                    style: TextStyle(fontSize: 16, color: context.gloss.disabled, decoration: TextDecoration.lineThrough),
                  ),
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
          Text('Tavsif', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: context.gloss.text)),
          const SizedBox(height: 12),
          const GlossCard(
            child: Text(
              'Professional tozalash vositasi. Barcha turdagi sirtlarni chuqur tozalash uchun maxsus ishlab chiqilgan. Ekologik toza tarkibiy qismalar. Bolalar va uy hayvonlari uchun xavfsiz.',
              style: TextStyle(fontSize: 14, height: 1.6),
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
              Text('Sharhlar (${_reviews.length})', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: context.gloss.text)),
              if (_reviews.length > 3)
                TextButton(
                  onPressed: () => setState(() => _showAllReviews = !_showAllReviews),
                  child: Text(_showAllReviews ? 'Kamroq' : 'Barchasi', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: context.gloss.green)),
                ),
            ],
          ),
          ...reviews.map((r) => _buildReviewCard(r)),
        ],
      ),
    );
  }

  Widget _buildReviewCard(Map<String, dynamic> r) {
    return GlossCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: GlossColors.green.withValues(alpha: 0.08),
                child: Text((r['name'] as String)[0], style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: context.gloss.green)),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(r['name'] as String, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: context.gloss.text)),
                    Row(
                      children: List.generate(5, (i) => Icon(i < (r['rating'] as double) ? Icons.star_rounded : Icons.star_border_rounded, color: GlossColors.star, size: 14)),
                    ),
                  ],
                ),
              ),
              Text(r['date'] as String, style: TextStyle(fontSize: 11, color: context.gloss.disabled)),
            ],
          ),
          const SizedBox(height: 10),
          Text(r['text'] as String, style: TextStyle(fontSize: 13, color: context.gloss.hint, height: 1.5)),
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
    final totalPrice = (_product['price'] as int) * _quantity;
    return Container(
      padding: EdgeInsets.fromLTRB(16, 12, 16, MediaQuery.of(context).padding.bottom + 12),
      decoration: BoxDecoration(
        color: context.gloss.card,
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 10, offset: const Offset(0, -2))],
      ),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(color: context.gloss.bg, borderRadius: BorderRadius.circular(12)),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTap: () {
                    if (_quantity > 1) setState(() => _quantity--);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Icon(Icons.remove_rounded, size: 20, color: _quantity > 1 ? context.gloss.text : context.gloss.disabled),
                  ),
                ),
                Text('$_quantity', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: context.gloss.text)),
                GestureDetector(
                  onTap: () => setState(() => _quantity++),
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Icon(Icons.add_rounded, size: 20, color: context.gloss.green),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: SizedBox(
              height: 48,
              child: GlossButton(
                label: 'Savatga qo\'shish ($totalPrice so\'m)',
                onPressed: () {
                  GlossSnackBar.showSuccess(context, '${_product['name']} x$_quantity savatga qo\'shildi');
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}