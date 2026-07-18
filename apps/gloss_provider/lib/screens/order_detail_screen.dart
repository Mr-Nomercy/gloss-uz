import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ui_kit/ui_kit.dart';

class OrderDetailScreen extends StatefulWidget {
  final String orderId;
  const OrderDetailScreen({super.key, required this.orderId});

  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  int _currentStep = 1;

  final List<Map<String, String>> _steps = const [
    {'title': 'Buyurtma yuborildi', 'key': 'searching'},
    {'title': 'Qabul qilingan', 'key': 'assigned'},
    {'title': "Yo'lda", 'key': 'enRoute'},
    {'title': 'Yetib kelgan', 'key': 'arrived'},
    {'title': "Xizmat ko'rsatilmoqda", 'key': 'inProgress'},
    {'title': 'Tugallangan', 'key': 'completed'},
    {'title': 'Baholangan', 'key': 'rated'},
  ];

  String get _currentAction {
    switch (_currentStep) {
      case 0:
        return 'Qabul qilish';
      case 1:
        return "Yo'lga chiqdim";
      case 2:
        return 'Yetib keldim';
      case 3:
        return 'Boshlash';
      case 4:
        return 'Tugatish';
      default:
        return '';
    }
  }

  bool get _canCancel => _currentStep >= 0 && _currentStep <= 3;

  String get _statusLabel {
    if (_currentStep == 5) return 'Tugallangan';
    if (_currentStep == 6) return 'Baholangan';
    return 'Jarayonda';
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
          'Buyurtma #${widget.orderId}',
          style: TextStyle(color: theme.text, fontWeight: FontWeight.w700, fontSize: 18),
        ),
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: theme.bg,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.arrow_back_ios_new_rounded, color: theme.text, size: 18),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildHeader(theme),
            const SizedBox(height: 16),
            _buildAddressCard(theme),
            const SizedBox(height: 16),
            _buildPriceBreakdown(theme),
            const SizedBox(height: 16),
            _buildStatusTimeline(theme),
            const SizedBox(height: 24),
            _buildActionButtons(theme),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(GlossTheme theme) {
    return GlossCard(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: theme.greenBgLight,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(Icons.cleaning_services_rounded, color: theme.green, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Uy tozalash',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  'Buyurtma #${widget.orderId}',
                  style: TextStyle(fontSize: 13, color: theme.hint),
                ),
              ],
            ),
          ),
          GlossBadge.status(_statusLabel),
        ],
      ),
    );
  }

  Widget _buildAddressCard(GlossTheme theme) {
    return GlossCard(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: theme.greenBgLight,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(Icons.location_on_outlined, color: theme.green, size: 18),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Mirzo Ulug'bek tumani, Mustaqillik 45",
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: theme.text),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '2-qavat, 15-xonadon',
                        style: TextStyle(fontSize: 12, color: theme.hint),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 140,
            width: double.infinity,
            decoration: BoxDecoration(
              color: theme.grayLight,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(12),
                bottomRight: Radius.circular(12),
              ),
            ),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.map_outlined, size: 32, color: theme.hint),
                  const SizedBox(height: 4),
                  Text('Xarita', style: TextStyle(color: theme.hint, fontSize: 12)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceBreakdown(GlossTheme theme) {
    return GlossCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Narx tafsilotlari',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 16),
          _priceRow(theme, 'Xizmat narxi', "100 000 so'm"),
          const SizedBox(height: 10),
          _priceRow(theme, "Qo'shimchalar", "20 000 so'm"),
          const SizedBox(height: 10),
          _priceRow(theme, 'Komissiya (10%)', "12 000 so'm"),
          const SizedBox(height: 12),
          Divider(color: theme.divider),
          const SizedBox(height: 8),
          _priceRow(theme, 'Jami', "132 000 so'm", isBold: true, isGreen: true),
        ],
      ),
    );
  }

  Widget _priceRow(GlossTheme theme, String label, String value, {bool isBold = false, bool isGreen = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: isBold ? theme.text : theme.hint,
            fontWeight: isBold ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
            color: isGreen ? theme.greenText : theme.text,
          ),
        ),
      ],
    );
  }

  Widget _buildStatusTimeline(GlossTheme theme) {
    return GlossCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Buyurtma holati',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 20),
          ...List.generate(_steps.length, (index) {
            final isCompleted = index <= _currentStep;
            final isLast = index == _steps.length - 1;

            return IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 24,
                    child: Column(
                      children: [
                        Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            color: isCompleted ? theme.green : theme.grayLight,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            isCompleted ? Icons.check : Icons.circle,
                            size: 14,
                            color: isCompleted ? Colors.white : theme.grayMedium,
                          ),
                        ),
                        if (!isLast)
                          Expanded(
                            child: Container(
                              width: 2,
                              color: isCompleted ? theme.green : theme.grayLight,
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Padding(
                    padding: EdgeInsets.only(bottom: isLast ? 0 : 24),
                    child: Text(
                      _steps[index]['title']!,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: isCompleted ? FontWeight.w600 : FontWeight.normal,
                        color: isCompleted ? theme.text : theme.hint,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildActionButtons(GlossTheme theme) {
    if (_currentStep == 6) {
      return GlossCard(
        padding: const EdgeInsets.all(20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.star_rounded, color: theme.star, size: 20),
            const SizedBox(width: 8),
            Text(
              'Baholandi',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: theme.text,
              ),
            ),
          ],
        ),
      );
    }

    if (_currentStep == 5) return const SizedBox.shrink();

    return Column(
      children: [
        if (_currentAction.isNotEmpty)
          GlossButton(
            label: _currentAction,
            onPressed: () {
              setState(() => _currentStep++);
            },
          ),
        if (_canCancel) ...[
          const SizedBox(height: 12),
          SizedBox(
            height: 52,
            child: OutlinedButton(
              onPressed: () => _showCancelDialog(theme),
              style: OutlinedButton.styleFrom(
                foregroundColor: theme.red,
                side: BorderSide(color: theme.red.withValues(alpha: 0.30)),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              child: const Text('Bekor qilish'),
            ),
          ),
        ],
      ],
    );
  }

  void _showCancelDialog(GlossTheme theme) {
    GlossDialog.show(
      context: context,
      title: 'Bekor qilish',
      content: 'Buyurtmani bekor qilishni xohlaysizmi?',
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Yo'q"),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            context.pop();
            GlossSnackBar.showInfo(context, 'Buyurtma bekor qilindi');
          },
          child: Text('Ha', style: TextStyle(color: theme.red)),
        ),
      ],
    );
  }
}