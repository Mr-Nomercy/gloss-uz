import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ui_kit/ui_kit.dart';
import '../providers/market_provider.dart';

class MarketScreen extends StatefulWidget {
  const MarketScreen({super.key});

  @override
  State<MarketScreen> createState() => _MarketScreenState();
}

class _MarketScreenState extends State<MarketScreen> {
  final _searchController = TextEditingController();
  String? _activeCategoryFilter;

  static final _mockProducts = [
    const MarketProduct(
      id: '1', name: 'Universal tozalash vositasi', price: 25000,
      salePrice: 19900, stockQty: 150, categoryName: 'Tozalash vositalari',
      rating: 4.7, isActive: true,
    ),
    const MarketProduct(
      id: '2', name: 'Mikrofibra mato to\'plami (3 dona)', price: 35000,
      stockQty: 80, categoryName: 'Tozalash anjomlari',
      rating: 4.5, isActive: true,
    ),
    const MarketProduct(
      id: '3', name: 'Changyutgich uchun filtr', price: 45000,
      stockQty: 0, categoryName: 'Ehtiyot qismlar',
      rating: 4.2, isActive: true,
    ),
    const MarketProduct(
      id: '4', name: 'Shisha tozalash spreyi', price: 18000,
      stockQty: 200, categoryName: 'Tozalash vositalari',
      rating: 4.8, isActive: false,
    ),
    const MarketProduct(
      id: '5', name: 'Pol tozalash mochalkasi', price: 55000,
      salePrice: 45000, stockQty: 45, categoryName: 'Tozalash anjomlari',
      rating: 4.3, isActive: true,
    ),
  ];

  static final _mockCategories = [
    const MarketCategory(id: 'c1', name: 'Tozalash vositalari'),
    const MarketCategory(id: 'c2', name: 'Tozalash anjomlari'),
    const MarketCategory(id: 'c3', name: 'Ehtiyot qismlar'),
    const MarketCategory(id: 'c4', name: 'Aksessuarlar'),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.gloss;

    return Scaffold(
      backgroundColor: theme.bg,
      appBar: const GlossAppBar(title: 'Market'),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/market/product/add'),
        backgroundColor: context.gloss.green,
        icon: const Icon(Icons.add_rounded, color: Colors.white),
        label: const Text(
          'Mahsulot',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: GlossTextField(
              controller: _searchController,
              hint: 'Mahsulot qidirish...',
              prefixIcon: Icon(Icons.search_rounded, color: theme.hint, size: 20),
            ),
          ),
          SizedBox(
            height: 44,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _catChip('Barchasi', null, theme),
                ..._mockCategories.map((c) => _catChip(c.name, c.id, theme)),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 80),
              itemCount: _filteredProducts.length,
              itemBuilder: (_, i) {
                final product = _filteredProducts[i];
                return _buildProductCard(theme, product);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _catChip(String label, String? id, GlossTheme theme) {
    final isSelected = id == null
        ? _activeCategoryFilter == null
        : _activeCategoryFilter == id;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label, style: const TextStyle(fontSize: 12)),
        selected: isSelected,
        onSelected: (_) {
          setState(() {
            _activeCategoryFilter = id;
          });
        },
        selectedColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.08),
        checkmarkColor: theme.green,
        backgroundColor: Colors.white,
        labelStyle: TextStyle(
          color: isSelected ? theme.green : theme.hint,
          fontWeight: FontWeight.w600,
        ),
        side: BorderSide(color: isSelected ? theme.green : theme.border),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  List<MarketProduct> get _filteredProducts {
    if (_activeCategoryFilter == null) return _mockProducts;
    final catName = _mockCategories
        .firstWhere((c) => c.id == _activeCategoryFilter)
        .name;
    return _mockProducts
        .where((p) => p.categoryName == catName)
        .toList();
  }

  Widget _buildProductCard(GlossTheme theme, MarketProduct product) {
    final hasDiscount = product.salePrice != null;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: GlossCard(
        accentColor: theme.orange,
        padding: const EdgeInsets.all(12),
        onTap: () => context.push('/market/product/${product.id}'),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: theme.grayLight,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                Icons.inventory_2_outlined,
                size: 28,
                color: theme.hint,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: GlossColors.text,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        hasDiscount
                            ? formatPrice(product.salePrice!.toInt())
                            : formatPrice(product.price.toInt()),
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: theme.green,
                        ),
                      ),
                      if (hasDiscount) ...[
                        const SizedBox(width: 6),
                        Text(
                          formatPrice(product.price.toInt()),
                          style: TextStyle(
                            fontSize: 12,
                            color: theme.hint,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (product.stockQty == 0)
                  GlossBadge(
                    label: 'Tugagan',
                    variant: BadgeVariant.error,
                    fontSize: 10,
                  )
                else if (!product.isActive)
                  GlossBadge(
                    label: 'Nofaol',
                    variant: BadgeVariant.neutral,
                    fontSize: 10,
                  ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.star_rounded, size: 12, color: theme.star),
                    const SizedBox(width: 2),
                    Text(
                      product.rating.toString(),
                      style: TextStyle(
                        fontSize: 12,
                        color: theme.hint,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
