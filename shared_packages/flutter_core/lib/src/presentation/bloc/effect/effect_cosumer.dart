import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_core/flutter_core.dart' show EffectCallback, EffectFilter;
import 'package:flutter_core/src/presentation/bloc/base_cubit.dart';
import 'package:flutter_core/src/presentation/bloc/effect/effect.dart' show Effect;
import 'effect_listener.dart';

class EffectConsumer<C extends BaseCubit<S, E>, S, E extends Effect>
    extends StatelessWidget {
  const EffectConsumer({
    super.key,
    required this.builder,
    required this.listener,
    this.buildWhen,
    this.filter,
    this.cubit,
  });

  final C? cubit;
  final Widget Function(BuildContext context, S state) builder;
  final bool Function(S previous, S current)? buildWhen;
  final EffectCallback<E> listener;
  final EffectFilter<E>? filter;

  @override
  Widget build(BuildContext context) {
    return EffectListener<C, E>(
      cubit: cubit,
      listener: listener,
      filter: filter,
      child: BlocBuilder<C, S>(
        buildWhen: buildWhen,
        builder: builder,
      ),
    );
  }
}
