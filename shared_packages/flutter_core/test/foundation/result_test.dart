import 'package:flutter_core/src/foundation/failure.dart';
import 'package:flutter_core/src/foundation/result.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Result', () {
    test('success exposes value and flags', () {
      const result = Result.success(10);

      expect(result.isSuccess, isTrue);
      expect(result.isFailure, isFalse);
      expect(result.valueOrNull, 10);
      expect(result.failureOrNull, isNull);
    });

    test('failure exposes error and flags', () {
      const failure = TimeoutFailure(message: 'timeout');
      const result = Result<int>.failure(failure);

      expect(result.isSuccess, isFalse);
      expect(result.isFailure, isTrue);
      expect(result.valueOrNull, isNull);
      expect(result.failureOrNull, failure);
    });

    test('fold delegates to ok handler for success', () {
      const result = Result.success(3);

      final output = result.fold(ok: (value) => value * 2, err: (_) => 0);

      expect(output, 6);
    });

    test('fold delegates to err handler for failure', () {
      const failure = AuthFailure(message: 'denied');
      const result = Result<String>.failure(failure);

      final output = result.fold(ok: (_) => 'ok', err: (err) => err.message);

      expect(output, 'denied');
    });

    test('map transforms success value only', () {
      const result = Result.success(2);

      final mapped = result.map((value) => value * 5);

      expect(mapped.valueOrNull, 10);
      expect(mapped.isSuccess, isTrue);
    });

    test('map preserves failure instance', () {
      const failure = CacheFailure(message: 'missing');
      const result = Result<int>.failure(failure);

      final mapped = result.map((value) => value + 1);

      expect(mapped.isFailure, isTrue);
      expect(identical(mapped.failureOrNull, failure), isTrue);
    });

    test('recover keeps success untouched', () {
      const result = Result.success('value');

      final recovered = result.recover((_) => 'fallback');

      expect(identical(result, recovered), isTrue);
      expect(recovered.valueOrNull, 'value');
    });

    test('recover converts failure into success', () {
      const failure = PermissionFailure(message: 'no access');
      const result = Result<int>.failure(failure);

      final recovered = result.recover((f) => f.message!.length);

      expect(recovered.isSuccess, isTrue);
      expect(recovered.valueOrNull, failure.message!.length);
    });

    test('guard returns success when block completes', () async {
      final result = await Result.guard(
        () async => 'done',
        (error, _) => UnknownFailure(message: error.toString()),
      );

      expect(result.isSuccess, isTrue);
      expect(result.valueOrNull, 'done');
    });

    test('guard maps thrown errors into failure', () async {
      final result = await Result.guard<int>(
        () async => throw StateError('boom'),
        (error, _) => CacheFailure(message: error.toString()),
      );

      expect(result.isFailure, isTrue);
      expect(result.failureOrNull, isA<CacheFailure>());
      expect(result.failureOrNull!.message, 'Bad state: boom');
    });
  });
}
