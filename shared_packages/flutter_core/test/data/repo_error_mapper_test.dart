import 'dart:async';

import 'package:flutter_core/src/data/exceptions/exception_mapper.dart';
import 'package:flutter_core/src/data/exceptions/exceptions.dart';
import 'package:flutter_core/src/foundation/failure.dart';
import 'package:flutter_test/flutter_test.dart';

class _Mapper with RepoErrorMapper {}

void main() {
  final mapper = _Mapper();

  Failure _map(Object e) => mapper.toFailure(e);

  group('RepoErrorMapper.toFailure', () {
    test('maps timeout exception to TimeoutFailure', () {
      final failure = _map(TimeoutException('slow'));
      expect(failure, isA<TimeoutFailure>());
    });

    test('maps network exception to NetworkFailure', () {
      final failure = _map(NetworkException('offline', statusCode: 503));
      expect(failure, isA<NetworkFailure>());
      expect((failure as NetworkFailure).statusCode, 503);
    });

    test('maps HTTP 401 to AuthFailure with auth.expired code', () {
      final failure = _map(HttpStatusException(401));
      expect(failure, isA<AuthFailure>());
      expect(failure.code, 'auth.expired');
    });

    test('maps HTTP 403 to PermissionFailure with permission.forbidden', () {
      final failure = _map(HttpStatusException(403));
      expect(failure, isA<PermissionFailure>());
      expect(failure.code, 'permission.forbidden');
    });

    test('maps HTTP 429 to NetworkFailure with rate limit code', () {
      final failure = _map(HttpStatusException(429));
      expect(failure, isA<NetworkFailure>());
      expect(failure.code, 'network.rate_limit');
      expect(failure.retryable, isTrue);
    });

    test('maps HTTP 404 to ValidationFailure with not found code', () {
      final failure = _map(HttpStatusException(404));
      expect(failure, isA<ValidationFailure>());
      expect(failure.code, 'validation.not_found');
    });

    test('maps deserialization errors to ValidationFailure', () {
      final failure = _map(DeserializationException('bad json'));
      expect(failure, isA<ValidationFailure>());
      expect(failure.code, 'validation.malformed');
    });

    test('maps cache exception to CacheFailure', () {
      final failure = _map(CacheException('oops'));
      expect(failure, isA<CacheFailure>());
    });

    test('maps unknown exception to UnknownFailure', () {
      final failure = _map(StateError('boom'));
      expect(failure, isA<UnknownFailure>());
    });
  });

  group('RepoErrorMapper.guard', () {
    test('returns success when block completes', () async {
      final result = await mapper.guard(() async => 42);
      expect(result.isSuccess, isTrue);
      expect(result.valueOrNull, 42);
    });

    test('maps thrown errors to Failure', () async {
      final result = await mapper.guard<int>(() async {
        throw TimeoutException('slow');
      });
      expect(result.isFailure, isTrue);
      expect(result.failureOrNull, isA<TimeoutFailure>());
    });
  });
}
