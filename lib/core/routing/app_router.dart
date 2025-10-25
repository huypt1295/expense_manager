import 'dart:async';

import 'package:expense_manager/core/auth/current_user.dart';
import 'package:expense_manager/core/routing/app_routes.dart';
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
  bool _allowLoginGuardBypassOnce = false;
  GoRouter? _router;

  /// Allows the next navigation to `/login` to bypass the authenticated guard.
  void allowLoginGuardBypassOnce() {
    _allowLoginGuardBypassOnce = true;
  }

  GoRouter router(GARouteObserver gaObs, CrashRouteObserver crashObs) {
    _router ??= _buildRouter(gaObs, crashObs);
    return _router!;
  }

  GoRouter _buildRouter(GARouteObserver gaObs, CrashRouteObserver crashObs) {
    final currentUser = tpGetIt.get<CurrentUser>();
    final refresh = GoRouterRefreshStream(currentUser.watch());

    return GoRouter(
      navigatorKey: _rootNavigatorKey,
      initialLocation: AppRoute.login.path,
      refreshListenable: refresh,
      redirect: (context, state) {
        final snapshot = currentUser.now();
        final isAuthenticated = snapshot?.isAuthenticated ?? false;
        final location = state.uri.path;
        final loggingIn = location == AppRoute.login.path;
        final atHome = location.startsWith(AppRoute.home.path);
        final skipLoginGuard = _allowLoginGuardBypassOnce;
        if (_allowLoginGuardBypassOnce) {
          _allowLoginGuardBypassOnce = false;
        }

        if (!isAuthenticated && atHome) {
          return AppRoute.login.path;
        }

        if (isAuthenticated && loggingIn && !skipLoginGuard) {
          return AppRoute.homeSummary.path;
        }

        return null;
      },
      routes: [
        GoRoute(
          path: AppRoute.login.path,
          builder: (context, state) => const LoginPage(),
        ),
        GoRoute(
          path: AppRoute.home.path,
          redirect: (context, state) => AppRoute.homeSummary.path,
        ),
        ShellRoute(
          navigatorKey: _homeNavigatorKey,
          builder: (context, state, child) {
            return HomePage(state: state, child: child);
          },
          routes: [
            GoRoute(
              path: AppRoute.homeSummary.path,
              pageBuilder: (context, state) {
                return CustomTransitionPage(
                  key: state.pageKey,
                  child: SummaryPage(),
                  transitionsBuilder: (_, animation, _, child) {
                    return FadeTransition(
                      opacity: CurveTween(
                        curve: Curves.easeInOutCirc,
                      ).animate(animation),
                      child: child,
                    );
                  },
                );
              },
            ),
            GoRoute(
              path: AppRoute.homeTransactions.path,
              pageBuilder: (context, state) {
                return CustomTransitionPage(
                  key: state.pageKey,
                  child: TransactionPage(),
                  transitionsBuilder: (_, animation, _, child) {
                    return FadeTransition(
                      opacity: CurveTween(
                        curve: Curves.easeInOutCirc,
                      ).animate(animation),
                      child: child,
                    );
                  },
                );
              },
            ),
            GoRoute(
              path: AppRoute.homeBudget.path,
              pageBuilder: (context, state) {
                return CustomTransitionPage(
                  key: state.pageKey,
                  child: BudgetPage(),
                  transitionsBuilder: (_, animation, _, child) {
                    return FadeTransition(
                      opacity: CurveTween(
                        curve: Curves.easeInOutCirc,
                      ).animate(animation),
                      child: child,
                    );
                  },
                );
              },
            ),
            GoRoute(
              path: AppRoute.homeProfile.path,
              pageBuilder: (context, state) {
                return CustomTransitionPage(
                  key: state.pageKey,
                  child: ProfilePage(),
                  transitionsBuilder: (_, animation, _, child) {
                    return FadeTransition(
                      opacity: CurveTween(
                        curve: Curves.easeInOutCirc,
                      ).animate(animation),
                      child: child,
                    );
                  },
                );
              },
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
