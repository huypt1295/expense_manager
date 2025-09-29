/// Executes [block] immediately and returns its result.
T run<T>(T Function() block) {
  return block();
}

/// Extension with Kotlin-inspired nullability helpers for optional values.
extension ObjectUtils<T> on T? {
  /// Safely casts this value to type [R], returning `null` when the cast fails.
  R? safeCast<R>() {
    final that = this;
    if (that is R) {
      return that;
    }

    return null;
  }

  /// Executes [cb] when the value is non-null, forwarding the result.
  R? let<R>(R Function(T)? cb) {
    final that = this;
    if (that == null) {
      return null;
    }

    return cb?.call(that);
  }
}

/// Safely casts the arbitrary [value] to type [T], or returns `null` on failure.
T? safeCast<T>(dynamic value) {
  if (value is T) {
    return value;
  }

  return null;
}
