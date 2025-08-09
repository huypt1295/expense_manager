import 'package:flutter/material.dart';
import 'package:flutter_common/flutter_common.dart';
import 'package:expense_manager/features/home/presentation/home/home_page.dart';
import 'package:flutter_core/flutter_core.dart';

@singleton
class AppRouter {
  GoRouter get router => GoRouter(
        initialLocation: "/",
        routes: [
          GoRoute(
            path: "/",
            builder: (context, state) {
              return const HomePage();
            },
          ),
        ],
        observers: [NavigationObserver()],
        errorBuilder: (context, state) => Scaffold(
          appBar: AppBar(title: const Text('Error')),
          body: Center(child: Text('Navigation error: ${state.error}')),
        ),
      );
}

class NavigationObserver extends NavigatorObserver {
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    Log.d('Navigated to: ${route.settings.name}');
  }
}
