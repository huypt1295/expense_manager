import 'package:flutter/material.dart';
import 'package:flutter_common/flutter_common.dart';
import 'package:expense_manager/features/home/presentation/home/home_page.dart';
import 'package:expense_manager/features/auth/presentation/login/login_page.dart';
import 'package:flutter_core/flutter_core.dart';
import 'package:expense_manager/features/auth/domain/repositories/auth_repository.dart';

@singleton
class AppRouter {
  GoRouter get router => GoRouter(
    initialLocation: "/login",
    redirect: (context, state) {
      final authRepository = tpGetIt.get<AuthRepository>();
      final currentUser = authRepository.currentUser;
      final isLoginRoute = state.matchedLocation == '/login';

      // Nếu user đã đăng nhập và đang ở login page, chuyển đến home
      if (currentUser != null && isLoginRoute) {
        return '/home';
      }

      // Nếu user chưa đăng nhập và không ở login page, chuyển đến login
      if (currentUser == null && !isLoginRoute) {
        return '/login';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: "/login",
        builder: (context, state) {
          return const LoginPage();
        },
      ),
      GoRoute(
        path: "/home",
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
    LoggerProvider.instance?.debug('Navigated to: ${route.settings.name}');
  }
}
