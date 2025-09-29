import 'package:dio/dio.dart';

/// Signature for retry predicates.
typedef RetryIf = bool Function(Object error, int attempt);

/// Signature for backoff-duration factories.
typedef DelayFor = Duration Function(int attempt);

/// Exponential backoff strategy with optional jitter to spread retries.
class ExponentialBackoff {
  final int maxRetries;
  final Duration base;
  final Duration? max;
  final double jitter; // 0..1

  const ExponentialBackoff({
    this.maxRetries = 3,
    this.base = const Duration(milliseconds: 200),
    this.max,
    this.jitter = 0.2,
  });

  /// Computes the delay for the given [attempt] (1-based).
  Duration delay(int attempt) {
    final rawMs = base.inMilliseconds * (1 << (attempt - 1)); // 2^(n-1)
    final jitterMs = (rawMs * jitter).toInt();
    final rnd =
        (DateTime.now().microsecondsSinceEpoch % (2 * jitterMs + 1)) - jitterMs;
    final d = Duration(milliseconds: rawMs + rnd);
    if (max == null) return d;
    return d > max! ? max! : d;
  }
}

/// Retry policy pairing a predicate with a backoff strategy.
class RetryPolicy {
  final RetryIf shouldRetry;
  final ExponentialBackoff backoff;

  const RetryPolicy({required this.shouldRetry, required this.backoff});
}

/// Default retry predicate for Dio exceptions.
bool dioShouldRetry(Object error, int attempt) {
  if (error is DioException) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.connectionError:
        return true;
      case DioExceptionType.badResponse:
        final s = error.response?.statusCode ?? 0;
        return s >= 500 || s == 429 || s == 408;
      case DioExceptionType.badCertificate:
      case DioExceptionType.cancel:
      case DioExceptionType.unknown:
        // Unknown errors are often socket issues; retry a couple of times.
        return true;
    }
  }
  return false;
}

/// Default retry policy used when none is injected explicitly.
const defaultPolicy = RetryPolicy(
  shouldRetry: dioShouldRetry,
  backoff: ExponentialBackoff(
    maxRetries: 3,
    base: Duration(milliseconds: 250),
    max: Duration(seconds: 2),
  ),
);
