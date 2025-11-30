import 'package:expense_manager/features/budget/domain/usecases/budget_failure_mapper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_core/flutter_core.dart' hide test;
import 'package:flutter_test/flutter_test.dart';

class _FakeFirebaseException extends FirebaseException {
  _FakeFirebaseException({required String super.code, super.message})
      : super(plugin: 'test');
}

void main() {
  group('mapBudgetError', () {
    final stack = StackTrace.current;

    test('returns failure unchanged', () {
      const failure = NetworkFailure(message: 'network');
      expect(mapBudgetError(failure, stack), same(failure));
    });

    test('maps AuthException to AuthFailure', () {
      final failure = mapBudgetError(AuthException('auth.required'), stack);
      expect(failure, isA<AuthFailure>());
      expect(failure.message, 'auth.required');
    });

    test('maps FirebaseException to NetworkFailure with retryable flag', () {
      final failure = mapBudgetError(
        _FakeFirebaseException(code: 'timeout', message: 'timeout'),
        stack,
      );
      expect(failure, isA<NetworkFailure>());
      expect(failure.retryable, isTrue);
    });

    test('wraps unknown errors as UnknownFailure', () {
      final failure = mapBudgetError(Exception('boom'), stack);
      expect(failure, isA<UnknownFailure>());
      expect(failure.message, contains('Exception: boom'));
    });
  });
}
