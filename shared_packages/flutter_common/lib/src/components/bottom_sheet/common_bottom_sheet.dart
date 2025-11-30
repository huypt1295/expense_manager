import 'package:flutter/material.dart';
import 'package:flutter_common/flutter_common.dart';

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
    final mediaQuery = MediaQuery.of(context);
    final bottomInset = mediaQuery.viewInsets.bottom;
    final resolvedHeight =
        height ??
        (heightFactor != null ? mediaQuery.size.height * heightFactor! : null);

    return Padding(
      padding: EdgeInsets.only(bottom: bottomInset),
      child: Container(
        height: resolvedHeight,
        constraints: resolvedHeight == null
            ? BoxConstraints(maxHeight: mediaQuery.size.height * 0.8)
            : null,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: borderRadius,
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: resolvedHeight == null
                ? MainAxisSize.min
                : MainAxisSize.max,
            children: [
              if (showHeaderBar) _buildHeader(context),
              if (resolvedHeight != null)
                Expanded(child: child)
              else
                Flexible(child: SingleChildScrollView(child: child)),
            ],
          ),
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
                child: SizedBox(
                  width: 32,
                  height: 32,
                  child: Icon(Icons.close),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
