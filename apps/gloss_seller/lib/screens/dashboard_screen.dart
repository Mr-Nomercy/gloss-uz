import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ui_kit/ui_kit.dart';
import 'animations.dart';

class SellerDashboardScreen extends StatefulWidget {
  const SellerDashboardScreen({super.key});

  @override
  State<SellerDashboardScreen> createState() => _SellerDashboardScreenState();
}

class _SellerDashboardScreenState extends State<SellerDashboardScreen> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 400), () {
      if (mounted) setState(() => _isLoading = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.gloss;
    return Scaffold(
      backgroundColor: theme.bg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Panel',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: theme.text),
        ),
      ),
      body: _isLoading
          ? const GlossLoadingView(message: 'Yuklanmoqda...')
          : ListView(
        padding: const EdgeInsets.all(16),
        children: [
          FadeSlideOnMount(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: LinearGradient(
                  colors: [theme.green, theme.darkGreen],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: theme.greenShadow.withValues(alpha: 0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.store, color: Colors.white, size: 32),
                    ),
                    const SizedBox(height: 14),
                    const Text(
                      "Mening do'konim",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '@mening_dokonim',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.normal,
                        color: Colors.white.withValues(alpha: 0.8),
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          FadeSlideOnMount(
            delay: const Duration(milliseconds: 100),
            child: Row(
              children: [
                Expanded(
                  child: ScaleTap(
                    child: GlossCard(
                      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: theme.green.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(Icons.inventory, color: theme.green, size: 20),
                          ),
                          const SizedBox(height: 12),
                          AnimatedCounter(
                            targetValue: 12,
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: theme.text,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text('Mahsulotlar', style: TextStyle(fontSize: 12, color: theme.hint)),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ScaleTap(
                    child: GlossCard(
                      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: theme.green.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(Icons.receipt, color: theme.green, size: 20),
                          ),
                          const SizedBox(height: 12),
                          AnimatedCounter(
                            targetValue: 45,
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: theme.text,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text('Buyurtmalar', style: TextStyle(fontSize: 12, color: theme.hint)),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          FadeSlideOnMount(
            delay: const Duration(milliseconds: 200),
            child: Row(
              children: [
                Expanded(
                  child: ScaleTap(
                    child: GlossCard(
                      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: theme.green.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(Icons.money, color: theme.green, size: 20),
                          ),
                          const SizedBox(height: 12),
                          FadeSlideOnMount(
                            delay: const Duration(milliseconds: 600),
                            child: Text(
                              '2.5M',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: theme.text,
                              ),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text('Daromad', style: TextStyle(fontSize: 12, color: theme.hint)),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ScaleTap(
                    child: GlossCard(
                      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: GlossColors.star.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(Icons.star, color: GlossColors.star, size: 20),
                          ),
                          const SizedBox(height: 12),
                          FadeSlideOnMount(
                            delay: const Duration(milliseconds: 800),
                            child: Text(
                              '4.8',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: theme.text,
                              ),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text('Reyting', style: TextStyle(fontSize: 12, color: theme.hint)),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          FadeSlideOnMount(
            delay: const Duration(milliseconds: 300),
            child: GlossButton(
              label: "Mahsulot qo'shish",
              onPressed: () => context.go('/seller/add-product'),
            ),
          ),
          const SizedBox(height: 12),
          FadeSlideOnMount(
            delay: const Duration(milliseconds: 400),
            child: SizedBox(
              height: 52,
              child: OutlinedButton(
                onPressed: () => context.go('/seller/kyc'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: theme.green,
                  side: BorderSide(color: theme.green.withValues(alpha: 0.30)),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                child: const Text('KYC tekshiruvi'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
