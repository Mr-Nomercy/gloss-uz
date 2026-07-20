import 'package:flutter/material.dart';
import 'package:ui_kit/ui_kit.dart';

class OrderSuccessScreen extends StatelessWidget {
  final String orderId;
  const OrderSuccessScreen({super.key, this.orderId = ''});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.gloss.bg,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: context.gloss.green.withValues(alpha: 0.08),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.check_circle_rounded, color: context.gloss.green, size: 80),
                ),
                const SizedBox(height: 28),
                Text('Buyurtma qabul qilindi!', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: context.gloss.text)),
                const SizedBox(height: 12),
                Text(
                  'Buyurtmangiz muvaffaqiyatli qabul qilindi.\nXodim siz bilan bog\'lanadi.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 15, color: context.gloss.hint, height: 1.5),
                ),
                const SizedBox(height: 32),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(color: context.gloss.card, borderRadius: BorderRadius.circular(16)),
                  child: Column(
                    children: [
                      _buildInfoRow(context, 'Buyurtma raqami', orderId),
                      const SizedBox(height: 10),
                      _buildInfoRow(context, 'Yetkazish vaqti', '30-45 daqiqa'),
                      const SizedBox(height: 10),
                      _buildInfoRow(context, 'Holat', 'Tayyorlanmoqda'),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                GlossButton(
                  label: 'Bosh sahifaga',
                  onPressed: () => Navigator.popUntil(context, (route) => route.isFirst),
                ),
                const SizedBox(height: 14),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(fontSize: 14, color: context.gloss.hint)),
        Text(value, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: context.gloss.text)),
      ],
    );
  }
}