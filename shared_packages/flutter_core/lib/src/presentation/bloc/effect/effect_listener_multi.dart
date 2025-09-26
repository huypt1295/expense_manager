import 'package:flutter/widgets.dart';

/// Utility widget that nests multiple effect listeners around a single child.
class EffectListenerMulti extends StatelessWidget {
  const EffectListenerMulti({
    super.key,
    required this.listeners,
    required this.child,
  });

  /// Widgets that wrap [child] to listen to different effect sources.
  final List<Widget> listeners;

  /// Widget rendered at the core of the nested listeners.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    Widget current = child;
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
    return _WithChild(wrapper: wrapper, child: child);
  }
}

class _WithChild extends StatelessWidget {
  const _WithChild({required this.wrapper, required this.child});
  final Widget wrapper;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return wrapper is SingleChildRenderObjectWidget
        ? wrapper
        : wrapper;
  }
}
