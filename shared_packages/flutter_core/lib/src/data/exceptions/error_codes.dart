/// Shared error code identifiers surfaced by repositories and data sources.
///
/// These string constants are intentionally namespaced (`domain.reason`) so they
/// can be logged, matched, or localized consistently across layers.
abstract class ErrorCodes {
  static const networkUnreachable = 'network.unreachable';
  static const networkTimeout = 'network.timeout';
  static const networkRateLimit = 'network.rate_limit';
  static const authExpired = 'auth.expired';
  static const authInvalid = 'auth.invalid';
  static const permissionDenied = 'permission.denied';
  static const permissionForbidden = 'permission.forbidden';
  static const validationMalformed = 'validation.malformed';
  static const validationNotFound = 'validation.not_found';
  static const cacheMiss = 'cache.miss';
  static const cacheError = 'cache.error';
  static const unknown = 'unknown';
}
