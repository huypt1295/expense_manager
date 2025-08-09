
extension RegexExtension on String? {
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