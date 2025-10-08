import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_common/src/utils/object_utils.dart';

/// Collection of helper methods for working with Flutter views and widgets.
class ViewUtils {
  ViewUtils._();

  /// Makes the private constructor reachable for test coverage.
  static void ensureInitializedForTesting() {
    ViewUtils._();
  }

  /// Displays an app-themed [SnackBar] with the provided [message].
  static void showAppSnackBar(
    BuildContext context,
    String message, {
    Duration? duration,
    Color? backgroundColor,
  }) {
    final messengerState = ScaffoldMessenger.maybeOf(context);
    if (messengerState == null) {
      return;
    }
    messengerState.hideCurrentSnackBar();
    messengerState.showSnackBar(
      SnackBar(
        content: Text(message),
        duration: duration ?? const Duration(seconds: 3),
        backgroundColor: backgroundColor,
      ),
    );
  }

  /// Dismisses the keyboard if a focus node currently holds focus.
  static void hideKeyboard(BuildContext context) {
    final currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
      FocusManager.instance.primaryFocus?.unfocus();
    }
  }

  /// Applies the allowed [orientations] to the current app session.
  static Future<void> setPreferredOrientations(List<DeviceOrientation> orientations) {
    return SystemChrome.setPreferredOrientations(orientations);
  }

  /// Sets the system UI overlay style such as status and navigation bar colors.
  static void setSystemUIOverlayStyle(SystemUiOverlayStyle systemUiOverlayStyle) {
    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
  }

  /// Returns the global position for the widget associated with [globalKey].
  static Offset? getWidgetPosition(GlobalKey globalKey) {
    return (globalKey.currentContext?.findRenderObject() as RenderBox?)
        ?.let((it) => it.localToGlobal(Offset.zero));
  }

  /// Returns the width for the widget associated with [globalKey].
  static double? getWidgetWidth(GlobalKey globalKey) {
    return (globalKey.currentContext?.findRenderObject() as RenderBox?)?.let((it) => it.size.width);
  }

  /// Returns the height for the widget associated with [globalKey].
  static double? getWidgetHeight(GlobalKey globalKey) {
    return (globalKey.currentContext?.findRenderObject() as RenderBox?)
        ?.let((it) => it.size.height);
  }
}
