import 'package:firebase_core/firebase_core.dart' show FirebaseException;
import 'package:flutter_core/flutter_core.dart';

Failure mapTransactionsError(Object error, StackTrace stackTrace) {
  if (error is Failure) {
    return error;
  }
  if (error is AuthException) {
    return AuthFailure(
      message: error.message,
      cause: error,
      stackTrace: stackTrace,
    );
  }
  if (error is FirebaseException) {
    final code = error.code;
    final retryable = code.contains('unavailable') || code.contains('timeout');
    return NetworkFailure(
      message: error.message,
      cause: error,
      stackTrace: stackTrace,
      retryable: retryable,
    );
  }
  return UnknownFailure(
    message: error.toString(),
    cause: error,
    stackTrace: stackTrace,
  );
}
