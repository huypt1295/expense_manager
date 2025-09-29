import 'package:flutter/widgets.dart';
import 'package:flutter_core/flutter_core.dart' show LazySingleton, CrashReporter;

/// Records navigation breadcrumbs for crash diagnostics.
@LazySingleton()
class CrashRouteObserver extends RouteObserver<PageRoute<dynamic>> {
  final CrashReporter _crash;

  CrashRouteObserver(this._crash);

  void _crumb(Route<dynamic>? route, String action) {
    final name = route?.settings.name ?? route.toString();
    _crash.addBreadcrumb(
      'route.$action',
      category: 'navigation',
      data: {'name': name},
    );
  }

  @override
  void didPush(Route route, Route? previousRoute) => _crumb(route, 'push');

  @override
  void didPop(Route route, Route? previousRoute) => _crumb(previousRoute, 'pop');

  @override
  void didReplace({Route? newRoute, Route? oldRoute}) => _crumb(newRoute, 'replace');
}
