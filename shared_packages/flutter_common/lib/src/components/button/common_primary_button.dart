import 'package:flutter/material.dart';

class CommonPrimaryButton extends StatelessWidget {
  const CommonPrimaryButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.isLoading = false,
    this.padding = const EdgeInsets.symmetric(horizontal: 16),
    this.height = 48,
    this.loadingIndicator,
    this.backgroundColor,
    this.buttonStyle,
  });

  final VoidCallback? onPressed;
  final Widget child;
  final bool isLoading;
  final EdgeInsetsGeometry padding;
  final double height;
  final Widget? loadingIndicator;
  final Color? backgroundColor;
  final ButtonStyle? buttonStyle;

  @override
  Widget build(BuildContext context) {
    final resolvedStyle =
        ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          )
          .copyWith(
            backgroundColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.pressed)) {
                return backgroundColor?.withOpacity(0.5);
              }
              return backgroundColor;
            }),
          ).merge(buttonStyle);

    return Padding(
      padding: padding,
      child: SizedBox(
        height: height,
        width: double.infinity,
        child: ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          style: resolvedStyle,
          child: isLoading
              ? loadingIndicator ?? const CircularProgressIndicator()
              : child,
        ),
      ),
    );
  }
}
