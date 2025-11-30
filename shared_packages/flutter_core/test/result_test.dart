import 'package:flutter_core/src/foundation/failure.dart';
import 'package:flutter_core/src/foundation/result.dart';
import 'package:flutter_test/flutter_test.dart';

class _TestFailure extends Failure {
  const _TestFailure(String code) : super(code: code);
}

void main() {
  group('Result', () {
    test('success exposes value and fold works', () {
      const result = Result.success(42);

      expect(result.isSuccess, isTrue);
      expect(result.isFailure, isFalse);
      expect(result.valueOrNull, 42);
      expect(result.failureOrNull, isNull);

      final folded = result.fold(ok: (v) => v + 1, err: (_) => -1);
      expect(folded, 43);

      final mapped = result.map((v) => 'value:$v');
      expect(mapped.valueOrNull, 'value:42');
    });

    test('failure exposes failure detail and recover works', () {
      const failure = _TestFailure('oops');
      const result = Result<int>.failure(failure);

      expect(result.isSuccess, isFalse);
      expect(result.isFailure, isTrue);
      expect(result.failureOrNull, failure);
      expect(result.valueOrNull, isNull);

      final recovered = result.recover((f) => f.code.length);
      expect(recovered.valueOrNull, 4);

      final folded = result.fold(ok: (_) => 'ok', err: (f) => f.code);
      expect(folded, 'oops');
    });

    test('guard returns failure when block throws', () async {
      const failure = _TestFailure('mapped');
      Future<int> throwing() async => throw StateError('boom');

      Failure mapper(Object err, StackTrace st) {
        expect(err, isA<StateError>());
        return failure;
      }

      final result = await Result.guard(throwing, mapper);
      expect(result.failureOrNull, failure);
    });

    test('guard returns success when block succeeds', () async {
      final result = await Result.guard(() async => 'done', (_, _) => const _TestFailure('x'));
      expect(result.valueOrNull, 'done');
    });
  });
}
