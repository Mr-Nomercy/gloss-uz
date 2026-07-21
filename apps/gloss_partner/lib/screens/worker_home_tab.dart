import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ui_kit/ui_kit.dart';

final _workerOnlineProvider = StateProvider<bool>((ref) => true);

final _workerNewOffersProvider = Provider<List<_WorkerOffer>>((ref) {
  return const [
    _WorkerOffer('Haftalik tozalash', 'Chilonzor 12/4', 180000, 'Bugun 15:00'),
    _WorkerOffer('General tozalash', 'Olmazor 5/2', 350000, 'Bugun 16:30'),
    _WorkerOffer('Ofis tozalash', 'Mirzo Ulug\'bek 22', 250000, 'Ertaga 09:00'),
  ];
});

class WorkerHomeTab extends ConsumerWidget {
  const WorkerHomeTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = context.gloss;
    final isOnline = ref.watch(_workerOnlineProvider);
    final newOffers = ref.watch(_workerNewOffersProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: isOnline ? theme.green.withValues(alpha: 0.06) : Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isOnline ? theme.green.withValues(alpha: 0.2) : theme.border,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isOnline ? theme.green : theme.grayMedium,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        isOnline ? 'Onlayn — buyurtmalar qabul qilinmoqda' : 'Oflayn',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: theme.text),
                      ),
                    ),
                    Switch(
                      value: isOnline,
                      onChanged: (v) => ref.read(_workerOnlineProvider.notifier).state = v,
                      activeTrackColor: theme.green,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              GlossBalanceCard(
                title: 'Joriy balans',
                balance: '2 850 000 so\'m',
                actionLabel: 'Pul yechish',
                onAction: () {},
              ),
              const SizedBox(height: 20),
              if (isOnline) ...[
                Row(
                  children: [
                    AnimatedContainer(
                      duration: const Duration(seconds: 2),
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: theme.green,
                        boxShadow: [
                          BoxShadow(
                            color: theme.green.withValues(alpha: 0.4),
                            blurRadius: 6,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Yangi buyurtmalar',
                      style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: theme.text),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ...newOffers.map((offer) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: _PulsingOfferCard(offer: offer, theme: theme),
                  );
                }),
                const SizedBox(height: 8),
              ],
              Text(
                'Tezkor amallar',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: theme.text),
              ),
              const SizedBox(height: 12),
              GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                childAspectRatio: 1.4,
                children: [
                  _QuickAction(
                    icon: Icons.receipt_long_rounded,
                    label: 'Buyurtmalar',
                    color: theme.green,
                    onTap: () => context.go('/worker/orders'),
                  ),
                  _QuickAction(
                    icon: Icons.bar_chart_rounded,
                    label: 'Statistika',
                    color: GlossColors.catBlue,
                    onTap: () => context.go('/worker/stats'),
                  ),
                  _QuickAction(
                    icon: Icons.account_balance_wallet_rounded,
                    label: 'Hamyon',
                    color: GlossColors.catOrange,
                    onTap: () {},
                  ),
                  _QuickAction(
                    icon: Icons.calendar_month_rounded,
                    label: 'Ish grafigi',
                    color: GlossColors.catPurple,
                    onTap: () {},
                  ),
                ],
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

class _WorkerOffer {
  final String service;
  final String address;
  final int amount;
  final String time;
  const _WorkerOffer(this.service, this.address, this.amount, this.time);
}

class _PulsingOfferCard extends StatefulWidget {
  final _WorkerOffer offer;
  final GlossTheme theme;
  const _PulsingOfferCard({required this.offer, required this.theme});

  @override
  State<_PulsingOfferCard> createState() => _PulsingOfferCardState();
}

class _PulsingOfferCardState extends State<_PulsingOfferCard> with SingleTickerProviderStateMixin {
  late final _anim = AnimationController(vsync: this, duration: const Duration(seconds: 2))..repeat(reverse: true);

  @override
  void dispose() {
    _anim.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = widget.theme;
    final offer = widget.offer;
    return AnimatedBuilder(
      animation: _anim,
      builder: (_, child) {
        return Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: Color.lerp(theme.green.withValues(alpha: 0.2), theme.green.withValues(alpha: 0.6), _anim.value)!,
              width: 2,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: theme.green.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.cleaning_services_rounded, color: theme.green, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(offer.service, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: theme.text)),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Icon(Icons.location_on_outlined, size: 14, color: theme.hint),
                        const SizedBox(width: 2),
                        Expanded(
                          child: Text(offer.address, style: TextStyle(fontSize: 12, color: theme.hint), overflow: TextOverflow.ellipsis),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Icon(Icons.access_time_rounded, size: 14, color: theme.hint),
                        const SizedBox(width: 2),
                        Text(offer.time, style: TextStyle(fontSize: 12, color: theme.hint)),
                      ],
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  Text(formatPrice(offer.amount), style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: theme.text)),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 32,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.green,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        minimumSize: Size.zero,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                      ),
                      child: const Text('Qabul qilish'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _QuickAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _QuickAction({required this.icon, required this.label, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = context.gloss;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withValues(alpha: 0.12), width: 1.5),
        ),
        padding: const EdgeInsets.all(14),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: Colors.white, size: 20),
            ),
            const SizedBox(height: 8),
            Text(label, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: theme.text)),
          ],
        ),
      ),
    );
  }
}
