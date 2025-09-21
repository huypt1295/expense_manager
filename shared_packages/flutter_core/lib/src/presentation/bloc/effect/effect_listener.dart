import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:flutter_core/flutter_core.dart';

/// Lắng nghe one-shot effects từ một Cubit/Bloc cụ thể.
/// - Không rebuild UI (giống BlocListener)
/// - Có thể lọc effect bằng [filter]
class EffectListener<C extends BaseCubit<dynamic, E>, E extends Effect>
    extends StatefulWidget {
  const EffectListener({
    super.key,
    required this.listener,
    this.filter,
    this.child,
    this.cubit, // optional: nếu không truyền sẽ lấy từ context.read<C>()
  });

  final Widget? child;
  final C? cubit;
  final EffectCallback<E> listener;
  final EffectFilter<E>? filter;

  @override
  State<EffectListener<C, E>> createState() => _EffectListenerState<C, E>();
}

class _EffectListenerState<C extends BaseCubit<dynamic, E>, E extends Effect>
    extends State<EffectListener<C, E>> {
  StreamSubscription<E>? _sub;
  C? _cubit;

  @override
  void initState() {
    super.initState();
    _subscribe();
  }

  @override
  void didUpdateWidget(covariant EffectListener<C, E> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.cubit != widget.cubit) {
      _unsubscribe();
      _subscribe();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Nếu không truyền cubit thì lấy từ context; khi tree đổi cần re-subscribe
    if (widget.cubit == null) {
      final newCubit = context.read<C>();
      if (!identical(_cubit, newCubit)) {
        _unsubscribe();
        _cubit = newCubit;
        _listenTo(_cubit!);
      }
    }
  }

  void _subscribe() {
    _cubit = widget.cubit ?? context.read<C>();
    _listenTo(_cubit!);
  }

  void _listenTo(C cubit) {
    _sub = cubit.effects.listen((event) {
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
