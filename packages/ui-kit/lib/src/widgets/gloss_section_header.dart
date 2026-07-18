import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class GlossSectionHeader extends StatelessWidget {
  final String title;
  final EdgeInsetsGeometry padding;
  final Widget? trailing;
  final Color? color;

  const GlossSectionHeader({
    super.key,
    required this.title,
    this.padding = const EdgeInsets.fromLTRB(16, 16, 16, 8),
    this.trailing,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<GlossTheme>()!;
    return Padding(
      padding: padding,
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: color ?? theme.hint,
              ),
            ),
          ),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}
