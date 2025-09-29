/// Base class representing a recoverable error exposed to the domain layer.
abstract class Failure {
  /// Machine readable code (for example `network.timeout` or `auth.expired`).
  final String code;

  /// Optional message intended for diagnostics and logging.
  final String? message;

  /// Original exception that triggered the failure, when available.
  final Object? cause;

  /// Captured stack trace associated with the failure.
  final StackTrace? stackTrace;

  /// Indicates whether the failure suggests a retry might succeed.
  final bool retryable;

  /// Creates a new failure describing the provided [code] and metadata.
  const Failure({
    required this.code,
    this.message,
    this.cause,
    this.stackTrace,
    this.retryable = false,
  });
}

/// Failure produced for network communication errors.
class NetworkFailure extends Failure {
  /// HTTP status code returned by the server, when available.
  final int? statusCode;

  /// Creates a [NetworkFailure] with the optionally supplied [statusCode].
  const NetworkFailure({
    super.code = 'network.error',
    super.message,
    this.statusCode,
    super.cause,
    super.stackTrace,
    super.retryable = true,
  });
}

/// Failure generated when an operation times out.
class TimeoutFailure extends Failure {
  /// Creates a [TimeoutFailure] that is marked as retryable by default.
  const TimeoutFailure({
    super.code = 'network.timeout',
    super.message,
    super.cause,
    super.stackTrace,
  }) : super(retryable: true);
}

/// Failure produced when authentication fails or expires.
class AuthFailure extends Failure {
  /// Creates an [AuthFailure] with the provided diagnostic metadata.
  const AuthFailure({
    super.code = 'auth.invalid',
    super.message,
    super.cause,
    super.stackTrace,
  });
}

/// Failure produced when a required permission is not granted.
class PermissionFailure extends Failure {
  /// Creates a [PermissionFailure] describing why access was denied.
  const PermissionFailure({
    super.code = 'permission.denied',
    super.message,
  });
}

/// Failure created when validation rules are not satisfied.
class ValidationFailure extends Failure {
  /// Creates a [ValidationFailure] with the provided diagnostics.
  const ValidationFailure({
    super.code = 'validation.invalid',
    super.message,
  });
}

/// Failure representing local cache read or write errors.
class CacheFailure extends Failure {
  /// Creates a [CacheFailure] with contextual information.
  const CacheFailure({
    super.code = 'cache.error',
    super.message,
    super.cause,
    super.stackTrace,
  });
}

/// Fallback failure used when an error cannot be classified.
class UnknownFailure extends Failure {
  /// Creates an [UnknownFailure] with optional diagnostic metadata.
  const UnknownFailure({
    super.code = 'unknown',
    super.message,
    super.cause,
    super.stackTrace,
  });
}
