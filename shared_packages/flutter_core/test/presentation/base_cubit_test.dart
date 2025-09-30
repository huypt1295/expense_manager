import 'dart:async';

import 'package:flutter_core/src/foundation/failure.dart';
import 'package:flutter_core/src/foundation/result.dart';
import 'package:flutter_core/src/foundation/logger.dart';
import 'package:flutter_core/src/presentation/bloc/base_cubit.dart';
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

class _TestCubit extends BaseCubit<int, _TestEffect> {
  _TestCubit({Logger? logger}) : super(0, logger: logger);

  Future<void> runTask({
    required Future<Result<int>> Function() task,
    int Function(int state)? onStart,
    int Function(int state)? onFinally,
    int Function(int state, int value)? onOk,
    void Function(int state, Failure f)? onErr,
    _TestEffect Function(Failure f)? toErrorEffect,
    String? spanName,
  }) => runResult(
    task: task,
    onStart: onStart,
    onFinally: onFinally,
    onOk: onOk,
    onErr: onErr,
    toErrorEffect: toErrorEffect,
    spanName: spanName,
  );

  void applyResult(
    Result<int> result, {
    int Function(int state, int value)? onOk,
    void Function(int state, Failure f)? onErr,
    _TestEffect Function(Failure f)? toErrorEffect,
  }) => reduceResult(
    result: result,
    onOk: onOk,
    onErr: onErr,
    toErrorEffect: toErrorEffect,
  );
}

void main() {
  group('BaseCubit.runResult', () {
    late _TestCubit cubit;
    late _FakeLogger logger;
    late StreamSubscription<_TestEffect> effectSub;
    final emittedEffects = <_TestEffect>[];

    setUp(() {
      logger = _FakeLogger();
      cubit = _TestCubit(logger: logger);
      effectSub = cubit.effects.listen(emittedEffects.add);
    });

    tearDown(() async {
      await effectSub.cancel();
      await cubit.close();
      emittedEffects.clear();
    });

    test('applies lifecycle reducers and logs success', () async {
      final states = <int>[];
      final sub = cubit.stream.listen(states.add);

      await cubit.runTask(
        task: () async => const Result.success(5),
        onStart: (state) => state + 1,
        onOk: (state, value) => state + value,
        onFinally: (state) => state - 1,
        spanName: 'load',
      );

      await Future<void>.delayed(Duration.zero);

      expect(states, [1, 6, 5]);
      expect(cubit.state, 5);
      expect(logger.entries.single.$1, LogLevel.info);
      expect(logger.entries.single.$2, 'cubit.ok');
      expect(logger.entries.single.$3['span'], 'load');

      await sub.cancel();
    });

    test('emits effect when failure occurs without custom handler', () async {
      await cubit.runTask(
        task: () async => Result<int>.failure(TimeoutFailure(message: 'slow')),
        toErrorEffect: (f) => _TestEffect('fail:${f.code}'),
      );

      await Future<void>.delayed(Duration.zero);

      expect(emittedEffects.single.label, 'fail:network.timeout');
      expect(logger.entries.single.$1, LogLevel.warn);
      expect(logger.entries.single.$2, 'cubit.err');
    });

    test('ignores stale operation results', () async {
      final first = Completer<Result<int>>();
      final second = Completer<Result<int>>();

      final firstFuture = cubit.runTask(
        task: () async => await first.future,
        onOk: (state, value) => value,
      );

      final secondFuture = cubit.runTask(
        task: () async => await second.future,
        onOk: (state, value) => value,
      );

      second.complete(const Result.success(2));
      await secondFuture;
      expect(cubit.state, 2);

      first.complete(const Result.success(1));
      await firstFuture;

      expect(cubit.state, 2);
    });
  });

  group('BaseCubit.reduceResult', () {
    late _TestCubit cubit;
    late StreamSubscription<_TestEffect> effectSub;
    final emittedEffects = <_TestEffect>[];

    setUp(() {
      cubit = _TestCubit();
      effectSub = cubit.effects.listen(emittedEffects.add);
    });

    tearDown(() async {
      await effectSub.cancel();
      await cubit.close();
      emittedEffects.clear();
    });

    test('updates state on success', () {
      cubit.applyResult(
        const Result.success(3),
        onOk: (state, value) => state + value,
      );

      expect(cubit.state, 3);
    });

    test('maps failure to effect when handler missing', () async {
      cubit.applyResult(
        Result<int>.failure(const PermissionFailure(message: 'no access')),
        toErrorEffect: (f) => _TestEffect(f.code),
      );

      await Future<void>.delayed(Duration.zero);
      expect(emittedEffects.single.label, 'permission.denied');
    });
  });
}
