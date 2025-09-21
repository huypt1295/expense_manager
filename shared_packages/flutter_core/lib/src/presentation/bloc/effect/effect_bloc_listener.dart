import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_core/src/presentation/bloc/effect/effect.dart' show Effect;
import 'package:flutter_core/src/presentation/bloc/effect/effect_provider.dart' show EffectsProvider;
import 'package:flutter_core/src/presentation/widgets/ui_actions.dart' show UiActions;

typedef EffectCallback<E extends Effect> = FutureOr<void> Function(
    E effect,
    UiActions ui,
    );

typedef EffectFilter<E extends Effect> = bool Function(E effect);

/// Lắng nghe one-shot effects từ bất kỳ BlocBase<S> nào (Cubit hoặc Bloc),
/// miễn là nó cũng implement EffectsProvider<E>.
class EffectBlocListener<S, E extends Effect, B extends BlocBase<S>>
    extends StatefulWidget {
  const EffectBlocListener({
    super.key,
    required this.listener,
    this.filter,
    this.child,
    this.bloc, // optional: nếu không truyền, lấy từ context.read<B>()
  });

  final Widget? child;
  final B? bloc;
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
    'EffectBlocListener: bloc phải implement EffectsProvider<$E>. '
        'Hãy dùng BaseCubit/BaseBloc (mixin EffectEmitter) hoặc tự implement EffectsProvider.',
    );
    final provider = bloc as EffectsProvider<E>;
    _sub = provider.effects.listen((event) {
      // Không chuyển context; thay bằng UiActions(this) để thi hành tức thời.
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
