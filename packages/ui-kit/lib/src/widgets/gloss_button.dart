import 'package:flutter/material.dart';

class GlossButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isOutlined;
  final IconData? icon;
  final Widget? leading;

  const GlossButton({
    super.key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
    this.isOutlined = false,
    this.icon,
    this.leading,
  });

  @override
  Widget build(BuildContext context) {
    Widget content;
    if (isLoading) {
      content = const SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
      );
    } else {
      final iconWidget = leading ?? (icon != null ? Icon(icon, size: 20, color: Colors.white) : null);
      content = Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (iconWidget != null) ...[
            iconWidget,
            const SizedBox(width: 8),
          ],
          Text(label),
        ],
      );
    }

    if (isOutlined) {
      return OutlinedButton(
        onPressed: isLoading ? null : onPressed,
        child: content,
      );
    }
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        child: content,
      ),
    );
  }
}