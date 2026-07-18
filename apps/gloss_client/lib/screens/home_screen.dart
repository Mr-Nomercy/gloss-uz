import 'package:flutter/material.dart';
import 'package:ui_kit/ui_kit.dart';
import 'booking_screen.dart';
import 'market_screen.dart';
import 'notifications_screen.dart';
import 'profile_screen.dart';
import 'address_search_screen.dart';
import 'xizmatlar_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const _banners = [
    ('Yangi mijozlar uchun', '30% OFF', GlossColors.green, GlossColors.darkGreen),
    ('Premium tozalash', 'Bepul tekshiruv', GlossColors.darkGreen, GlossColors.green),
    ('Bahorgi tozalash', '2+1 bepul', GlossColors.green, GlossColors.darkGreen),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.gloss.bg,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: context.gloss.bg,
        centerTitle: true,
        title: const Text(
          'Gloss',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: GlossColors.text, letterSpacing: -0.5),
        ),
        leading: IconButton(
          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const NotificationsScreen())),
          icon: const Icon(Icons.notifications_none_rounded, color: GlossColors.text),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: GestureDetector(
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfileScreen())),
              child: CircleAvatar(
                radius: 18,
                backgroundColor: context.gloss.green,
                child: Icon(Icons.person_rounded, color: context.gloss.card, size: 22),
              ),
            ),
          ),
        ],
      ),
      body: const SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.only(top: 16, bottom: 32),
          child: Column(
            children: [
              _TopSection(banners: _banners),
              SizedBox(height: 20),
              _BannerAndProductsBlock(banners: _banners),
            ],
          ),
        ),
      ),
    );
  }
}

class _TopSection extends StatelessWidget {
  final List<(String, String, Color, Color)> banners;
  const _TopSection({required this.banners});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: GlossCard(
        padding: const EdgeInsets.fromLTRB(12, 12, 12, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const _MainCategoryCards(),
            const SizedBox(height: 12),
            GestureDetector(
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const XizmatlarScreen())),
              child: Container(
                height: 46,
                decoration: BoxDecoration(
                  color: context.gloss.green,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    const SizedBox(width: 14),
                    Icon(Icons.list_alt_rounded, color: context.gloss.card, size: 22),
                    const SizedBox(width: 10),
                    Text('Barcha xizmatlar', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: context.gloss.card)),
                    const Spacer(),
                    Icon(Icons.arrow_forward_rounded, color: context.gloss.card, size: 22),
                    const SizedBox(width: 14),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            const _SearchPanel(),
          ],
        ),
      ),
    );
  }
}

class _MainCategoryCards extends StatelessWidget {
  const _MainCategoryCards();

  @override
  Widget build(BuildContext context) {
    const items = [
      (Icons.cleaning_services_rounded, 'Tozalash'),
      (Icons.local_laundry_service_rounded, 'Kir yuvish'),
      (Icons.home_repair_service_rounded, 'Ta\'mirlash'),
      (Icons.store_mall_directory_rounded, 'Market'),
    ];

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      childAspectRatio: 1.6,
      children: items.map((item) {
        final (icon, title) = item;
        final isMarket = title == 'Market';
        return Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(18),
          child: InkWell(
            borderRadius: BorderRadius.circular(18),
            onTap: () {
              if (isMarket) {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const MarketScreen()));
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => BookingScreen(serviceName: title, subcategoryName: title)),
                );
              }
            },
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: context.gloss.bg,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: context.gloss.green,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(icon, color: context.gloss.card, size: 24),
                  ),
                  Text(title, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: context.gloss.text)),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _SearchPanel extends StatelessWidget {
  const _SearchPanel();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push<AddressResult>(
          context,
          MaterialPageRoute(builder: (_) => const AddressSearchScreen()),
        );
      },
      child: Container(
        height: 46,
        decoration: BoxDecoration(
          color: context.gloss.bg,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            const SizedBox(width: 14),
            Icon(Icons.search_rounded, color: context.gloss.hint, size: 22),
            const SizedBox(width: 10),
            Text("Manzil bo'yicha qidirish...", style: TextStyle(fontSize: 15, color: context.gloss.hint)),
            const Spacer(),
            Icon(Icons.tune_rounded, color: context.gloss.hint, size: 22),
            const SizedBox(width: 14),
          ],
        ),
      ),
    );
  }
}

class _BannerAndProductsBlock extends StatelessWidget {
  final List<(String, String, Color, Color)> banners;
  const _BannerAndProductsBlock({required this.banners});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: SizedBox(
            height: 140,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: banners.length,
              separatorBuilder: (ctx, i) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                final (title, discount, c1, c2) = banners[index];
                return GestureDetector(
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const MarketScreen())),
                  child: Container(
                    width: 220,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [c1, c2], begin: Alignment.topLeft, end: Alignment.bottomRight),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(title, style: const TextStyle(color: Colors.white70, fontSize: 15, fontWeight: FontWeight.w500)),
                        Text(discount, style: const TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.w800, height: 1.1)),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: context.gloss.grayLight,
            borderRadius: BorderRadius.circular(24),
          ),
          child: GridView.builder(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 0.8,
            ),
            itemCount: 4,
            itemBuilder: (context, index) {
              final names = ['Universal tozalash', 'Mebellarni tozalash', 'Oshxona tozalash', 'Gilam yuvish'];
              final prices = [25000.0, 35000.0, 45000.0, 55000.0];
              return GestureDetector(
                onTap: () {},
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: context.gloss.bg,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: context.gloss.greenShadow,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(Icons.cleaning_services_rounded, color: context.gloss.green, size: 36),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        names[index],
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: context.gloss.text),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 3),
                      Text(
                        formatPrice(prices[index]),
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: context.gloss.greenText),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}