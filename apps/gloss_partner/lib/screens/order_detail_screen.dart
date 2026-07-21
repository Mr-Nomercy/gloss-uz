import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:timeline_tile/timeline_tile.dart';
import 'package:ui_kit/ui_kit.dart';

final _sharedOrderDetailProvider = Provider.family<_OrderDetailModel, String>((ref, orderId) {
  return _OrderDetailModel(
    orderNumber: orderId,
    status: 'in_progress',
    address: 'Chilonzor tumani, 12-mavze, 4-uy',
    addressNote: '2-qavat, 45-xonadon',
    serviceType: orderId.startsWith('ORD-001') ? 'Yetkazib berish' : 'Tozalash',
    items: const [
      _DetailItem('Umumiy tozalash', 1, 180000),
    ],
    subtotal: 180000,
    deliveryFee: 0,
    platformFee: 15000,
    total: 195000,
    customer: 'Alisher Karimov',
    customerPhone: '998901112233',
    timeline: const [
      _TimelineEntry('Buyurtma qabul qilindi', '09:00', true),
      _TimelineEntry('Manzilga yetib borildi', '09:15', true),
      _TimelineEntry('Ish boshlandi', '09:20', true),
      _TimelineEntry('Ish yakunlandi', '', false),
    ],
  );
});

class OrderDetailScreen extends ConsumerWidget {
  final String orderId;
  const OrderDetailScreen({super.key, required this.orderId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = context.gloss;
    final detail = ref.watch(_sharedOrderDetailProvider(orderId));

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('#${detail.orderNumber}', style: TextStyle(color: theme.text, fontWeight: FontWeight.w600)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_rounded, color: theme.text, size: 20),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _AddressDetailCard(theme: theme, detail: detail),
            const SizedBox(height: 16),
            _ItemsCard(theme: theme, items: detail.items),
            const SizedBox(height: 16),
            _TimelineDetailCard(theme: theme, entries: detail.timeline),
            const SizedBox(height: 16),
            _PriceCard(theme: theme, detail: detail),
            const SizedBox(height: 20),
            if (detail.serviceType == 'Yetkazib berish')
              Row(
                children: [
                  Expanded(
                    child: GlossButton(
                      label: 'Yetkazdim',
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Buyurtma yetkazildi!'), backgroundColor: Color(0xFF16A34A)),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: GlossButton(
                      label: 'Muammo',
                      isOutlined: true,
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: const Text('Muammo xabar qilindi'), backgroundColor: theme.orange),
                        );
                      },
                    ),
                  ),
                ],
              )
            else
              Row(
                children: [
                  Expanded(
                    child: GlossButton(
                      label: 'Boshladim',
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Ish boshlandi!'), backgroundColor: Color(0xFF16A34A)),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: GlossButton(
                      label: 'Tugatdim',
                      isOutlined: true,
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Ish yakunlandi!'), backgroundColor: Color(0xFF16A34A)),
                        );
                      },
                    ),
                  ),
                ],
              ),
            const SizedBox(height: 16),
            Row(
              children: [
                Icon(Icons.person_rounded, size: 18, color: theme.hint),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Mijoz: ${detail.customer}', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: theme.text)),
                      Text(detail.customerPhone, style: TextStyle(fontSize: 12, color: theme.hint)),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.phone_rounded, color: theme.green, size: 22),
                  onPressed: () {},
                ),
              ],
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _OrderDetailModel {
  final String orderNumber;
  final String status;
  final String address;
  final String addressNote;
  final String serviceType;
  final List<_DetailItem> items;
  final int subtotal;
  final int deliveryFee;
  final int platformFee;
  final int total;
  final String customer;
  final String customerPhone;
  final List<_TimelineEntry> timeline;
  const _OrderDetailModel({
    required this.orderNumber,
    required this.status,
    required this.address,
    required this.addressNote,
    required this.serviceType,
    required this.items,
    required this.subtotal,
    required this.deliveryFee,
    required this.platformFee,
    required this.total,
    required this.customer,
    required this.customerPhone,
    required this.timeline,
  });
}

class _DetailItem {
  final String name;
  final int quantity;
  final int price;
  const _DetailItem(this.name, this.quantity, this.price);
}

class _TimelineEntry {
  final String label;
  final String time;
  final bool completed;
  const _TimelineEntry(this.label, this.time, this.completed);
}

class _AddressDetailCard extends StatelessWidget {
  final GlossTheme theme;
  final _OrderDetailModel detail;
  const _AddressDetailCard({required this.theme, required this.detail});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.cleaning_services_rounded, size: 20, color: theme.green),
              const SizedBox(width: 8),
              Text(detail.serviceType, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: theme.green)),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Icon(Icons.location_on_outlined, size: 18, color: theme.green),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Manzil', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: theme.green)),
                    const SizedBox(height: 2),
                    Text(detail.address, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: theme.text)),
                    if (detail.addressNote.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(detail.addressNote, style: TextStyle(fontSize: 12, color: theme.hint)),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ItemsCard extends StatelessWidget {
  final GlossTheme theme;
  final List<_DetailItem> items;
  const _ItemsCard({required this.theme, required this.items});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Buyurtma tarkibi', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: theme.text)),
          const SizedBox(height: 12),
          ...items.map((item) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              children: [
                Expanded(
                  child: Text('${item.name} x${item.quantity}', style: TextStyle(fontSize: 13, color: theme.text)),
                ),
                Text(formatPrice(item.price), style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: theme.text)),
              ],
            ),
          )),
        ],
      ),
    );
  }
}

class _TimelineDetailCard extends StatelessWidget {
  final GlossTheme theme;
  final List<_TimelineEntry> entries;
  const _TimelineDetailCard({required this.theme, required this.entries});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Holat', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: theme.text)),
          const SizedBox(height: 8),
          ...List.generate(entries.length, (i) {
            final entry = entries[i];
            final isLast = i == entries.length - 1;
            return TimelineTile(
              alignment: TimelineAlign.start,
              isLast: isLast,
              beforeLineStyle: LineStyle(color: entry.completed ? theme.green : theme.grayLight, thickness: 2),
              indicatorStyle: IndicatorStyle(
                width: 20,
                height: 20,
                indicator: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: entry.completed ? theme.green : theme.grayLight,
                    border: Border.all(
                      color: entry.completed ? theme.green.withValues(alpha: 0.3) : Colors.transparent,
                      width: 2,
                    ),
                  ),
                  child: entry.completed ? const Icon(Icons.check_rounded, size: 12, color: Colors.white) : null,
                ),
              ),
              endChild: Padding(
                padding: const EdgeInsets.only(left: 16, bottom: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      entry.label,
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: entry.completed ? theme.text : theme.hint),
                    ),
                    if (entry.time.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(entry.time, style: TextStyle(fontSize: 12, color: theme.hint)),
                    ],
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _PriceCard extends StatelessWidget {
  final GlossTheme theme;
  final _OrderDetailModel detail;
  const _PriceCard({required this.theme, required this.detail});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Narxlar', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: theme.text)),
          const SizedBox(height: 12),
          _PriceRow(label: 'Xizmat', amount: detail.subtotal),
          if (detail.deliveryFee > 0) _PriceRow(label: 'Yetkazish', amount: detail.deliveryFee),
          _PriceRow(label: 'Platforma yig\'imi', amount: detail.platformFee),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 6),
            child: Divider(),
          ),
          _PriceRow(label: 'Jami', amount: detail.total, isBold: true),
        ],
      ),
    );
  }
}

class _PriceRow extends StatelessWidget {
  final String label;
  final int amount;
  final bool isBold;
  const _PriceRow({required this.label, required this.amount, this.isBold = false});

  @override
  Widget build(BuildContext context) {
    final theme = context.gloss;
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: 13, color: isBold ? theme.text : theme.hint, fontWeight: isBold ? FontWeight.w600 : FontWeight.w400)),
          Text(formatPrice(amount), style: TextStyle(fontSize: 13, color: theme.text, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
