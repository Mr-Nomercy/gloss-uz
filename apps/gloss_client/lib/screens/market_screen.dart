import 'dart:async';
import 'package:flutter/material.dart';
import 'package:ui_kit/ui_kit.dart';
import 'cart_screen.dart';
import 'product_detail_screen.dart';

class MarketScreen extends StatefulWidget {
  final String title;
  const MarketScreen({super.key, this.title = 'Market'});

  @override
  State<MarketScreen> createState() => _MarketScreenState();
}

class _MarketScreenState extends State<MarketScreen> {
  final _searchController = TextEditingController();
  int _currentBanner = 0;
  int _selectedCategory = 0;
  int _selectedFilter = 0;
  String _searchQuery = '';
  Timer? _countdownTimer;
  Duration _flashSaleRemaining = const Duration(hours: 2, minutes: 15, seconds: 30);
  final Set<String> _favorites = {};
  final Map<String, int> _cart = {};

  static const _banners = [
    (title: 'Yangi mavsum', subtitle: 'Barcha tozalash vositalari', discount: '30% OFF', color1: GlossColors.green, color2: GlossColors.greenDarkVariant),
    (title: 'Premium sifat', subtitle: 'Professional tozalash', discount: '2+1 Bepul', color1: GlossColors.text, color2: GlossColors.grayDark),
    (title: 'Bahorgi tozalash', subtitle: 'Uyingizni yangilang', discount: '25% OFF', color1: GlossColors.greenDarkVariant, color2: GlossColors.green),
  ];

  static const _categories = [
    (name: 'Hammasi', icon: Icons.grid_view_rounded, color: GlossColors.green),
    (name: 'Tozalash', icon: Icons.cleaning_services_rounded, color: GlossColors.catBlue),
    (name: 'Kir yuvish', icon: Icons.local_laundry_service_rounded, color: GlossColors.catOrange),
    (name: 'Shisha', icon: Icons.window_rounded, color: GlossColors.catPurple),
    (name: 'Mebel', icon: Icons.chair_rounded, color: GlossColors.catBrown),
  ];

  static const _allProducts = [
    {'id': 'p1', 'name': 'Universal tozalash vositasi', 'price': 25000, 'oldPrice': 35000, 'rating': 4.5, 'reviews': 120, 'tags': ['yangi']},
    {'id': 'p2', 'name': 'Oyna tozalagich', 'price': 18000, 'oldPrice': null, 'rating': 4.2, 'reviews': 85, 'tags': []},
    {'id': 'p3', 'name': 'Mebel parisi', 'price': 32000, 'oldPrice': 42000, 'rating': 4.8, 'reviews': 200, 'tags': []},
    {'id': 'p4', 'name': 'Gilam yuvish shampuni', 'price': 45000, 'oldPrice': null, 'rating': 4.6, 'reviews': 150, 'tags': ['yangi']},
  ];

  List<Map<String, dynamic>> get _filteredProducts {
    var products = List<Map<String, dynamic>>.from(_allProducts);
    if (_selectedCategory > 0) {
      // simplified - just filter by first letter or something
    }
    if (_searchQuery.isNotEmpty) {
      products = products.where((p) => (p['name'] as String).toLowerCase().contains(_searchQuery.toLowerCase())).toList();
    }
    return products;
  }

  List<Map<String, dynamic>> get _flashSaleProducts =>
      _allProducts.where((p) => p['oldPrice'] != null).toList();

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _countdownTimer?.cancel();
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_flashSaleRemaining.inSeconds > 0) {
        setState(() => _flashSaleRemaining -= const Duration(seconds: 1));
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _countdownTimer?.cancel();
    super.dispose();
  }

  String get _countdownText {
    final h = _flashSaleRemaining.inHours.toString().padLeft(2, '0');
    final m = (_flashSaleRemaining.inMinutes % 60).toString().padLeft(2, '0');
    final s = (_flashSaleRemaining.inSeconds % 60).toString().padLeft(2, '0');
    return '$h:$m:$s';
  }

  String formatPrice(double price) {
    final whole = price.toInt();
    final buf = StringBuffer();
    final str = whole.toString();
    for (int i = 0; i < str.length; i++) {
      if (i > 0 && (str.length - i) % 3 == 0) buf.write(' ');
      buf.write(str[i]);
    }
    return "$buf so'm";
  }

  int cartTotalQuantity() => _cart.values.fold(0, (a, b) => a + b);
  bool inCart(String id) => _cart.containsKey(id);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GlossColors.bg,
      body: RefreshIndicator(
        onRefresh: () async {},
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverAppBar(
              floating: true, snap: true, elevation: 0,
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
              title: Text(widget.title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: GlossColors.text)),
              actions: [
                IconButton(
                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CartScreen())),
                  icon: Stack(
                    children: [
                      const Icon(Icons.shopping_cart_outlined, color: GlossColors.text, size: 24),
                      if (cartTotalQuantity() > 0)
                        Positioned(
                          right: 0, top: 0,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(color: GlossColors.green, shape: BoxShape.circle),
                            child: Text('${cartTotalQuantity()}', style: const TextStyle(fontSize: 10, color: GlossColors.card)),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(width: 4),
              ],
            ),
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSearchBar(),
                  _buildBannerCarousel(),
                  _buildCategoriesSection(),
                  _buildFlashSaleSection(),
                  _buildAllProductsSection(),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: GlossColors.card,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.black.withAlpha(8), blurRadius: 10, offset: const Offset(0, 2))],
        ),
        child: TextField(
          controller: _searchController,
          style: const TextStyle(fontSize: 15, color: GlossColors.text),
          onChanged: (v) => setState(() => _searchQuery = v),
          decoration: InputDecoration(
            hintText: 'Mahsulot qidirish...',
            hintStyle: const TextStyle(color: GlossColors.disabled, fontSize: 15),
            prefixIcon: const Icon(Icons.search_rounded, color: GlossColors.disabled, size: 24),
            suffixIcon: _searchQuery.isNotEmpty
                ? IconButton(
                    onPressed: () { _searchController.clear(); setState(() => _searchQuery = ''); },
                    icon: const Icon(Icons.close_rounded, color: GlossColors.disabled, size: 22),
                  )
                : null,
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
        ),
      ),
    );
  }

  Widget _buildBannerCarousel() {
    return Column(
      children: [
        SizedBox(
          height: 170,
          child: PageView.builder(
            itemCount: _banners.length,
            onPageChanged: (i) => setState(() => _currentBanner = i),
            itemBuilder: (context, i) {
              final b = _banners[i];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [b.color1, b.color2], begin: Alignment.topLeft, end: Alignment.bottomRight),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        right: -20, top: -20,
                        child: Container(width: 120, height: 120, decoration: BoxDecoration(color: Colors.white.withAlpha(15), shape: BoxShape.circle)),
                      ),
                      Positioned(
                        right: 10, bottom: -30,
                        child: Container(width: 100, height: 100, decoration: BoxDecoration(color: Colors.white.withAlpha(10), shape: BoxShape.circle)),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(color: Colors.white.withAlpha(30), borderRadius: BorderRadius.circular(8)),
                              child: Text(b.discount, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: Colors.white)),
                            ),
                            const SizedBox(height: 10),
                            Text(b.title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: Colors.white, height: 1.2)),
                            const SizedBox(height: 4),
                            Text(b.subtitle, style: TextStyle(fontSize: 14, color: Colors.white.withAlpha(180))),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(_banners.length, (i) {
            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 3),
              width: i == _currentBanner ? 24 : 8, height: 8,
              decoration: BoxDecoration(
                color: i == _currentBanner ? GlossColors.green : GlossColors.border,
                borderRadius: BorderRadius.circular(4),
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildCategoriesSection() {
    return Padding(
      padding: const EdgeInsets.only(top: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Kategoriyalar', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: GlossColors.text)),
                TextButton(
                  onPressed: () => setState(() => _selectedCategory = 0),
                  child: const Text('Barchasi', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: GlossColors.green)),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 100,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _categories.length,
              separatorBuilder: (ctx, i) => const SizedBox(width: 12),
              itemBuilder: (context, i) {
                final c = _categories[i];
                final selected = i == _selectedCategory;
                return GestureDetector(
                  onTap: () => setState(() => _selectedCategory = i),
                  child: SizedBox(
                    width: 72,
                    child: Column(
                      children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          width: 60, height: 60,
                          decoration: BoxDecoration(
                            color: selected ? c.color : c.color.withAlpha(20),
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(color: selected ? c.color : Colors.transparent, width: 2),
                          ),
                          child: Icon(c.icon, color: selected ? Colors.white : c.color, size: 28),
                        ),
                        const SizedBox(height: 8),
                        Text(c.name, style: TextStyle(fontSize: 12, fontWeight: selected ? FontWeight.w700 : FontWeight.w500, color: selected ? GlossColors.text : GlossColors.hint), textAlign: TextAlign.center, maxLines: 1, overflow: TextOverflow.ellipsis),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFlashSaleSection() {
    return Padding(
      padding: const EdgeInsets.only(top: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Wrap(
              alignment: WrapAlignment.spaceBetween,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(color: GlossColors.accentOrange, borderRadius: BorderRadius.circular(8)),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.flash_on_rounded, color: Colors.white, size: 18),
                      SizedBox(width: 4),
                      Text('Tezkor sotuv', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: Colors.white)),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(color: GlossColors.red.withAlpha(20), borderRadius: BorderRadius.circular(8)),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.access_time_rounded, color: GlossColors.red, size: 16),
                      const SizedBox(width: 4),
                      Text(_countdownText, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: GlossColors.red)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          SizedBox(
            height: 200,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _flashSaleProducts.length,
              separatorBuilder: (ctx, i) => const SizedBox(width: 12),
              itemBuilder: (context, i) => _buildFlashSaleCard(_flashSaleProducts[i]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFlashSaleCard(Map<String, dynamic> p) {
    final isFav = _favorites.contains(p['id']);
    final discount = p['oldPrice'] != null ? ((1 - (p['price'] as int) / (p['oldPrice'] as int)) * 100).round() : 0;
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ProductDetailScreen(product: p))),
      child: Container(
        width: 140,
        decoration: BoxDecoration(color: GlossColors.card, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withAlpha(8), blurRadius: 8, offset: const Offset(0, 2))]),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                  height: 90, width: double.infinity,
                  decoration: const BoxDecoration(color: Color(0xFFF0FFF4), borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
                  child: const Icon(Icons.cleaning_services_rounded, color: GlossColors.green, size: 36),
                ),
                if (discount > 0)
                  Positioned(top: 6, left: 6,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                      decoration: BoxDecoration(color: GlossColors.red, borderRadius: BorderRadius.circular(6)),
                      child: Text('-$discount%', style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: Colors.white)),
                    ),
                  ),
                Positioned(top: 6, right: 6,
                  child: GestureDetector(
                    onTap: () { setState(() { if (isFav) _favorites.remove(p['id']); else _favorites.add(p['id'] as String); }); },
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(color: GlossColors.card, borderRadius: BorderRadius.circular(6), boxShadow: [BoxShadow(color: Colors.black.withAlpha(15), blurRadius: 4)]),
                      child: Icon(isFav ? Icons.favorite_rounded : Icons.favorite_border_rounded, color: isFav ? GlossColors.red : GlossColors.disabled, size: 14),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(p['name'] as String, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: GlossColors.text), maxLines: 1, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.star_rounded, color: GlossColors.star, size: 14),
                      const SizedBox(width: 2),
                      Text('${p['rating']}', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
                      const SizedBox(width: 4),
                      Text('(${p['reviews']})', style: TextStyle(fontSize: 10, color: Colors.grey[400])),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (p['oldPrice'] != null)
                        Text(formatPrice((p['oldPrice'] as int).toDouble()), style: TextStyle(fontSize: 10, color: Colors.grey[400], decoration: TextDecoration.lineThrough)),
                      Text(formatPrice((p['price'] as int).toDouble()), style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: GlossColors.red)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAllProductsSection() {
    final filtered = _filteredProducts;
    return Padding(
      padding: const EdgeInsets.only(top: 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Barcha mahsulotlar (${filtered.length})', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: GlossColors.text)),
                const SizedBox(height: 10),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildFilterChip('Hammasi', 0),
                      const SizedBox(width: 8),
                      _buildFilterChip('Arzon', 1),
                      const SizedBox(width: 8),
                      _buildFilterChip('Qimmat', 2),
                      const SizedBox(width: 8),
                      _buildFilterChip('Yangi', 3),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          if (filtered.isEmpty)
            Padding(
              padding: const EdgeInsets.all(32),
              child: Center(
                child: Column(
                  children: [
                    Icon(Icons.search_off_rounded, size: 48, color: Colors.grey[300]),
                    const SizedBox(height: 12),
                    Text('Mahsulot topilmadi', style: TextStyle(fontSize: 16, color: Colors.grey[500])),
                  ],
                ),
              ),
            )
          else
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, mainAxisSpacing: 12, crossAxisSpacing: 12, childAspectRatio: 0.68),
              itemCount: filtered.length,
              itemBuilder: (context, i) => _buildProductGridCard(filtered[i]),
            ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, int index) {
    final selected = _selectedFilter == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedFilter = index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: selected ? GlossColors.green : GlossColors.card,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: selected ? GlossColors.green : GlossColors.border),
        ),
        child: Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: selected ? Colors.white : GlossColors.hint)),
      ),
    );
  }

  Widget _buildProductGridCard(Map<String, dynamic> p) {
    final inC = inCart(p['id'] as String);
    final isFav = _favorites.contains(p['id']);
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ProductDetailScreen(product: p))),
      child: Container(
        decoration: BoxDecoration(color: GlossColors.card, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withAlpha(8), blurRadius: 8, offset: const Offset(0, 2))]),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 5,
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(color: Color(0xFFF0FFF4), borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
                    child: const Icon(Icons.cleaning_services_rounded, color: GlossColors.green, size: 40),
                  ),
                  Positioned(
                    top: 6, right: 6,
                    child: GestureDetector(
                      onTap: () { setState(() { if (isFav) _favorites.remove(p['id']); else _favorites.add(p['id'] as String); }); },
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(color: GlossColors.card, borderRadius: BorderRadius.circular(6), boxShadow: [BoxShadow(color: Colors.black.withAlpha(15), blurRadius: 4)]),
                        child: Icon(isFav ? Icons.favorite_rounded : Icons.favorite_border_rounded, color: isFav ? GlossColors.red : GlossColors.disabled, size: 14),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 5,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(p['name'] as String, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: GlossColors.text, height: 1.2), maxLines: 2, overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.star_rounded, color: GlossColors.star, size: 14),
                        const SizedBox(width: 2),
                        Text('${p['rating']}', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
                        const SizedBox(width: 4),
                        Text('(${p['reviews']})', style: TextStyle(fontSize: 10, color: Colors.grey[400])),
                      ],
                    ),
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(formatPrice((p['price'] as int).toDouble()), style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: GlossColors.green)),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              if (inC) _cart.remove(p['id']);
                              else _cart[p['id'] as String] = 1;
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(color: inC ? GlossColors.green.withAlpha(30) : GlossColors.green, borderRadius: BorderRadius.circular(7)),
                            child: Icon(inC ? Icons.check_rounded : Icons.add_rounded, color: inC ? GlossColors.green : Colors.white, size: 16),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
