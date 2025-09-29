/// Regular expression related helpers for strings.
extension RegexExtension on String? {
  /// Returns `true` when this string parses into an HTTP or HTTPS URL.
  bool isValidUrl() {
    try {
      final url = this;
      if (url == null) return false;

      final uri = Uri.parse(url);
      return uri.hasScheme && (uri.scheme == 'http' || uri.scheme == 'https');
    } catch (e) {
      return false;
    }
  }
}
