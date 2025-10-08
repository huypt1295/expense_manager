import 'package:expense_manager/features/profile_setting/domain/usecases/profile_failure_mapper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_core/flutter_core.dart' hide test;
import 'package:flutter_test/flutter_test.dart';

class _FakeFirebaseException extends FirebaseException {
  _FakeFirebaseException({required String code, String? message})
      : super(plugin: 'test', code: code, message: message);
}

void main() {
  group('mapProfileError', () {
    final stack = StackTrace.current;

    test('passes through existing failures', () {
      const failure = UnknownFailure(message: 'profile');
      expect(mapProfileError(failure, stack), same(failure));
    });

    test('maps AuthException to AuthFailure', () {
      final failure = mapProfileError(AuthException('auth'), stack);
      expect(failure, isA<AuthFailure>());
      expect(failure.message, 'auth');
    });

    test('classifies FirebaseException as NetworkFailure', () {
      final failure = mapProfileError(
        _FakeFirebaseException(code: 'unavailable', message: 'temporarily down'),
        stack,
      );
      expect(failure, isA<NetworkFailure>());
      expect(failure.retryable, isTrue);
    });

    test('wraps other errors into UnknownFailure', () {
      final failure = mapProfileError(Exception('oops'), stack);
      expect(failure, isA<UnknownFailure>());
      expect(failure.message, contains('Exception: oops'));
    });
  });
}
