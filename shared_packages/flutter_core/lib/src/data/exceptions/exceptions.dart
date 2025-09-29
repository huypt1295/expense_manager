/// Exception representing lower-level networking or connectivity failures.
class NetworkException implements Exception {
  final String message;
  final int? statusCode;

  NetworkException(this.message, {this.statusCode});

  @override
  String toString() => 'NetworkException($statusCode): $message';
}

/// Exception representing an HTTP response with a non-success status code.
class HttpStatusException implements Exception {
  final int statusCode;
  final String? body;

  HttpStatusException(this.statusCode, {this.body});
}

/// Exception thrown when a response payload cannot be parsed as expected.
class DeserializationException implements Exception {
  final String message;

  DeserializationException(this.message);
}

/// Exception used for authentication related errors (expired/invalid tokens).
class AuthException implements Exception {
  final String message;
  final bool tokenExpired;

  AuthException(this.message, {this.tokenExpired = false});
}

/// Exception thrown when reading or writing the cache fails unexpectedly.
class CacheException implements Exception {
  final String message;

  CacheException(this.message);
}
