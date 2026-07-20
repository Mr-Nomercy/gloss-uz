import 'dart:async';
import 'package:flutter/material.dart';
import 'package:ui_kit/ui_kit.dart';

class OrderScreen extends StatefulWidget {
  final String serviceName;
  final String? orderId;

  const OrderScreen({super.key, this.serviceName = '', this.orderId});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  int _currentStep = 0;
  Timer? _simTimer;
  double _driverProgress = 0.0;

  final List<_TrackingStep> _steps = const [
    _TrackingStep('Buyurtma qabul qilindi', 'Xizmat ko\'rsatuvchi topildi', Icons.check_circle_rounded),
    _TrackingStep('Yo\'lda', 'Xodim manzilga yetib kelmoqda', Icons.directions_car_rounded),
    _TrackingStep('Tozalash', 'Xizmat ko\'rsatilmoqda', Icons.cleaning_services_rounded),
    _TrackingStep('Yakunlandi', 'Tozalash tugatildi', Icons.flag_rounded),
  ];

  @override
  void initState() {
    super.initState();
    _startSimulation();
  }

  @override
  void dispose() {
    _simTimer?.cancel();
    super.dispose();
  }

  void _startSimulation() {
    _simTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      setState(() {
        _driverProgress += 0.05;
        if (_driverProgress >= 1.0) {
          _driverProgress = 1.0;
          timer.cancel();
        }
      });
      if (_driverProgress > 0.35 && _currentStep < 1) _advanceStep();
      if (_driverProgress > 0.8 && _currentStep < 2) _advanceStep();
      if (_driverProgress >= 1.0 && _currentStep < 3) {
        Future.delayed(const Duration(seconds: 2), () {
          if (mounted) _advanceStep();
        });
      }
    });
  }

  void _advanceStep() {
    if (_currentStep < _steps.length - 1) {
      setState(() => _currentStep++);
      if (_currentStep == 3) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            GlossSnackBar.showSuccess(context, 'Buyurtma muvaffaqiyatli yakunlandi!');
            GlossDialog.show(
              context: context,
              title: 'Xizmatni baholang',
              content: 'Buyurtma yakunlandi. Xizmatni baholaysizmi?',
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Keyinroq', style: TextStyle(color: context.gloss.hint)),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Baholash', style: TextStyle(color: context.gloss.green, fontWeight: FontWeight.w700)),
                ),
              ],
            );
          }
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            color: context.gloss.bg,
            child: Center(
              child: Container(
                height: 200,
                width: double.infinity,
                color: context.gloss.greenBgLight,
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.map_rounded, size: 64, color: GlossColors.green.withValues(alpha: 0.39)),
                      const SizedBox(height: 8),
                      Text('Xarita', style: TextStyle(fontSize: 16, color: context.gloss.hint)),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).padding.top + 8,
            left: 16,
            right: 16,
            child: GlossCard(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.of(context).popUntil((r) => r.isFirst),
                    child: Icon(Icons.arrow_back_ios_new_rounded, color: context.gloss.text, size: 24),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Buyurtma GLS-12345', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: context.gloss.text)),
                        Text(
                          widget.serviceName.isNotEmpty ? widget.serviceName : 'Tozalash',
                          style: TextStyle(fontSize: 13, color: context.gloss.hint),
                        ),
                      ],
                    ),
                  ),
                  GlossBadge(label: _currentStep >= 3 ? 'Bajarildi' : 'Faol'),
                ],
              ),
            ),
          ),
          DraggableScrollableSheet(
            initialChildSize: 0.42,
            minChildSize: 0.18,
            maxChildSize: 0.6,
            builder: (context, scrollController) {
              return Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                  boxShadow: [BoxShadow(color: Color(0x1A000000), blurRadius: 16, offset: Offset(0, -4))],
                ),
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(20),
                  children: [
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(color: GlossColors.border, borderRadius: BorderRadius.circular(2)),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Container(
                          width: 52,
                          height: 52,
                          decoration: BoxDecoration(
                            color: GlossColors.green.withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Icon(Icons.check_circle_rounded, color: context.gloss.green, size: 30),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.serviceName.isNotEmpty ? widget.serviceName : 'Tozalash',
                                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: context.gloss.text),
                              ),
                              Text("Standart — 50 000 so'm", style: TextStyle(fontSize: 13, color: context.gloss.hint)),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildDetails(context),
                    const SizedBox(height: 16),
                    Divider(height: 1, color: context.gloss.divider),
                    const SizedBox(height: 16),
                    ...List.generate(_steps.length, (i) {
                      final isActive = i <= _currentStep;
                      final isCurrent = i == _currentStep;
                      return _buildTimelineItem(_steps[i], isActive, isCurrent, i == _steps.length - 1);
                    }),
                    const SizedBox(height: 16),
                    if (_currentStep == 0)
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: OutlinedButton.icon(
                          onPressed: () => _showCancelDialog(context),
                          icon: const Icon(Icons.close_rounded, size: 18),
                          label: const Text('Buyurtmani bekor qilish', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.red,
                            side: const BorderSide(color: Colors.red, width: 1.5),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          ),
                        ),
                      ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDetails(BuildContext context) {
    return Column(
      children: [
        _detailRow(Icons.calendar_today_rounded, 'Sana', '15.07.2026'),
        const SizedBox(height: 8),
        _detailRow(Icons.access_time_rounded, 'Vaqt', '10:00'),
        const SizedBox(height: 8),
        _detailRow(Icons.location_on_rounded, 'Manzil', 'Amir Temur ko\'ch., 100'),
        const SizedBox(height: 8),
        _detailRow(Icons.money_rounded, "To'lov", 'Naqt'),
      ],
    );
  }

  Widget _detailRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 16, color: GlossColors.green),
        const SizedBox(width: 8),
        SizedBox(width: 50, child: Text(label, style: TextStyle(fontSize: 13, color: context.gloss.hint))),
        Expanded(
          child: Text(value, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: context.gloss.text), maxLines: 1, overflow: TextOverflow.ellipsis),
        ),
      ],
    );
  }

  Widget _buildTimelineItem(_TrackingStep step, bool isActive, bool isCurrent, bool isLast) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 32,
            child: Column(
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(color: isActive ? GlossColors.green : GlossColors.border, shape: BoxShape.circle),
                  child: Icon(isActive ? Icons.check_rounded : step.icon, size: 14, color: Colors.white),
                ),
                if (!isLast) Expanded(child: Container(width: 2, color: isActive ? GlossColors.green : GlossColors.border)),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 24,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      step.title,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: isCurrent ? FontWeight.w700 : FontWeight.w500,
                        color: isActive ? GlossColors.text : GlossColors.disabled,
                      ),
                    ),
                  ),
                ),
                if (isCurrent)
                  Padding(
                    padding: const EdgeInsets.only(top: 2, bottom: 12),
                    child: Text(step.subtitle, style: TextStyle(fontSize: 12, color: context.gloss.hint)),
                  )
                else
                  const SizedBox(height: 12),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showCancelDialog(BuildContext context) {
    GlossDialog.show(
      context: context,
      title: 'Buyurtmani bekor qilish',
      content: 'Haqiqatan ham buyurtmani bekor qilmoqchisiz?',
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text("Yo'q", style: TextStyle(color: context.gloss.hint, fontWeight: FontWeight.w600)),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            Navigator.of(context).popUntil((r) => r.isFirst);
          },
          style: TextButton.styleFrom(foregroundColor: Colors.red),
          child: const Text('Ha, bekor qilish', style: TextStyle(fontWeight: FontWeight.w700)),
        ),
      ],
    );
  }
}

class _TrackingStep {
  final String title;
  final String subtitle;
  final IconData icon;
  const _TrackingStep(this.title, this.subtitle, this.icon);
}