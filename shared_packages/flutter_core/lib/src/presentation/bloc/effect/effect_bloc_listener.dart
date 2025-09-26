import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_core/src/presentation/bloc/effect/effect.dart' show Effect;
import 'package:flutter_core/src/presentation/bloc/effect/effect_provider.dart' show EffectsProvider;
import 'package:flutter_core/src/presentation/widgets/ui_actions.dart' show UiActions;

/// Signature for reacting to an emitted [Effect]. The provided [UiActions]
/// helper exposes synchronous UI operations without leaking the widget
/// context.
typedef EffectCallback<E extends Effect> = FutureOr<void> Function(
  E effect,
  UiActions ui,
);

/// Determines whether an [Effect] should be forwarded to the listener.
typedef EffectFilter<E extends Effect> = bool Function(E effect);

/// Listens to one-off [Effect] emissions from any [BlocBase] that also
/// implements [EffectsProvider].
class EffectBlocListener<S, E extends Effect, B extends BlocBase<S>>
    extends StatefulWidget {
  const EffectBlocListener({
    super.key,
    required this.listener,
    this.filter,
    this.child,
    this.bloc,
  });

  final Widget? child;
  final B? bloc;
  /// Handles one-off effects emitted by [bloc].
  final EffectCallback<E> listener;
  final EffectFilter<E>? filter;

  @override
  State<EffectBlocListener<S, E, B>> createState() =>
      _EffectBlocListenerState<S, E, B>();
}

class _EffectBlocListenerState<S, E extends Effect, B extends BlocBase<S>>
    extends State<EffectBlocListener<S, E, B>> {
  StreamSubscription<E>? _sub;
  B? _bloc;

  @override
  void initState() {
    super.initState();
    _subscribe();
  }

  @override
  void didUpdateWidget(covariant EffectBlocListener<S, E, B> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.bloc != widget.bloc) {
      _unsubscribe();
      _subscribe();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (widget.bloc == null) {
      final newBloc = context.read<B>();
      if (!identical(_bloc, newBloc)) {
        _unsubscribe();
        _bloc = newBloc;
        _listenTo(_bloc!);
      }
    }
  }

  void _subscribe() {
    _bloc = widget.bloc ?? context.read<B>();
    _listenTo(_bloc!);
  }

  void _listenTo(B bloc) {
    assert(
      bloc is EffectsProvider<E>,
      'EffectBlocListener requires the provided bloc to implement '
      'EffectsProvider<$E>. Use BaseCubit/BaseBloc (which mix in '
      'EffectEmitter) or provide your own implementation.',
    );
    final provider = bloc as EffectsProvider<E>;
    _sub = provider.effects.listen((event) {
      if (widget.filter == null || widget.filter!(event)) {
        widget.listener(event, UiActions(this));
      }
    });
  }

  void _unsubscribe() {
    _sub?.cancel();
    _sub = null;
  }

  @override
  void dispose() {
    _unsubscribe();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child ?? const SizedBox.shrink();
}
