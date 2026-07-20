import 'package:flutter/material.dart';
import 'gloss_button.dart';
import 'gloss_empty_state.dart';

class GlossErrorView extends StatelessWidget {
  final String? message;
  final VoidCallback? onRetry;

  const GlossErrorView({super.key, this.message, this.onRetry});

  factory GlossErrorView.connection({VoidCallback? onRetry}) => GlossErrorView(
        message: "Internetga ulanishda xatolik",
        onRetry: onRetry,
      );

  factory GlossErrorView.server({VoidCallback? onRetry}) => GlossErrorView(
        message: "Serverda xatolik, keyinroq urinib ko'ring",
        onRetry: onRetry,
      );

  @override
  Widget build(BuildContext context) {
    return GlossEmptyState(
      icon: Icons.error_outline_rounded,
      title: 'Xatolik yuz berdi',
      subtitle: message ?? "Noma'lum xatolik",
      action: onRetry != null
          ? GlossButton(
              label: "Qayta urinish", onPressed: onRetry, fitWidth: false)
          : null,
    );
  }
}
