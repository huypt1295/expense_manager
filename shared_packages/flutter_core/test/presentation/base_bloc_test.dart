import 'dart:async';

import 'package:flutter_core/src/foundation/failure.dart';
import 'package:flutter_core/src/foundation/logging/logger.dart';
import 'package:flutter_core/src/foundation/result.dart';
import 'package:flutter_core/src/presentation/bloc/base_bloc.dart';
import 'package:flutter_core/src/presentation/bloc/effect/effect.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeLogger extends Logger {
  final List<(LogLevel level, String event, Map<String, Object?> ctx)> entries =
      [];

  @override
  void log(LogLevel level, String event, Map<String, Object?> ctx) {
    entries.add((level, event, ctx));
  }
}

class _TestEffect extends Effect {
  const _TestEffect(this.label);
  final String label;
}

sealed class _Event {}

class _RunEvent extends _Event {
  _RunEvent({
    required this.task,
    this.onStart,
    this.onFinally,
    this.onOk,
    this.onErr,
    this.toErrorEffect,
    this.spanName,
    this.trackKey = 'default',
    required this.completer,
  });

  final Future<Result<int>> Function() task;
  final int Function(int state)? onStart;
  final int Function(int state)? onFinally;
  final int Function(int state, int value)? onOk;
  final void Function(int state, Failure f)? onErr;
  final _TestEffect Function(Failure f)? toErrorEffect;
  final String? spanName;
  final Object trackKey;
  final Completer<void> completer;
}

class _ReduceEvent extends _Event {
  _ReduceEvent({
    required this.result,
    this.onOk,
    this.onErr,
    this.toErrorEffect,
    required this.completer,
  });

  final Result<int> result;
  final int Function(int state, int value)? onOk;
  final void Function(int state, Failure f)? onErr;
  final _TestEffect Function(Failure f)? toErrorEffect;
  final Completer<void> completer;
}

class _TestBloc extends BaseBloc<_Event, int, _TestEffect> {
  _TestBloc({Logger? logger}) : super(0, logger: logger) {
    on<_RunEvent>((event, emit) async {
      await runResult(
        emit: emit,
        task: event.task,
        onStart: event.onStart,
        onFinally: event.onFinally,
        onOk: event.onOk,
        onErr: event.onErr,
        toErrorEffect: event.toErrorEffect,
        spanName: event.spanName,
        trackKey: event.trackKey,
      );
      event.completer.complete();
    });

    on<_ReduceEvent>((event, emit) {
      reduceResult(
        emit: emit,
        result: event.result,
        onOk: event.onOk,
        onErr: event.onErr,
        toErrorEffect: event.toErrorEffect,
      );
      event.completer.complete();
    });
  }

  Stream<int> mapEventToState(_Event event) => const Stream<int>.empty();

  Future<void> runTask({
    required Future<Result<int>> Function() task,
    int Function(int state)? onStart,
    int Function(int state)? onFinally,
    int Function(int state, int value)? onOk,
    void Function(int state, Failure f)? onErr,
    _TestEffect Function(Failure f)? toErrorEffect,
    String? spanName,
    Object trackKey = 'default',
  }) {
    final completer = Completer<void>();
    add(
      _RunEvent(
        task: task,
        onStart: onStart,
        onFinally: onFinally,
        onOk: onOk,
        onErr: onErr,
        toErrorEffect: toErrorEffect,
        spanName: spanName,
        trackKey: trackKey,
        completer: completer,
      ),
    );
    return completer.future;
  }

  Future<void> applyResult(
    Result<int> result, {
    int Function(int state, int value)? onOk,
    void Function(int state, Failure f)? onErr,
    _TestEffect Function(Failure f)? toErrorEffect,
  }) {
    final completer = Completer<void>();
    add(
      _ReduceEvent(
        result: result,
        onOk: onOk,
        onErr: onErr,
        toErrorEffect: toErrorEffect,
        completer: completer,
      ),
    );
    return completer.future;
  }
}

void main() {
  group('BaseBloc.runResult', () {
    late _TestBloc bloc;
    late _FakeLogger logger;
    late StreamSubscription<_TestEffect> effectSub;
    final emittedEffects = <_TestEffect>[];

    setUp(() {
      logger = _FakeLogger();
      bloc = _TestBloc(logger: logger);
      effectSub = bloc.effects.listen(emittedEffects.add);
    });

    tearDown(() async {
      await effectSub.cancel();
      await bloc.close();
      emittedEffects.clear();
    });

    test('applies reducers and logs success', () async {
      final states = <int>[];
      final sub = bloc.stream.listen(states.add);

      await bloc.runTask(
        task: () async => const Result.success(4),
        onStart: (state) => state + 1,
        onOk: (state, value) => state + value,
        onFinally: (state) => state - 1,
        spanName: 'load',
      );

      await Future<void>.delayed(Duration.zero);

      expect(states, [1, 5, 4]);
      expect(bloc.state, 4);
      expect(logger.entries.single.$1, LogLevel.info);
      expect(logger.entries.single.$2, 'bloc.ok');
      expect(logger.entries.single.$3['span'], 'load');

      await sub.cancel();
    });

    test('sends effect when failure occurs without handler', () async {
      final sub = bloc.stream.listen((_) {});

      await bloc.runTask(
        task: () async =>
            Result<int>.failure(const CacheFailure(message: 'oops')),
        toErrorEffect: (f) => _TestEffect(f.code),
      );

      await Future<void>.delayed(Duration.zero);

      expect(emittedEffects.single.label, 'cache.error');
      expect(logger.entries.single.$1, LogLevel.warn);
      expect(logger.entries.single.$2, 'bloc.err');

      await sub.cancel();
    });

    test('ignores stale result for same trackKey', () async {
      final sub = bloc.stream.listen((_) {});
      final first = Completer<Result<int>>();
      final second = Completer<Result<int>>();

      final firstFuture = bloc.runTask(
        task: () async => await first.future,
        onOk: (state, value) => value,
        trackKey: 'load',
      );

      final secondFuture = bloc.runTask(
        task: () async => await second.future,
        onOk: (state, value) => value,
        trackKey: 'load',
      );

      second.complete(const Result.success(2));
      await secondFuture;
      expect(bloc.state, 2);

      first.complete(const Result.success(1));
      await firstFuture;
      expect(bloc.state, 2);

      await sub.cancel();
    });

    test('allows concurrent operations with different track keys', () async {
      final states = <int>[];
      final sub = bloc.stream.listen(states.add);
      final one = Completer<Result<int>>();
      final two = Completer<Result<int>>();

      final futureA = bloc.runTask(
        task: () async => await one.future,
        onOk: (state, value) => value,
        trackKey: 'a',
      );

      final futureB = bloc.runTask(
        task: () async => await two.future,
        onOk: (state, value) => value,
        trackKey: 'b',
      );

      one.complete(const Result.success(7));
      two.complete(const Result.success(9));

      await Future.wait([futureA, futureB]);

      expect(states.where((s) => s == 7 || s == 9).length, 2);
      expect(bloc.state, 9);
      await sub.cancel();
    });
  });

  group('BaseBloc.reduceResult', () {
    late _TestBloc bloc;
    late StreamSubscription<_TestEffect> effectSub;
    final emittedEffects = <_TestEffect>[];

    setUp(() {
      bloc = _TestBloc();
      effectSub = bloc.effects.listen(emittedEffects.add);
    });

    tearDown(() async {
      await effectSub.cancel();
      await bloc.close();
      emittedEffects.clear();
    });

    test('emits new state on success', () async {
      final states = <int>[];
      final sub = bloc.stream.listen(states.add);

      await bloc.applyResult(
        const Result.success(3),
        onOk: (state, value) => state + value,
      );

      expect(states.single, 3);
      expect(bloc.state, 3);

      await sub.cancel();
    });

    test('emits effect for failure when handler absent', () async {
      await bloc.applyResult(
        Result<int>.failure(const AuthFailure(message: 'expired')),
        toErrorEffect: (f) => _TestEffect(f.code),
      );

      expect(emittedEffects.single.label, 'auth.invalid');
    });
  });
}
