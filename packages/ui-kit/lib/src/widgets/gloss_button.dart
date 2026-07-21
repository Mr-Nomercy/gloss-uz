import 'package:flutter/material.dart';

class GlossButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isOutlined;
  final IconData? icon;
  final Widget? leading;
  final bool fitWidth;

  const GlossButton({
    super.key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
    this.isOutlined = false,
    this.icon,
    this.leading,
    this.fitWidth = true,
  });

  @override
  Widget build(BuildContext context) {
    Widget content;
    if (isLoading) {
      final progressColor = isOutlined ? Theme.of(context).colorScheme.onSurface : Colors.white;
      content = SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(strokeWidth: 2, color: progressColor),
      );
    } else {
      final iconColor = isOutlined ? Theme.of(context).colorScheme.onSurface : Colors.white;
      final iconWidget = leading ?? (icon != null ? Icon(icon, size: 20, color: iconColor) : null);
      content = Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (iconWidget != null) ...[
            Flexible(child: iconWidget),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Text(
              label,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
        ],
      );
    }

    final button = isOutlined
        ? OutlinedButton(
            onPressed: isLoading ? null : onPressed,
            child: content,
          )
        : ElevatedButton(
            onPressed: isLoading ? null : onPressed,
            child: content,
          );

    if (fitWidth) {
      return SizedBox(width: double.infinity, child: button);
    }
    return button;
  }
}