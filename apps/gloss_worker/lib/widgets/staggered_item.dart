import 'package:flutter/material.dart';

class GlossStaggeredItem extends StatelessWidget {
  final int index;
  final AnimationController controller;
  final Widget child;
  final bool _tight;

  const GlossStaggeredItem({
    super.key,
    required this.index,
    required this.controller,
    required this.child,
  }) : _tight = false;

  const GlossStaggeredItem.tight({
    super.key,
    required this.index,
    required this.controller,
    required this.child,
  }) : _tight = true;

  @override
  Widget build(BuildContext context) {
    final endOffset = _tight ? 0.12 : 0.3;
    final beginClampMax = _tight ? 0.88 : 1.0;
    final endClampMin = _tight ? 0.12 : 0.0;

    final begin = (index * 0.12).clamp(0.0, beginClampMax);
    final end = (index * 0.12 + endOffset).clamp(endClampMin, 1.0);

    final animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: controller,
        curve: Interval(begin, end, curve: Curves.easeOutCubic),
      ),
    );
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Opacity(
          opacity: animation.value,
          child: Transform.translate(
            offset: Offset(0, 30 * (1 - animation.value)),
            child: child,
          ),
        );
      },
      child: child,
    );
  }
}
