import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

enum GlossBannerVariant { info, success, warning, error }

class GlossBanner extends StatelessWidget {
  final String message;
  final IconData? icon;
  final GlossBannerVariant variant;
  final VoidCallback? onAction;
  final String? actionLabel;
  final bool dismissible;
  final VoidCallback? onDismiss;

  const GlossBanner({
    super.key,
    required this.message,
    this.icon,
    this.variant = GlossBannerVariant.info,
    this.onAction,
    this.actionLabel,
    this.dismissible = false,
    this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.gloss;
    final config = _resolveVariant(theme, variant);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: config.bg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: config.border, width: 1),
      ),
      child: Row(
        children: [
          Icon(config.icon, color: config.fg, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: TextStyle(fontSize: 13, color: config.fg, height: 1.4),
            ),
          ),
          if (onAction != null && actionLabel != null) ...[
            const SizedBox(width: 8),
            TextButton(
              onPressed: onAction,
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                minimumSize: const Size(0, 32),
                foregroundColor: config.fg,
                textStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
              ),
              child: Text(actionLabel!),
            ),
          ],
          if (dismissible) ...[
            const SizedBox(width: 4),
            IconButton(
              onPressed: onDismiss,
              icon: Icon(Icons.close_rounded, size: 16, color: config.fg),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
              visualDensity: VisualDensity.compact,
            ),
          ],
        ],
      ),
    );
  }

  _BannerColors _resolveVariant(GlossTheme theme, GlossBannerVariant v) {
    switch (v) {
      case GlossBannerVariant.info:
        return _BannerColors(
          bg: theme.greenBgLight,
          border: theme.greenBorderLight,
          fg: theme.green,
          icon: icon ?? Icons.info_outline,
        );
      case GlossBannerVariant.success:
        return _BannerColors(
          bg: theme.greenBgLight,
          border: theme.green,
          fg: theme.green,
          icon: icon ?? Icons.check_circle_outline,
        );
      case GlossBannerVariant.warning:
        return _BannerColors(
          bg: theme.orangeBgLight,
          border: theme.orange.withValues(alpha: 0.40),
          fg: theme.orange,
          icon: icon ?? Icons.warning_amber_rounded,
        );
      case GlossBannerVariant.error:
        return _BannerColors(
          bg: theme.red.withValues(alpha: 0.08),
          border: theme.red.withValues(alpha: 0.30),
          fg: theme.red,
          icon: icon ?? Icons.error_outline,
        );
    }
  }
}

class _BannerColors {
  final Color bg;
  final Color border;
  final Color fg;
  final IconData icon;
  _BannerColors({required this.bg, required this.border, required this.fg, required this.icon});
}
