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
        backgroundColor: context.gloss.bg,
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
        title: Text('Xizmatlar', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: context.gloss.text)),
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
          top: -30,
          left: -30,
          child: Container(
            width: 160,
            height: 160,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(colors: [GlossColors.green.withValues(alpha: 0.07), Colors.transparent]),
            ),
          ),
        ),
        Positioned(
          top: 120,
          right: -50,
          child: Container(
            width: 140,
            height: 140,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(colors: [GlossColors.green.withValues(alpha: 0.05), Colors.transparent]),
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
    return GlossCard(
      padding: EdgeInsets.zero,
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
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: context.gloss.text, height: 1.2),
                ),
                const SizedBox(height: 6),
                Text(
                  service['desc'] as String,
                  style: TextStyle(fontSize: 14, color: context.gloss.hint, height: 1.5),
                ),
                const SizedBox(height: 18),
                Divider(height: 1, color: context.gloss.divider),
                const SizedBox(height: 16),
                _StatsRow(service: service),
                const SizedBox(height: 18),
                GlossButton(
                  label: 'Buyurtma berish',
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => BookingScreen(
                        serviceName: service['name'] as String,
                        subcategoryName: service['name'] as String,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CardHeader extends StatelessWidget {
  final Map<String, dynamic> service;
  const _CardHeader({required this.service});

  @override
  Widget build(BuildContext context) {
    final isPopular = (service['rating'] as double) >= 4.9;
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: context.gloss.greenBgSoft,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: context.gloss.greenBorderLight),
            ),
            child: Icon(Icons.cleaning_services_rounded, color: context.gloss.green, size: 30),
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
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: context.gloss.greenText),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (isPopular) ...[
                      const SizedBox(width: 8),
                      GlossBadge(label: 'Mashhur', variant: BadgeVariant.warning),
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
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: context.gloss.hint),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '(${service['orders']})',
                      style: TextStyle(fontSize: 12, color: context.gloss.disabled),
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
        Icon(Icons.timer_outlined, size: 17, color: context.gloss.hint),
        const SizedBox(width: 5),
        Text(service['duration'] as String, style: TextStyle(fontSize: 14, color: context.gloss.hint)),
        const SizedBox(width: 8),
        Container(width: 1, height: 14, color: context.gloss.border),
        const SizedBox(width: 8),
        Icon(Icons.person_outline_rounded, size: 17, color: context.gloss.hint),
        const SizedBox(width: 5),
        Text('${service['orders']}+ buyurtma', style: TextStyle(fontSize: 14, color: context.gloss.hint)),
        const Spacer(),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text('Narxi', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: context.gloss.disabled)),
            const SizedBox(height: 2),
            Text(service['price'] as String, style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: context.gloss.greenText)),
          ],
        ),
      ],
    );
  }
}