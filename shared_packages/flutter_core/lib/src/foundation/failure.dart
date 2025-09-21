abstract class Failure {
  final String code; // ví dụ: "network.timeout", "auth.expired"
  final String? message; // message kỹ thuật/log; UI sẽ map sang i18n key
  final Object? cause; // giữ nguyên gốc Exception (optional)
  final StackTrace? stackTrace;
  final bool retryable; // gợi ý logic retry
  const Failure({
    required this.code,
    this.message,
    this.cause,
    this.stackTrace,
    this.retryable = false,
  });

}

// Các nhóm Failure "chuẩn dùng chung"
class NetworkFailure extends Failure {
  final int? statusCode; // HTTP status (nếu có)
  const NetworkFailure({
    super.code = 'network.error',
    super.message,
    this.statusCode,
    super.cause,
    super.stackTrace,
    super.retryable = true,
  });
}

class TimeoutFailure extends Failure {
  const TimeoutFailure(
      {super.code = 'network.timeout',
      super.message,
      super.cause,
      super.stackTrace})
      : super(retryable: true);
}

class AuthFailure extends Failure {
  const AuthFailure(
      {super.code = 'auth.invalid',
      super.message,
      super.cause,
      super.stackTrace});
}

class PermissionFailure extends Failure {
  const PermissionFailure({super.code = 'permission.denied', super.message});
}

class ValidationFailure extends Failure {
  const ValidationFailure({super.code = 'validation.invalid', super.message});
}

class CacheFailure extends Failure {
  const CacheFailure(
      {super.code = 'cache.error',
      super.message,
      super.cause,
      super.stackTrace});
}

class UnknownFailure extends Failure {
  const UnknownFailure(
      {super.code = 'unknown', super.message, super.cause, super.stackTrace});
}
