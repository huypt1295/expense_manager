import 'package:go_router/go_router.dart';

/// Base contract for feature routers built on top of `go_router`.
abstract class BaseRouter {
  /// Root route for the feature, typically used as the entry point when
  /// nesting routers.
  GoRoute get mainRoute;

  /// Collection of routes exposed by this router.
  List<RouteBase> get routes;

  /// Path that should be used when the router is initialized.
  String get initialRoute;
}