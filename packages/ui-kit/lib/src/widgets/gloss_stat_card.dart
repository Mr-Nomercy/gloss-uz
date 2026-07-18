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
    final theme = Theme.of(context).extension<GlossTheme>()!;
    final iconColor = color ?? theme.green;

    return GlossCard(
      padding: padding,
      onTap: onTap,
      child: Column(
        crossAxisAlignment: crossAxisAlignment,
        mainAxisAlignment: verticalAlignment,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: iconColor, size: iconSize),
          ),
          const SizedBox(height: 8),
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
            style: TextStyle(fontSize: 11, color: theme.hint),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}