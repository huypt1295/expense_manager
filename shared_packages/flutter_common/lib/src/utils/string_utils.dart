/// Convenience string manipulation helpers.
extension StringExtensions on String {
  /// Concatenates this string with [other].
  String plus(String other) {
    return this + other;
  }

  /// Returns `true` when this string contains [secondString], ignoring case.
  bool equalsIgnoreCase(String secondString) => toLowerCase().contains(secondString.toLowerCase());
}
