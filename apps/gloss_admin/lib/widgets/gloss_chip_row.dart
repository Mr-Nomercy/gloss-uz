import 'package:flutter/material.dart';
import 'package:ui_kit/ui_kit.dart';

class GlossChipRow extends StatelessWidget {
  final IconData icon;
  final String text;
  final double iconSize;
  final double textSize;

  const GlossChipRow({
    super.key,
    required this.icon,
    required this.text,
    this.iconSize = 14,
    this.textSize = 12,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.gloss;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: iconSize, color: theme.hint),
        SizedBox(width: iconSize <= 12 ? 3 : 4),
        Text(text, style: TextStyle(fontSize: textSize, color: theme.hint)),
      ],
    );
  }
}
