import 'package:flutter/material.dart';

/// Executes UI actions synchronously while ensuring the underlying [State]
/// remains mounted.
///
/// The helper deliberately avoids exposing [BuildContext] outside the widget
/// tree, providing a safe bridge for listeners that react to bloc effects.
class UiActions {
  UiActions(this._state);
  final State _state;

  bool get mounted => _state.mounted;

  /// Executes a synchronous [action] using the current context, ignoring the
  /// call when the state is no longer mounted.
  void call(void Function(BuildContext ctx) action) {
    if (!_state.mounted) return;
    action(_state.context);
  }

  /// Displays a [SnackBar] using the owning state's [ScaffoldMessenger].
  void showSnackBar(SnackBar bar) {
    if (!_state.mounted) return;
    ScaffoldMessenger.of(_state.context).showSnackBar(bar);
  }

  /// Shows a dialog immediately using the state's context.
  Future<T?> showDialogSafe<T>({
    required WidgetBuilder builder,
    bool barrierDismissible = true,
  }) {
    if (!_state.mounted) return Future<T?>.value(null);
    return showDialog<T>(
      context: _state.context,
      barrierDismissible: barrierDismissible,
      builder: builder,
    );
  }

  /// Runs a synchronous navigation closure if the state is still mounted.
  void navigate(void Function(BuildContext ctx) go) {
    if (!_state.mounted) return;
    go(_state.context);
  }

  /// Attempts to pop the current route if possible.
  void maybePop() {
    if (!_state.mounted) return;
    Navigator.of(_state.context).maybePop();
  }
}
