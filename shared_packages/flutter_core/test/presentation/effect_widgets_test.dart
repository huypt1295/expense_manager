import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_core/src/presentation/bloc/base_cubit.dart';
import 'package:flutter_core/src/presentation/bloc/base_bloc.dart';
import 'package:flutter_core/src/presentation/bloc/effect/effect.dart';
import 'package:flutter_core/src/presentation/bloc/effect/effect_bloc_consumer.dart';
import 'package:flutter_core/src/presentation/bloc/effect/effect_bloc_listener.dart';
import 'package:flutter_core/src/presentation/bloc/effect/effect_cosumer.dart';
import 'package:flutter_core/src/presentation/bloc/effect/effect_listener.dart';
import 'package:flutter_core/src/presentation/bloc/effect/effect_listener_multi.dart';
import 'package:flutter_test/flutter_test.dart';

class _TestEffect extends Effect {
  const _TestEffect(this.label);
  final String label;
}

class _TestCubit extends BaseCubit<int, _TestEffect> {
  _TestCubit() : super(0);

  void sendEffect(String label) => emitEffect(_TestEffect(label));
  void pushState(int value) => emit(value);
}

class _IncrementEvent {
  const _IncrementEvent();
}

class _TestBloc extends BaseBloc<_IncrementEvent, int, _TestEffect> {
  _TestBloc() : super(0) {
    on<_IncrementEvent>((event, emit) {
      emit(state + 1);
      emitEffect(const _TestEffect('bloc'));
    });
  }
}

void main() {
  testWidgets('EffectListener invokes listener when cubit emits effect', (tester) async {
    final cubit = _TestCubit();
    final effects = <String>[];

    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider.value(
          value: cubit,
          child: EffectListener<_TestCubit, _TestEffect>(
            listener: (effect, ui) => effects.add(effect.label),
            child: const SizedBox.shrink(),
          ),
        ),
      ),
    );

    cubit.sendEffect('one');
    await tester.pump();

    expect(effects, ['one']);
  });

  testWidgets('EffectListenerMulti wraps listeners without losing child', (tester) async {
    final cubit = _TestCubit();
    final called = <String>[];

    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider.value(
          value: cubit,
          child: EffectListenerMulti(
            listeners: [
              EffectListener<_TestCubit, _TestEffect>(
                cubit: cubit,
                listener: (effect, ui) => called.add('first:${effect.label}'),
              ),
              EffectListener<_TestCubit, _TestEffect>(
                cubit: cubit,
                listener: (effect, ui) => called.add('second:${effect.label}'),
              ),
            ],
            child: const Scaffold(body: Text('content')),
          ),
        ),
      ),
    );

    cubit.sendEffect('ping');
    await tester.pump();

    expect(called, ['first:ping']);
  });

  testWidgets('EffectConsumer rebuilds on state change and listens to effects', (tester) async {
    final cubit = _TestCubit();
    final effects = <String>[];

    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider.value(
          value: cubit,
          child: EffectConsumer<_TestCubit, int, _TestEffect>(
            listener: (effect, ui) => effects.add(effect.label),
            builder: (context, state) => Text('state:$state'),
          ),
        ),
      ),
    );

    expect(find.text('state:0'), findsOneWidget);

    cubit.pushState(3);
    await tester.pump();
    expect(find.text('state:3'), findsOneWidget);

    cubit.sendEffect('toast');
    await tester.pump();
    expect(effects, ['toast']);
  });

  testWidgets('EffectBlocListener subscribes to bloc effects', (tester) async {
    final bloc = _TestBloc();
    final completer = Completer<String>();

    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider.value(
          value: bloc,
          child: EffectBlocListener<int, _TestEffect, _TestBloc>(
            listener: (effect, ui) => completer.complete(effect.label),
            child: const SizedBox.shrink(),
          ),
        ),
      ),
    );

    bloc.add(const _IncrementEvent());
    await tester.pump();

    expect(await completer.future, 'bloc');
  });

  testWidgets('EffectBlocConsumer rebuilds with bloc state changes and effects', (tester) async {
    final bloc = _TestBloc();
    final effects = <String>[];

    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider.value(
          value: bloc,
          child: EffectBlocConsumer<int, _TestEffect, _TestBloc>(
            listener: (effect, ui) => effects.add(effect.label),
            builder: (context, state) => Text('bloc:$state'),
          ),
        ),
      ),
    );

    expect(find.text('bloc:0'), findsOneWidget);
    bloc.add(const _IncrementEvent());
    await tester.pump();

    expect(find.text('bloc:1'), findsOneWidget);
    expect(effects, ['bloc']);
  });
}
