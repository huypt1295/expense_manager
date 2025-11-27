import 'package:flutter/material.dart';
import 'package:flutter_common/src/utils/context_utils.dart';

/// A customized popup menu button with predefined styling.
///
/// This widget wraps [PopupMenuButton] with custom default values for
/// color and shape that match the app's design system.
///
/// Example usage:
/// ```dart
/// CommonPopupMenu<String>(
///   itemBuilder: (context) => [
///     PopupMenuItem(
///       value: 'edit',
///       child: Text('Edit'),
///     ),
///     PopupMenuItem(
///       value: 'delete',
///       child: Text('Delete'),
///     ),
///   ],
///   onSelected: (value) {
///     print('Selected: $value');
///   },
/// )
/// ```
class CommonPopupMenu<T> extends StatelessWidget {
  /// Creates a common popup menu button.
  const CommonPopupMenu({
    super.key,
    required this.itemBuilder,
    this.initialValue,
    this.onOpened,
    this.onSelected,
    this.onCanceled,
    this.tooltip,
    this.elevation,
    this.shadowColor,
    this.surfaceTintColor,
    this.padding = const EdgeInsets.all(8.0),
    this.menuPadding,
    this.child,
    this.borderRadius,
    this.splashRadius,
    this.icon,
    this.iconSize,
    this.offset = Offset.zero,
    this.enabled = true,
    this.shape,
    this.color,
    this.iconColor,
    this.enableFeedback,
    this.constraints,
    this.position,
    this.clipBehavior = Clip.none,
    this.useRootNavigator = false,
    this.popUpAnimationStyle,
    this.routeSettings,
    this.style,
    this.requestFocus,
  });

  /// Called when the button is pressed to create the items to show in the menu.
  final PopupMenuItemBuilder<T> itemBuilder;

  /// The value of the menu item, if any, that should be highlighted when the menu opens.
  final T? initialValue;

  /// Called when the popup menu is shown.
  final VoidCallback? onOpened;

  /// Called when the user selects a value from the popup menu.
  final PopupMenuItemSelected<T>? onSelected;

  /// Called when the user dismisses the popup menu without selecting an item.
  final PopupMenuCanceled? onCanceled;

  /// Text that describes the action that will occur when the button is pressed.
  final String? tooltip;

  /// The z-coordinate at which to place the menu when open.
  final double? elevation;

  /// The color used to paint the shadow below the menu.
  final Color? shadowColor;

  /// The color used as an overlay on [color] to indicate elevation.
  final Color? surfaceTintColor;

  /// The padding around the button.
  final EdgeInsetsGeometry padding;

  /// The padding around the menu items.
  final EdgeInsetsGeometry? menuPadding;

  /// The splash radius for the button.
  final double? splashRadius;

  /// If provided, [child] is the widget used for this button.
  final Widget? child;

  /// The border radius for the InkWell that wraps the [child].
  final BorderRadius? borderRadius;

  /// If provided, the [icon] is used for this button.
  final Widget? icon;

  /// The offset applied relative to the initial position.
  final Offset offset;

  /// Whether this popup menu button is interactive.
  final bool enabled;

  /// The shape used for the menu.
  ///
  /// If null, defaults to a rounded rectangle with 16px radius and a border.
  final ShapeBorder? shape;

  /// The background color used for the menu.
  ///
  /// If null, defaults to `context.tpColors.surfaceMain`.
  final Color? color;

  /// The color used for the button icon.
  final Color? iconColor;

  /// Whether detected gestures should provide acoustic and/or haptic feedback.
  final bool? enableFeedback;

  /// The size of the icon.
  final double? iconSize;

  /// Optional size constraints for the menu.
  final BoxConstraints? constraints;

  /// Whether the popup menu is positioned over or under the popup menu button.
  final PopupMenuPosition? position;

  /// The clip behavior for the menu.
  final Clip clipBehavior;

  /// Whether to push the menu to the root navigator.
  final bool useRootNavigator;

  /// Custom animation style for the popup menu.
  final AnimationStyle? popUpAnimationStyle;

  /// Optional route settings for the menu.
  final RouteSettings? routeSettings;

  /// Customizes the button's appearance (for IconButton style).
  final ButtonStyle? style;

  /// Whether to request focus when the menu appears.
  final bool? requestFocus;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<T>(
      itemBuilder: itemBuilder,
      initialValue: initialValue,
      onOpened: onOpened,
      onSelected: onSelected,
      onCanceled: onCanceled,
      tooltip: tooltip,
      elevation: elevation,
      shadowColor: shadowColor,
      surfaceTintColor: surfaceTintColor,
      padding: padding,
      menuPadding: menuPadding,
      borderRadius: borderRadius,
      splashRadius: splashRadius,
      icon: icon,
      iconSize: iconSize,
      offset: offset,
      enabled: enabled,
      // Custom shape with 16px border radius and border
      shape: shape ??
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(
              color: context.tpColors.borderDefault,
              width: 1,
            ),
          ),
      // Custom color
      // Replace with: color: color ?? context.tpColors.surfaceMain
      color: color ?? Theme.of(context).cardColor,
      iconColor: iconColor,
      enableFeedback: enableFeedback,
      constraints: constraints,
      position: position,
      clipBehavior: clipBehavior,
      useRootNavigator: useRootNavigator,
      popUpAnimationStyle: popUpAnimationStyle,
      routeSettings: routeSettings,
      style: style,
      requestFocus: requestFocus,
      child: child,
    );
  }
}