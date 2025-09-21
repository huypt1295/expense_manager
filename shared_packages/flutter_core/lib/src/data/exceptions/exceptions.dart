class NetworkException implements Exception {
  final String message;
  final int? statusCode;
  NetworkException(this.message, {this.statusCode});
  @override
  String toString() => 'NetworkException($statusCode): $message';
}

class HttpStatusException implements Exception {
  final int statusCode;
  final String? body;
  HttpStatusException(this.statusCode, {this.body});
}

class DeserializationException implements Exception {
  final String message;
  DeserializationException(this.message);
}

class AuthException implements Exception {
  final String message;
  final bool tokenExpired;
  AuthException(this.message, {this.tokenExpired = false});
}

class CacheException implements Exception {
  final String message;
  CacheException(this.message);
}
