import 'dart:async';

import 'package:expense_manager/core/auth/current_user.dart';
import 'package:expense_manager/features/auth/presentation/login/login_page.dart';
import 'package:expense_manager/features/budget/presentation/budget/budget_page.dart';
import 'package:expense_manager/features/home/presentation/home/home_page.dart';
import 'package:expense_manager/features/home/presentation/summary/summary_page.dart';
import 'package:expense_manager/features/profile_setting/presentation/profile/profile_setting_page.dart';
import 'package:expense_manager/features/transactions/presentation/transactions/transaction_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_core/flutter_core.dart';

@singleton
class AppRouter {
  AppRouter();

  final _rootNavigatorKey = GlobalKey<NavigatorState>();
  final _homeNavigatorKey = GlobalKey<NavigatorState>();

  GoRouter router(GARouteObserver gaObs, CrashRouteObserver crashObs) {
    final currentUser = tpGetIt.get<CurrentUser>();
    final refresh = GoRouterRefreshStream(currentUser.watch());

    return GoRouter(
      navigatorKey: _rootNavigatorKey,
      initialLocation: '/login',
      refreshListenable: refresh,
      redirect: (context, state) {
        final snapshot = currentUser.now();
        final isAuthenticated = snapshot?.isAuthenticated ?? false;
        final location = state.uri.path;
        final loggingIn = location == '/login';
        final atHome = location.startsWith('/home');

        if (!isAuthenticated && atHome) {
          return '/login';
        }

        if (isAuthenticated && loggingIn) {
          return '/home/summary';
        }

        return null;
      },
      routes: [
        GoRoute(
          path: '/login',
          builder: (context, state) => const LoginPage(),
        ),
        GoRoute(
          path: '/home',
          redirect: (context, state) => '/home/summary',
        ),
        ShellRoute(
          navigatorKey: _homeNavigatorKey,
          builder: (context, state, child) {
            return HomePage(state: state, child: child);
          },
          routes: [
            GoRoute(
              path: '/home/summary',
              builder: (context, state) => const SummaryPage(),
            ),
            GoRoute(
              path: '/home/transactions',
              builder: (context, state) => const TransactionPage(),
            ),
            GoRoute(
              path: '/home/budget',
              builder: (context, state) => const BudgetPage(),
            ),
            GoRoute(
              path: '/home/profile',
              builder: (context, state) => const ProfilePage(),
            ),
          ],
        ),
      ],
      observers: [gaObs, crashObs],
      errorBuilder: (context, state) => Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: Center(child: Text('Navigation error: ${state.error}')),
      ),
    );
  }
}

class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    _subscription = stream.listen((_) => notifyListeners());
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
