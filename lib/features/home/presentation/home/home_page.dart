import 'package:expense_manager/core/routing/app_routes.dart';
import 'package:expense_manager/features/transactions/presentation/add_transaction/add_expense_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_common/flutter_common.dart'
    show CurvedNavigationBar, ContextX, CurvedNavigationItem;
import 'package:flutter_core/flutter_core.dart';
import 'home_destinations.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key, required this.state, required this.child});

  final GoRouterState state;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: _buildBottomNav(context),
      body: _buildHomeBody(context),
    );
  }

  Widget _buildHomeBody(BuildContext context) {
    return Container(
      color: context.tpColors.backgroundMain,
      child: SafeArea(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          switchInCurve: Curves.easeInOut,
          switchOutCurve: Curves.easeInOut,
          transitionBuilder: (widget, animation) =>
              FadeTransition(opacity: animation, child: widget),
          child: KeyedSubtree(
            key: ValueKey(state.uri.toString()),
            child: child,
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNav(BuildContext context) {
    final destinations = HomeDestinations.destinations;
    final location = state.uri.path;
    final currentIndex = destinations.indexWhere(
      (destination) => location.startsWith(destination.path),
    );
    final selectedIndex = currentIndex == -1 ? 0 : currentIndex;

    return CurvedNavigationBar(
      selectedIndex: selectedIndex,
      curvedIndex: 2,
      backgroundColor: context.tpColors.backgroundMain,
      curvedBackgroundColor: context.tpColors.surfaceNeutralComponent,
      items: destinations
          .map(
            (destination) => CurvedNavigationItem(
              icon: destination.icon,
              label: destination.label,
            ),
          )
          .toList(),
      onTap: (index) {
        final destination = destinations[index];
        if (destination.path == AppRoute.homeAddTransaction.path) {
          _showAddExpenseForm(context);
        } else if (!location.startsWith(destination.path)) {
          context.go(destination.path);
        }
      },
    );
  }

  void _showAddExpenseForm(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AddExpenseBottomSheet(),
    );
  }
}
