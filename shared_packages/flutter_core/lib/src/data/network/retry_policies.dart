import 'dart:async';

import 'package:flutter_core/flutter_core.dart';

typedef RetryIf = bool Function(Object error, int attempt);
typedef DelayFor = Duration Function(int attempt);

class ExponentialBackoff {
  final int maxRetries;
  final Duration base; // ví dụ 200ms
  final Duration? max; // ví dụ 2s
  final double jitter; // 0..1, ví dụ 0.2

  const ExponentialBackoff({
    this.maxRetries = 3,
    this.base = const Duration(milliseconds: 200),
    this.max,
    this.jitter = 0.2,
  });

  Duration delay(int attempt) {
    // attempt: 1..maxRetries
    final rawMs = base.inMilliseconds * (1 << (attempt - 1));
    final jitterMs = (rawMs * jitter).toInt();
    final rnd =
        (DateTime.now().microsecondsSinceEpoch % (2 * jitterMs + 1)) - jitterMs;
    final d = Duration(milliseconds: rawMs + rnd);
    if (max == null) return d;
    return d > max! ? max! : d;
  }
}

class RetryPolicy {
  final RetryIf shouldRetry;
  final ExponentialBackoff backoff;

  const RetryPolicy({required this.shouldRetry, required this.backoff});
}

// Transient? timeout, 5xx, 429, network down
bool defaultShouldRetry(Object error, int attempt) {
  // tuỳ Exception của adapter
  if (error is TimeoutException) return true;
  if (error is NetworkException) return true;
  if (error is HttpStatusException) {
    final s = error.statusCode;
    return s >= 500 || s == 429 || s == 408;
  }
  return false;
}

const defaultPolicy = RetryPolicy(
  shouldRetry: defaultShouldRetry,
  backoff: ExponentialBackoff(
      maxRetries: 3,
      base: Duration(milliseconds: 250),
      max: Duration(seconds: 2)),
);
