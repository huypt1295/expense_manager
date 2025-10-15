import 'dart:math' as math;

import 'package:flutter/widgets.dart';

class CommonGridView extends StatelessWidget {
  const CommonGridView({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    this.crossAxisCount,
    this.maxCrossAxisCount = 3,
    this.mainAxisSpacing = 8,
    this.crossAxisSpacing = 8,
    this.childAspectRatio = 1,
    this.physics = const NeverScrollableScrollPhysics(),
    this.shrinkWrap = true,
    this.padding,
  });

  final int itemCount;
  final IndexedWidgetBuilder itemBuilder;
  final int? crossAxisCount;
  final int maxCrossAxisCount;
  final double mainAxisSpacing;
  final double crossAxisSpacing;
  final double childAspectRatio;
  final ScrollPhysics? physics;
  final bool shrinkWrap;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final int resolvedCrossAxisCount;

    if (crossAxisCount != null && crossAxisCount! > 0) {
      resolvedCrossAxisCount = crossAxisCount!;
    } else {
      final safeMaxCrossAxisCount = math.max(maxCrossAxisCount, 1);
      final effectiveItemCount = math.max(itemCount, 1);
      resolvedCrossAxisCount = math.min(effectiveItemCount, safeMaxCrossAxisCount);
    }

    return GridView.builder(
      padding: padding,
      shrinkWrap: shrinkWrap,
      physics: physics,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: resolvedCrossAxisCount,
        mainAxisSpacing: mainAxisSpacing,
        crossAxisSpacing: crossAxisSpacing,
        childAspectRatio: childAspectRatio,
      ),
      itemCount: itemCount,
      itemBuilder: itemBuilder,
    );
  }
}
