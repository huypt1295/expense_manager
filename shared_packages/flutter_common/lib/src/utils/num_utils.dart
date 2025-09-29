/// Convenience arithmetic helpers for all numeric types.
extension NumExtensions on num {
  /// Adds [other] to this number.
  num plus(num other) {
    return this + other;
  }

  /// Subtracts [other] from this number.
  num minus(num other) {
    return this - other;
  }

  /// Multiplies this number by [other].
  num times(num other) {
    return this * other;
  }

  /// Divides this number by [other].
  num div(num other) {
    return this / other;
  }
}

/// Integer-specific arithmetic helpers.
extension IntExtensions on int {
  /// Adds [other] to this integer.
  int plus(int other) {
    return this + other;
  }

  /// Subtracts [other] from this integer.
  int minus(int other) {
    return this - other;
  }

  /// Multiplies this integer by [other].
  int times(int other) {
    return this * other;
  }

  /// Performs floating point division against [other].
  double div(int other) {
    return this / other;
  }

  /// Performs integer division against [other], discarding the remainder.
  int truncateDiv(int other) {
    return this ~/ other;
  }
}

/// Double-specific arithmetic helpers.
extension DoubleExtensions on double {
  /// Adds [other] to this double.
  double plus(double other) {
    return this + other;
  }

  /// Subtracts [other] from this double.
  double minus(double other) {
    return this - other;
  }

  /// Multiplies this double by [other].
  double times(double other) {
    return this * other;
  }

  /// Divides this double by [other].
  double div(double other) {
    return this / other;
  }
}
