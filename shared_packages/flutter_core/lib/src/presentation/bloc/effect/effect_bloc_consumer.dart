import 'package:flutter/widgets.dart';
import 'package:flutter_core/flutter_core.dart';

/// Combines [BlocBuilder] with [EffectBlocListener] so a widget can react to
/// both state updates and one-off [Effect] emissions from the same bloc.
class EffectBlocConsumer<S, E extends Effect, B extends BlocBase<S>>
    extends StatelessWidget {
  const EffectBlocConsumer({
    super.key,
    required this.builder,
    required this.listener,
    this.buildWhen,
    this.filter,
    this.bloc,
  });

  final B? bloc;
  /// Builds the UI in response to state changes emitted by [bloc].
  final Widget Function(BuildContext context, S state) builder;
  final bool Function(S previous, S current)? buildWhen;
  /// Handles one-off effects emitted by [bloc].
  final EffectCallback<E> listener;
  final EffectFilter<E>? filter;

  @override
  Widget build(BuildContext context) {
    return EffectBlocListener<S, E, B>(
      bloc: bloc,
      listener: listener,
      filter: filter,
      child: BlocBuilder<B, S>(
        buildWhen: buildWhen,
        builder: builder,
      ),
    );
  }
}
