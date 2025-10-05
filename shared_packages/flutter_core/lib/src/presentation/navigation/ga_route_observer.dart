import 'package:flutter/material.dart' show RouteObserver, PageRoute, Route;
import 'package:flutter_core/flutter_core.dart' show LazySingleton, Analytics;
import 'package:flutter_core/src/foundation/foundation.dart';

/// Reports navigation events to Google Analytics when routes change.
@LazySingleton()
class GARouteObserver extends RouteObserver<PageRoute<dynamic>> {
  final Analytics _analytics;

  GARouteObserver(this._analytics);

  void _send(Route<dynamic>? route) {
    final r = route;
    if (r is PageRoute) {
      final name = r.settings.name ?? r.runtimeType.toString();
      _analytics.logScreenView(
        screenName: name,
        screenClass: r.runtimeType.toString(),
      );
    }
  }

  @override
  void didPush(Route route, Route? previousRoute) {
    LoggerProvider.instance?.debug("didPush called: route = ${route}, previousRoute = $previousRoute");
    _send(route);
  }

  @override
  void didReplace({Route? newRoute, Route? oldRoute}) {
    LoggerProvider.instance?.debug("didReplace called: newRoute = $newRoute, oldRoute = $oldRoute");
    _send(newRoute);
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    LoggerProvider.instance?.debug("didReplace called: route = $route, previousRoute = $previousRoute");
    _send(previousRoute);
  }
}
