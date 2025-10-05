/// Centralized route definitions for the app.
///
/// Prefer `AppRoute` over raw string paths so navigation remains consistent
/// and safe to refactor. Use `location()` when building links with
/// query parameters.
enum AppRoute {
  login('/login'),
  home('/home'),
  homeSummary('/home/summary'),
  homeTransactions('/home/transactions'),
  homeBudget('/home/budget'),
  homeProfile('/home/profile');

  const AppRoute(this.path);

  /// Absolute path used by GoRouter configuration.
  final String path;

  /// Returns the canonical location including query parameters when needed.
  String location({Map<String, String>? queryParameters}) {
    if (queryParameters == null || queryParameters.isEmpty) {
      return path;
    }

    final query = Uri(queryParameters: queryParameters).query;
    return '$path?$query';
  }

  /// Enables shorthand syntax like `AppRoute.login()`.
  String call({Map<String, String>? queryParameters}) =>
      location(queryParameters: queryParameters);
}
