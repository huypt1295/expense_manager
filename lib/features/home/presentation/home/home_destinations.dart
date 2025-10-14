import 'package:expense_manager/core/routing/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_resource/l10n/gen/l10n.dart';

/// Holds the destinations available on the home navigation bar.
class HomeDestinations {
  HomeDestinations._();

  static final destinations = <HomeDestination>[
    HomeDestination(
      path: AppRoute.homeSummary.path,
      icon: Icons.home,
      label: 'Home',
    ),
    HomeDestination(
      path: AppRoute.homeTransactions.path,
      icon: Icons.money,
      label: S.current.tab_transactions,
    ),
    HomeDestination(
      path: AppRoute.homeAddTransaction.path,
      icon: Icons.add,
      label: 'Add',
    ),
    HomeDestination(
      path: AppRoute.homeBudget.path,
      icon: Icons.wallet,
      label: S.current.tab_budget,
    ),
    HomeDestination(
      path: AppRoute.homeProfile.path,
      icon: Icons.person,
      label: S.current.tab_profile,
    ),
  ];
}

class HomeDestination {
  const HomeDestination({
    required this.path,
    required this.icon,
    required this.label,
  });

  final String path;
  final IconData icon;
  final String label;
}
