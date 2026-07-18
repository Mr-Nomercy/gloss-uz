import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class GlossSnackBar {
  GlossSnackBar._();

  static void show({
    required BuildContext context,
    required String message,
    SnackBarType type = SnackBarType.success,
    Duration duration = const Duration(seconds: 3),
    VoidCallback? onActionPressed,
    String? actionLabel,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(_iconForType(type), color: Colors.white, size: 20),
            const SizedBox(width: 12),
            Expanded(child: Text(message, style: const TextStyle(color: Colors.white))),
          ],
        ),
        backgroundColor: _colorForType(type),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        duration: duration,
        action: onActionPressed != null && actionLabel != null
            ? SnackBarAction(
                label: actionLabel,
                textColor: Colors.white,
                onPressed: onActionPressed,
              )
            : null,
      ),
    );
  }

  static void showSuccess(BuildContext context, String message, {Duration? duration}) {
    show(context: context, message: message, type: SnackBarType.success, duration: duration ?? const Duration(seconds: 3));
  }

  static void showError(BuildContext context, String message, {Duration? duration}) {
    show(context: context, message: message, type: SnackBarType.error, duration: duration ?? const Duration(seconds: 4));
  }

  static void showWarning(BuildContext context, String message, {Duration? duration}) {
    show(context: context, message: message, type: SnackBarType.warning, duration: duration ?? const Duration(seconds: 4));
  }

  static void showInfo(BuildContext context, String message, {Duration? duration}) {
    show(context: context, message: message, type: SnackBarType.info, duration: duration ?? const Duration(seconds: 3));
  }

  static IconData _iconForType(SnackBarType type) {
    switch (type) {
      case SnackBarType.success:
        return Icons.check_circle_rounded;
      case SnackBarType.error:
        return Icons.error_rounded;
      case SnackBarType.warning:
        return Icons.warning_amber_rounded;
      case SnackBarType.info:
        return Icons.info_rounded;
    }
  }

  static Color _colorForType(SnackBarType type) {
    switch (type) {
      case SnackBarType.success:
        return GlossColors.green;
      case SnackBarType.error:
        return GlossColors.red;
      case SnackBarType.warning:
        return GlossColors.orange;
      case SnackBarType.info:
        return GlossColors.greenText;
    }
  }
}

enum SnackBarType { success, error, warning, info }