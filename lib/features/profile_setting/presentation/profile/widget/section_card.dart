import 'package:flutter/material.dart';
import 'package:flutter_common/flutter_common.dart';

class SectionCard extends StatelessWidget {
  const SectionCard({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: context.tpColors.surfaceMain,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: context.tpColors.borderDefault),
        boxShadow: [
          BoxShadow(
            color: _colorWithOpacity(context.tpColors.shadowMain, 0.12),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: child,
    );
  }
}

Color _colorWithOpacity(Color color, double opacity) {
  final double alpha = (color.a * opacity).clamp(0.0, 1.0);
  return color.withValues(alpha: alpha);
}
