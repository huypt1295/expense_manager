import 'package:flutter/material.dart';

/// Executes UI actions immediately while keeping access to [BuildContext]
/// scoped to the owning [State].
class UiActions {
  UiActions(this._state);

  final State _state;

  /// Whether the underlying state is still mounted.
  bool get mounted => _state.mounted;

  /// Runs a synchronous [action] using the state's context if it is mounted.
  void call(void Function(BuildContext ctx) action) {
    if (!_state.mounted) return;
    action(_state.context);
  }

  /// Shows a [SnackBar] via the nearest [ScaffoldMessenger].
  void showSnackBar(SnackBar bar) {
    if (!_state.mounted) return;
    ScaffoldMessenger.of(_state.context).showSnackBar(bar);
  }

  /// Displays a dialog safely using the stored context.
  Future<T?> showDialogSafe<T>({
    required WidgetBuilder builder,
    bool barrierDismissible = true,
  }) {
    if (!_state.mounted) return Future<T?>.value(null);
    return showDialog<T>(
      context: _state.context,
      barrierDismissible: barrierDismissible,
      builder: (_) => builder(_state.context),
    );
  }

  /// Executes navigation logic synchronously with the current context.
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
