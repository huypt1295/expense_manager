import 'package:go_router/go_router.dart';

/// Minimal contract describing the application's routing configuration.
abstract class BaseRouter {
  /// Primary entry route for the feature/module.
  GoRoute get mainRoute;

  /// All routes registered with the router.
  List<RouteBase> get routes;

  /// Location used when the router is first created.
  String get initialRoute;
}
