import 'package:flutter/widgets.dart';
import 'package:flutter_core/flutter_core.dart';

/// Convenience widget combining a [BlocBuilder] with an [EffectBlocListener].
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
  final Widget Function(BuildContext context, S state) builder;
  final bool Function(S previous, S current)? buildWhen;
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
