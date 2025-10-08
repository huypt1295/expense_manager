import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_core/src/foundation/failure.dart';
import 'package:flutter_core/src/foundation/result.dart';
import 'package:flutter_core/src/foundation/logging/logger.dart';
import 'package:flutter_core/src/presentation/bloc/base_bloc.dart';
import 'package:flutter_core/src/presentation/bloc/base_bloc_event.dart';
import 'package:flutter_core/src/presentation/bloc/effect/effect.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockLogger extends Mock implements Logger {}

class _TestFailure extends Failure {
  const _TestFailure(String code) : super(code: code);
}

class _TriggerSuccess extends BaseBlocEvent {
  const _TriggerSuccess();
}

class _TriggerFailure extends BaseBlocEvent {
  const _TriggerFailure();
}

class _TestEffect extends Effect {
  const _TestEffect(this.failureCode);
  final String failureCode;
}

class _TestBloc extends BaseBloc<BaseBlocEvent, int, _TestEffect> {
  _TestBloc({required this.successTask, required this.failureTask, Logger? logger})
      : super(0, logger: logger) {
    on<_TriggerSuccess>((event, emit) async {
      await runResult<int>(
        emit: emit,
        task: successTask,
        onStart: (_) => -1,
        onFinally: (_) => -2,
        onOk: (_, value) => value,
        toErrorEffect: (f) => _TestEffect(f.code),
        spanName: 'success',
      );
    });

    on<_TriggerFailure>((event, emit) async {
      await runResult<int>(
        emit: emit,
        task: failureTask,
        onStart: (_) => -1,
        onFinally: (_) => -2,
        toErrorEffect: (f) => _TestEffect(f.code),
        spanName: 'failure',
      );
    });
  }

  final Future<Result<int>> Function() successTask;
  final Future<Result<int>> Function() failureTask;
}

void main() {
  late _MockLogger logger;

  setUp(() {
    logger = _MockLogger();
    when(() => logger.info(any(), any())).thenReturn(null);
    when(() => logger.warn(any(), any())).thenReturn(null);
  });

  blocTest<_TestBloc, int>(
    'emits start, success, and finally states',
    build: () => _TestBloc(
      logger: logger,
      successTask: () async => const Result.success(42),
      failureTask: () async => const Result.failure(_TestFailure('err')),
    ),
    act: (bloc) => bloc.add(const _TriggerSuccess()),
    expect: () => [-1, 42, -2],
    verify: (bloc) {
      verify(() => logger.info('bloc.ok', any<Map<String, Object?>>())).called(1);
    },
  );

  test('emits failure effect when task fails', () async {
    final bloc = _TestBloc(
      logger: logger,
      successTask: () async => const Result.success(0),
      failureTask: () async => const Result.failure(_TestFailure('failure_code')),
    );

    final effects = <_TestEffect>[];
    final sub = bloc.effects.listen(effects.add);

    final statesFuture = bloc.stream.take(2).toList();
    bloc.add(const _TriggerFailure());

    expect(await statesFuture, [-1, -2]);

    expect(effects.single.failureCode, 'failure_code');
    verify(() => logger.warn('bloc.err -> null', any<Map<String, Object?>>())).called(1);

    await sub.cancel();
    await bloc.close();
  });
}
