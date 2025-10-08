import 'package:expense_manager/features/transactions/domain/usecases/transactions_failure_mapper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_core/flutter_core.dart' hide test;
import 'package:flutter_test/flutter_test.dart';

class _FakeFirebaseException extends FirebaseException {
  _FakeFirebaseException({required String code, String? message})
      : super(plugin: 'test', code: code, message: message);
}

void main() {
  group('mapTransactionsError', () {
    final stack = StackTrace.current;

    test('returns failure unchanged', () {
      const failure = UnknownFailure(message: 'existing');

      final result = mapTransactionsError(failure, stack);

      expect(result, same(failure));
    });

    test('maps AuthException to AuthFailure', () {
      final result = mapTransactionsError(AuthException('auth.failed'), stack);

      expect(result, isA<AuthFailure>());
      expect(result.message, 'auth.failed');
    });

    test('maps FirebaseException to NetworkFailure with retryable flag', () {
      final result = mapTransactionsError(
        _FakeFirebaseException(code: 'unavailable', message: 'offline'),
        stack,
      );

      expect(result, isA<NetworkFailure>());
      expect(result.retryable, isTrue);
      expect(result.message, 'offline');
    });

    test('falls back to UnknownFailure', () {
      final result = mapTransactionsError(Exception('boom'), stack);

      expect(result, isA<UnknownFailure>());
      expect(result.message, contains('Exception'));
    });
  });
}
