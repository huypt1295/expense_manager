import 'dart:async' show TimeoutException;

import 'package:flutter_core/src/data/exceptions/error_codes.dart' show ErrorCodes;
import 'package:flutter_core/src/data/exceptions/exceptions.dart';
import 'package:flutter_core/src/foundation/failure.dart';
import 'package:flutter_core/src/foundation/result.dart';

/// Provides reusable mapping helpers from low-level exceptions to [Failure] types.
mixin RepoErrorMapper {
  /// Converts any thrown error [e] (plus optional [st]) into a domain [Failure].
  Failure toFailure(Object e, [StackTrace? st]) {
    if (e is TimeoutException) {
      return TimeoutFailure(message: e.toString());
    }
    if (e is NetworkException) {
      return NetworkFailure(
        message: e.message,
        statusCode: e.statusCode,
        cause: e,
        stackTrace: st,
        retryable: true,
      );
    }
    if (e is HttpStatusException) {
      if (e.statusCode == 401) {
        return AuthFailure(code: ErrorCodes.authExpired, message: e.toString());
      }
      if (e.statusCode == 403) {
        return PermissionFailure(
            code: ErrorCodes.permissionForbidden, message: e.toString());
      }
      if (e.statusCode == 429) {
        return NetworkFailure(
            code: ErrorCodes.networkRateLimit,
            message: e.toString(),
            retryable: true);
      }
      if (e.statusCode == 404) {
        return ValidationFailure(
            code: ErrorCodes.validationNotFound, message: e.toString());
      }
      return NetworkFailure(
          message: 'HTTP ${e.statusCode}', cause: e, stackTrace: st);
    }
    if (e is DeserializationException) {
      return ValidationFailure(
          code: ErrorCodes.validationMalformed, message: e.toString());
    }
    if (e is CacheException) {
      return CacheFailure(message: e.message, cause: e, stackTrace: st);
    }
    return UnknownFailure(message: e.toString(), cause: e, stackTrace: st);
  }

  /// Wraps [block] and maps thrown errors to [Failure] using [toFailure].
  Future<Result<T>> guard<T>(Future<T> Function() block) =>
      Result.guard(block, toFailure);
}
