import 'package:flutter/material.dart';
import 'package:ui_kit/ui_kit.dart';
import 'booking_screen.dart';

class XizmatlarScreen extends StatelessWidget {
  const XizmatlarScreen({super.key});

  static const _services = [
    {
      'name': 'Umumiy tozalash',
      'price': '35 000 so\'m',
      'duration': '2 soat',
      'desc': 'Kvartirani umumiy tozalash. Chang yig\'ish, pol yuvish, yuzalarni artish.',
      'detail': 'Standart tozalash',
      'rating': 4.8,
      'orders': 120,
    },
    {
      'name': 'Premium tozalash',
      'price': '85 000 so\'m',
      'duration': '4 soat',
      'desc': 'Chuqur tozalash. Barcha yuzalar, derazalar, mebellarni tozalash.',
      'detail': 'Premium tozalash',
      'rating': 4.9,
      'orders': 85,
    },
    {
      'name': 'Kir yuvish',
      'price': '25 000 so\'m',
      'duration': '1 soat',
      'desc': 'Kirlarni yuvish, quritish va dazmollash.',
      'detail': 'Kir yuvish xizmati',
      'rating': 4.7,
      'orders': 200,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: GlossColors.bg,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: GlossColors.bg, borderRadius: BorderRadius.circular(12)),
            child: const Icon(Icons.arrow_back_ios_new_rounded, color: GlossColors.text, size: 18),
          ),
        ),
        title: const Text('Xizmatlar', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: GlossColors.text)),
      ),
      body: Stack(
        children: [
          const _LightBg(),
          ListView.builder(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            itemCount: _services.length,
            itemBuilder: (context, i) => Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: _GlassCard(service: _services[i]),
            ),
          ),
        ],
      ),
    );
  }
}

class _LightBg extends StatelessWidget {
  const _LightBg();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFFF0FFF0),
                Color(0xFFF5F5F5),
                Color(0xFFFAFAFA),
              ],
            ),
          ),
        ),
        Positioned(
          top: -30, left: -30,
          child: Container(
            width: 160, height: 160,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(colors: [GlossColors.green.withAlpha(18), Colors.transparent]),
            ),
          ),
        ),
        Positioned(
          top: 120, right: -50,
          child: Container(
            width: 140, height: 140,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(colors: [GlossColors.green.withAlpha(14), Colors.transparent]),
            ),
          ),
        ),
      ],
    );
  }
}

class _GlassCard extends StatelessWidget {
  final Map<String, dynamic> service;
  const _GlassCard({required this.service});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [BoxShadow(color: Color(0x0A000000), blurRadius: 12, offset: Offset(0, 4))],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(24),
        child: InkWell(
          borderRadius: BorderRadius.circular(24),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => BookingScreen(
                serviceName: service['name'] as String,
                subcategoryName: service['detail'] as String,
              ),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _CardHeader(service: service),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      service['name'] as String,
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: GlossColors.text, height: 1.2),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      service['desc'] as String,
                      style: const TextStyle(fontSize: 14, color: GlossColors.hint, height: 1.5),
                    ),
                    const SizedBox(height: 18),
                    const Divider(height: 1, color: GlossColors.divider),
                    const SizedBox(height: 16),
                    _StatsRow(service: service),
                    const SizedBox(height: 18),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton.icon(
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => BookingScreen(
                              serviceName: service['name'] as String,
                              subcategoryName: service['name'] as String,
                            ),
                          ),
                        ),
                        icon: const Icon(Icons.shopping_cart_outlined, size: 18),
                        label: const Text('Buyurtma berish', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, letterSpacing: 0.3)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: GlossColors.green,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          elevation: 0,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CardHeader extends StatelessWidget {
  final Map<String, dynamic> service;
  const _CardHeader({required this.service});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
      child: Row(
        children: [
          Container(
            width: 60, height: 60,
            decoration: BoxDecoration(
              color: GlossColors.greenBgSoft,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: GlossColors.greenBorderLight),
            ),
            child: const Icon(Icons.cleaning_services_rounded, color: GlossColors.green, size: 30),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        service['detail'] as String,
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: GlossColors.greenText),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if ((service['rating'] as double) >= 4.9) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(color: GlossColors.orangeBgLight, borderRadius: BorderRadius.circular(6)),
                        child: const Text('Mashhur', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: GlossColors.orange)),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    ...List.generate(5, (i) {
                      return Icon(
                        Icons.star_rounded,
                        size: 16,
                        color: i < (service['rating'] as double).round() ? GlossColors.star : GlossColors.border,
                      );
                    }),
                    const SizedBox(width: 6),
                    Text(
                      (service['rating'] as double).toStringAsFixed(1),
                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: GlossColors.hint),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '(${service['orders']})',
                      style: const TextStyle(fontSize: 12, color: GlossColors.disabled),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatsRow extends StatelessWidget {
  final Map<String, dynamic> service;
  const _StatsRow({required this.service});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.timer_outlined, size: 17, color: GlossColors.hint),
        const SizedBox(width: 5),
        Text(service['duration'] as String, style: const TextStyle(fontSize: 14, color: GlossColors.hint)),
        const SizedBox(width: 8),
        Container(width: 1, height: 14, color: GlossColors.border),
        const SizedBox(width: 8),
        const Icon(Icons.person_outline_rounded, size: 17, color: GlossColors.hint),
        const SizedBox(width: 5),
        Text('${service['orders']}+ buyurtma', style: const TextStyle(fontSize: 14, color: GlossColors.hint)),
        const Spacer(),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const Text('Narxi', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: GlossColors.disabled)),
            const SizedBox(height: 2),
            Text(service['price'] as String, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: GlossColors.greenText)),
          ],
        ),
      ],
    );
  }
}
