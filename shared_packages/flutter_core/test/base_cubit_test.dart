import 'dart:async';

import 'package:flutter_core/src/foundation/failure.dart';
import 'package:flutter_core/src/foundation/logging/logger.dart';
import 'package:flutter_core/src/foundation/result.dart';
import 'package:flutter_core/src/presentation/bloc/base_cubit.dart';
import 'package:flutter_core/src/presentation/bloc/effect/effect.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockLogger extends Mock implements Logger {}

class _TestFailure extends Failure {
  const _TestFailure(String code) : super(code: code);
}

class _TestEffect extends Effect {
  const _TestEffect(this.code);
  final String code;
}

class _TestCubit extends BaseCubit<int, _TestEffect> {
  _TestCubit({Logger? logger}) : super(0, logger: logger);

  Future<void> execute(Future<Result<int>> Function() task) {
    return runResult(
      task: task,
      onStart: (_) => state + 1,
      onOk: (_, value) => value,
      toErrorEffect: (f) => _TestEffect(f.code),
      spanName: 'task',
    );
  }
}

void main() {
  late _MockLogger logger;

  setUp(() {
    logger = _MockLogger();
    when(() => logger.info(any(), any())).thenReturn(null);
    when(() => logger.warn(any(), any())).thenReturn(null);
  });

  test('success runResult updates state and logs info', () async {
    final cubit = _TestCubit(logger: logger);
    final states = <int>[];
    final sub = cubit.stream.listen(states.add);

    await cubit.execute(() async => const Result.success(5));
    await Future<void>.delayed(Duration.zero);

    expect(states, [1, 5]);
    verify(() => logger.info('cubit.ok', any<Map<String, Object?>>())).called(1);

    await sub.cancel();
    await cubit.close();
  });

  test('failure runResult emits effect and logs warning', () async {
    final cubit = _TestCubit(logger: logger);
    final effects = <_TestEffect>[];
    final sub = cubit.effects.listen(effects.add);

    await cubit.execute(() async => const Result.failure(_TestFailure('oops')));
    await Future<void>.delayed(Duration.zero);

    expect(effects.single.code, 'oops');
    verify(() => logger.warn('cubit.err', any<Map<String, Object?>>())).called(1);

    await sub.cancel();
    await cubit.close();
  });

  test('stale operations do not override newer results', () async {
    final cubit = _TestCubit(logger: logger);

    final first = Completer<Result<int>>();
    final second = Completer<Result<int>>();

    final future1 = cubit.execute(() => first.future);
    final future2 = cubit.execute(() => second.future);

    second.complete(const Result.success(2));
    await future2;

    first.complete(const Result.success(1));
    await future1;

    expect(cubit.state, 2);
    await cubit.close();
  });
}
