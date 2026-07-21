import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ui_kit/ui_kit.dart';
import '../providers/orders_provider.dart';
import '../utils/status_labels.dart';

class OrderDetailScreen extends ConsumerStatefulWidget {
  final String orderId;
  const OrderDetailScreen({super.key, required this.orderId});

  @override
  ConsumerState<OrderDetailScreen> createState() =>
      _OrderDetailScreenState();
}

class _OrderDetailScreenState extends ConsumerState<OrderDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final theme = context.gloss;
    final order = _mockOrder();

    return Scaffold(
      backgroundColor: theme.bg,
      appBar: GlossAppBar(title: order.orderNumber),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GlossCard(
              accentColor: theme.green,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text(
                        'Buyurtma holati',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: GlossColors.text,
                        ),
                      ),
                      const Spacer(),
                      GlossBadge.status(orderStatusLabel(order.status)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _statusTimeline(theme, order.status),
                ],
              ),
            ),
            const SizedBox(height: 16),
            GlossCard(
              accentColor: order.type == 'service' ? theme.green : theme.orange,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _detailRow('Mijoz', order.clientName),
                  _detailRow('Telefon', order.clientPhone),
                  if (order.addressLine != null)
                    _detailRow('Manzil', order.addressLine!),
                  if (order.providerName != null)
                    _detailRow('Provayder', order.providerName!),
                  if (order.courierName != null)
                    _detailRow('Kuryer', order.courierName!),
                  _detailRow('Buyurtma turi', order.type == 'service' ? 'Xizmat' : 'Mahsulot'),
                  _detailRow("To'lov holati", paymentStatusLabel(order.paymentStatus)),
                  if (order.scheduledAt != null)
                    _detailRow('Rejalashtirilgan vaqt',
                        order.scheduledAt.toString().substring(0, 16)),
                ],
              ),
            ),
            const SizedBox(height: 16),
            GlossCard(
              accentColor: theme.green,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "To'lov ma'lumotlari",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: GlossColors.text,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _paymentRow('Summa', formatPrice(order.subtotal.toInt()), theme),
                  if (order.discount > 0)
                    _paymentRow('Chegirma', '-${formatPrice(order.discount.toInt())}', theme, color: theme.red),
                  if (order.deliveryFee > 0)
                    _paymentRow('Yetkazib berish', formatPrice(order.deliveryFee.toInt()), theme),
                  if (order.platformFee > 0)
                    _paymentRow('Platforma komissiyasi', formatPrice(order.platformFee.toInt()), theme),
                  const Divider(height: 24),
                  _paymentRow('Jami', formatPrice(order.total.toInt()), theme,
                    isBold: true, color: theme.green),
                ],
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 13,
                color: context.gloss.hint,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: GlossColors.text,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _paymentRow(String label, String value, GlossTheme theme,
      {bool isBold = false, Color? color}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Text(label, style: TextStyle(fontSize: 13, color: theme.hint)),
          const Spacer(),
          Text(
            value,
            style: TextStyle(
              fontSize: 13,
              fontWeight: isBold ? FontWeight.w700 : FontWeight.w600,
              color: color ?? GlossColors.text,
            ),
          ),
        ],
      ),
    );
  }

  Widget _statusTimeline(GlossTheme theme, String currentStatus) {
    final steps = [
      OrderStep('pending', 'Buyurtma'),
      OrderStep('confirmed', 'Tasdiqlandi'),
      OrderStep('assigned', 'Biriktirildi'),
      OrderStep('in_progress', 'Jarayonda'),
      OrderStep('completed', 'Yakunlandi'),
    ];

    final statusOrder = steps.map((s) => s.key).toList();
    final currentIdx = statusOrder.indexOf(currentStatus);

    return Column(
      children: List.generate(steps.length, (i) {
        final step = steps[i];
        final isPast = i <= currentIdx;
        final isCurrent = i == currentIdx;

        return SizedBox(
          height: 36,
          child: Row(
            children: [
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isPast ? theme.green : theme.grayLight,
                  border: isCurrent
                      ? Border.all(color: theme.green, width: 2)
                      : null,
                ),
                child: isPast
                    ? const Icon(Icons.check, size: 12, color: Colors.white)
                    : null,
              ),
              const SizedBox(width: 10),
              Text(
                step.label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: isCurrent ? FontWeight.w700 : FontWeight.w500,
                  color: isPast ? theme.text : theme.hint,
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  AdminOrder _mockOrder() {
    return AdminOrder(
      id: '1',
      orderNumber: 'GL-0042',
      clientName: 'Aziz Karimov',
      clientPhone: '+998901234567',
      providerName: 'Gloss Clean Pro',
      type: 'service',
      status: 'completed',
      paymentStatus: 'paid',
      subtotal: 85000,
      discount: 0,
      deliveryFee: 5000,
      platformFee: 12750,
      total: 97750,
      addressLine: 'Toshkent, Yunusobod tumani, 12-mavze, 45-uy',
      scheduledAt: DateTime.now().subtract(const Duration(hours: 3)),
      createdAt: DateTime.now().subtract(const Duration(hours: 5)),
    );
  }
}

