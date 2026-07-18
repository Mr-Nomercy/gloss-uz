import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class GlossMenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final bool destructive;
  final VoidCallback? onTap;
  final bool showDivider;
  final Color? iconColor;

  const GlossMenuItem({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.trailing,
    this.destructive = false,
    this.onTap,
    this.showDivider = false,
    this.iconColor,
  });

  factory GlossMenuItem.destructive({
    Key? key,
    required IconData icon,
    required String title,
    String? subtitle,
    Widget? trailing,
    VoidCallback? onTap,
    bool showDivider = false,
  }) {
    return GlossMenuItem(
      key: key,
      icon: icon,
      title: title,
      subtitle: subtitle,
      trailing: trailing,
      onTap: onTap,
      showDivider: showDivider,
      destructive: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<GlossTheme>()!;
    final accentColor = iconColor ?? (destructive ? theme.red : theme.green);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                Icon(icon, color: accentColor, size: 22),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: destructive ? theme.red : theme.text,
                        ),
                      ),
                      if (subtitle != null) ...[
                        const SizedBox(height: 2),
                        Text(
                          subtitle!,
                          style: TextStyle(fontSize: 12, color: theme.hint),
                        ),
                      ],
                    ],
                  ),
                ),
                if (trailing != null) trailing!,
                if (trailing == null && onTap != null)
                  Icon(Icons.chevron_right, color: theme.hint, size: 20),
              ],
            ),
          ),
        ),
        if (showDivider)
          Divider(height: 1, indent: 52, endIndent: 16, color: theme.divider),
      ],
    );
  }
}
