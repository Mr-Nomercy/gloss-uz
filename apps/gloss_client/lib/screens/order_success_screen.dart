import 'package:flutter/material.dart';
import 'package:ui_kit/ui_kit.dart';

class OrderSuccessScreen extends StatelessWidget {
  final String orderId;
  const OrderSuccessScreen({super.key, this.orderId = ''});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GlossColors.bg,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(color: GlossColors.green.withAlpha(20), shape: BoxShape.circle),
                  child: const Icon(Icons.check_circle_rounded, color: GlossColors.green, size: 80),
                ),
                const SizedBox(height: 28),
                const Text('Buyurtma qabul qilindi!', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: GlossColors.text)),
                const SizedBox(height: 12),
                Text(
                  'Buyurtmangiz muvaffaqiyatli qabul qilindi.\nXodim siz bilan bog\'lanadi.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 15, color: Colors.grey[600], height: 1.5),
                ),
                const SizedBox(height: 32),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(color: GlossColors.card, borderRadius: BorderRadius.circular(16)),
                  child: Column(
                    children: [
                      _buildInfoRow('Buyurtma raqami', orderId),
                      const SizedBox(height: 10),
                      _buildInfoRow('Yetkazish vaqti', '30-45 daqiqa'),
                      const SizedBox(height: 10),
                      _buildInfoRow('Holat', 'Tayyorlanmoqda'),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                SizedBox(
                  width: double.infinity, height: 54,
                  child: ElevatedButton(
                    onPressed: () => Navigator.popUntil(context, (route) => route.isFirst),
                    style: ElevatedButton.styleFrom(backgroundColor: GlossColors.green, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)), elevation: 0),
                    child: const Text('Bosh sahifaga', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700)),
                  ),
                ),
                const SizedBox(height: 14),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(fontSize: 14, color: Colors.grey[500])),
        Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: GlossColors.text)),
      ],
    );
  }
}
