import 'package:flutter/widgets.dart';
import 'effect_listener.dart';

/// Wraps a child widget with multiple effect listeners without nesting them
/// manually in the widget tree.
class EffectListenerMulti extends StatelessWidget {
  const EffectListenerMulti({
    super.key,
    required this.listeners,
    required this.child,
  });

  // Each entry is expected to be an `EffectListener<...>` widget.
  final List<Widget> listeners;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    Widget current = child;
    // Wrap the child with listeners from the end of the list to the start.
    for (final l in listeners.reversed) {
      current = _wrapWithListener(l, current);
    }
    return current;
  }

  /// Wraps the [child] with the given [listener] widget.
  ///
  /// This method handles the special case where the listener is an
  /// [EffectListener] by creating a new instance with the [child] injected.
  static Widget _wrapWithListener(Widget listener, Widget child) {
    // If it's an EffectListener, we need to clone it with the child
    if (listener is EffectListener) {
      // Use a dynamic approach since we don't know the generic types at runtime
      return _cloneEffectListenerWithChild(listener, child);
    }

    // For other widget types, just return them (shouldn't happen in practice)
    return listener;
  }

  /// Clones an EffectListener widget and injects the [child].
  static Widget _cloneEffectListenerWithChild(
    EffectListener listener,
    Widget child,
  ) {
    // Create a new EffectListener with the same properties but with the child injected
    return EffectListener(
      key: listener.key,
      listener: listener.listener,
      filter: listener.filter,
      cubit: listener.cubit,
      child: child,
    );
  }
}
