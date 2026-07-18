import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

enum BadgeVariant { success, warning, error, info, neutral }

class GlossBadge extends StatelessWidget {
  final String label;
  final BadgeVariant variant;
  final double? fontSize;
  final EdgeInsetsGeometry? padding;

  const GlossBadge({
    super.key,
    required this.label,
    this.variant = BadgeVariant.neutral,
    this.fontSize,
    this.padding,
  });

  factory GlossBadge.status(String status) {
    final normalized = status.toLowerCase();
    BadgeVariant variant;
    if (['completed', 'delivered', 'finished', 'done', 'yagona', 'tugallangan', 'yetkazilgan'].contains(normalized)) {
      variant = BadgeVariant.success;
    } else if (['in_progress', 'processing', 'active', 'jarayonda', 'faol'].contains(normalized)) {
      variant = BadgeVariant.warning;
    } else if (['cancelled', 'rejected', 'bekor', 'bekor_qilingan'].contains(normalized)) {
      variant = BadgeVariant.error;
    } else if (['pending', 'new', 'waiting', 'yangi', 'kutilmoqda'].contains(normalized)) {
      variant = BadgeVariant.info;
    } else {
      variant = BadgeVariant.neutral;
    }
    return GlossBadge(label: status, variant: variant);
  }

  @override
  Widget build(BuildContext context) {
    final colors = _variantColors(variant);
    return Container(
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: colors.bg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: colors.text,
          fontSize: fontSize ?? 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  _BadgeColors _variantColors(BadgeVariant v) {
    switch (v) {
      case BadgeVariant.success:
        return _BadgeColors(
          bg: GlossColors.greenBgLight,
          text: GlossColors.green,
        );
      case BadgeVariant.warning:
        return _BadgeColors(
          bg: GlossColors.orangeBgLight,
          text: GlossColors.orange,
        );
      case BadgeVariant.error:
        return _BadgeColors(
          bg: GlossColors.red.withValues(alpha: 0.1),
          text: GlossColors.red,
        );
      case BadgeVariant.info:
        return _BadgeColors(
          bg: GlossColors.greenBgLight,
          text: GlossColors.green,
        );
      case BadgeVariant.neutral:
        return _BadgeColors(
          bg: GlossColors.grayLight,
          text: GlossColors.hint,
        );
    }
  }
}

class _BadgeColors {
  final Color bg;
  final Color text;
  _BadgeColors({required this.bg, required this.text});
}