import 'package:flutter/material.dart';

class GlossCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onTap;
  final Color? color;
  final double? elevation;
  final BorderSide? border;
  final double borderRadius;
  final Color? accentColor;

  const GlossCard({
    super.key,
    required this.child,
    this.padding,
    this.onTap,
    this.color,
    this.elevation,
    this.border,
    this.borderRadius = 16,
    this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    final defaultBgColor = accentColor != null ? accentColor!.withValues(alpha: 0.04) : null;
    final defaultBorder = accentColor != null ? BorderSide(color: accentColor!.withValues(alpha: 0.15), width: 1.5) : BorderSide.none;

    return Card(
      elevation: elevation ?? (accentColor != null ? 0 : 1),
      color: color ?? defaultBgColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        side: border ?? defaultBorder,
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(borderRadius),
        child: Padding(
          padding: padding ?? const EdgeInsets.all(16),
          child: child,
        ),
      ),
    );
  }
}
