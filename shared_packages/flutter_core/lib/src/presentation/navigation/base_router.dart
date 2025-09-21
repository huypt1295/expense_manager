import 'package:go_router/go_router.dart';

abstract class BaseRouter {
  GoRoute get mainRoute;
  List<RouteBase> get routes;
  String get initialRoute;
}