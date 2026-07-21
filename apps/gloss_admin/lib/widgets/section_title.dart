import 'package:flutter/material.dart';
import 'package:ui_kit/ui_kit.dart';

class GlossSectionTitle extends StatelessWidget {
  final String title;
  const GlossSectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 17,
        fontWeight: FontWeight.w700,
        color: GlossColors.text,
      ),
    );
  }
}
