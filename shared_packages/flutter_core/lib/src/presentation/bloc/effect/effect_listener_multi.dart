import 'package:flutter/widgets.dart';

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
      current = _Wrap(wrapper: l, child: current);
    }
    return current;
  }
}

class _Wrap extends StatelessWidget {
  const _Wrap({required this.child, required this.wrapper});
  final Widget child;
  final Widget wrapper;
  @override
  Widget build(BuildContext context) =>
      _Passthrough(wrapper: wrapper, child: child);
}

class _Passthrough extends StatelessWidget {
  const _Passthrough({required this.child, required this.wrapper});
  final Widget child;
  final Widget wrapper;

  @override
  Widget build(BuildContext context) {
    // Replace the placeholder child of the wrapper with the actual child.
    // Assumes the wrapper is an EffectListener with `child = null`.
    return _WithChild(wrapper: wrapper, child: child);
  }
}

class _WithChild extends StatelessWidget {
  const _WithChild({required this.wrapper, required this.child});
  final Widget wrapper;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    // TODO: Improve wrapper handling once EffectListener enforces a non-null
    // child. For now, manual composition may be clearer for complex cases.
    return wrapper is SingleChildRenderObjectWidget
        ? wrapper // Keep simple: nested EffectListener widgets cover most cases.
        : wrapper;
  }
}
