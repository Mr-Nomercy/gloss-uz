import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'gloss_card.dart';

class GlossStatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color? color;
  final double iconSize;
  final double valueFontSize;
  final EdgeInsetsGeometry padding;
  final String? suffix;
  final VoidCallback? onTap;
  final CrossAxisAlignment crossAxisAlignment;
  final MainAxisAlignment verticalAlignment;

  const GlossStatCard({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    this.color,
    this.iconSize = 18,
    this.valueFontSize = 20,
    this.padding = const EdgeInsets.all(16),
    this.suffix,
    this.onTap,
    this.crossAxisAlignment = CrossAxisAlignment.start,
    this.verticalAlignment = MainAxisAlignment.center,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.gloss;
    final iconColor = color ?? theme.green;
    final bgColor = iconColor.withValues(alpha: 0.06);
    final borderColor = iconColor.withValues(alpha: 0.15);

    return GlossCard(
      padding: padding,
      onTap: onTap,
      color: bgColor,
      elevation: 0,
      border: BorderSide(color: borderColor, width: 1.5),
      child: Column(
        crossAxisAlignment: crossAxisAlignment,
        mainAxisAlignment: verticalAlignment,
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: iconColor,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: iconColor.withValues(alpha: 0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                )
              ]
            ),
            child: Icon(icon, color: Colors.white, size: iconSize),
          ),
          const SizedBox(height: 12),
          Text(
            '$value${suffix ?? ''}',
            style: TextStyle(
              fontSize: valueFontSize,
              fontWeight: FontWeight.bold,
              color: theme.text,
            ),
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(fontSize: 12, color: theme.text.withValues(alpha: 0.6), fontWeight: FontWeight.w500),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}