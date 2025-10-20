import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_common/flutter_common.dart';
import 'package:flutter_resource/l10n/gen/l10n.dart';

class CommonBottomSheet extends StatelessWidget {
  const CommonBottomSheet({
    super.key,
    required this.child,
    required this.title,
    this.height,
    this.heightFactor,
    this.backgroundColor = Colors.white,
    this.borderRadius = const BorderRadius.only(
      topLeft: Radius.circular(20),
      topRight: Radius.circular(20),
    ),
    this.showHeaderBar = true,
  }) : assert(
         height == null || heightFactor == null,
         'Provide either height or heightFactor, not both.',
       );

  final Widget child;
  final String title;
  final double? height;
  final double? heightFactor;
  final Color backgroundColor;
  final BorderRadius borderRadius;
  final bool showHeaderBar;

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    final resolvedHeight =
        height ??
        (heightFactor != null
            ? MediaQuery.of(context).size.height * heightFactor!
            : null);

    return Padding(
      padding: EdgeInsets.only(bottom: bottomInset),
      child: Container(
        height: resolvedHeight,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: borderRadius,
        ),
        child: Column(
          mainAxisSize: resolvedHeight == null
              ? MainAxisSize.min
              : MainAxisSize.max,
          children: [
            if (showHeaderBar) _buildHeader(context),
            Expanded(child: child),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0).copyWith(top: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),

          ClipOval(
            child: Material(
              color: context.tpColors.surfaceSub, // Button color
              child: InkWell(
                splashColor: context.tpColors.surfaceMain, // Splash color
                onTap: () => Navigator.of(context).pop(),
                child: SizedBox(width: 32, height: 32, child: Icon(Icons.close)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
