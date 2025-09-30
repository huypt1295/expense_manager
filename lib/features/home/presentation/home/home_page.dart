import 'package:expense_manager/features/add_expense/presentation/add_expense/bloc/expense_bloc.dart';
import 'package:expense_manager/features/add_expense/presentation/add_expense/expense_form_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_core/flutter_core.dart';

class HomePage extends StatelessWidget {
  const HomePage({
    super.key,
    required this.state,
    required this.child,
  });

  final GoRouterState state;
  final Widget child;

  static const _destinations = <_HomeDestination>[
    _HomeDestination(
      path: '/home/summary',
      icon: Icons.home,
      label: 'Home',
    ),
    _HomeDestination(
      path: '/home/transactions',
      icon: Icons.money,
      label: 'Transactions',
    ),
    _HomeDestination(
      path: '/home/budget',
      icon: Icons.wallet,
      label: 'Budget',
    ),
    _HomeDestination(
      path: '/home/profile',
      icon: Icons.person,
      label: 'Profile',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final location = state.uri.path;
    final currentIndex = _destinations.indexWhere(
      (destination) => location.startsWith(destination.path),
    );
    final selectedIndex = currentIndex == -1 ? 0 : currentIndex;

    return Scaffold(
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          final destination = _destinations[index];
          if (!location.startsWith(destination.path)) {
            context.go(destination.path);
          }
        },
        items: _destinations
            .map(
              (destination) => BottomNavigationBarItem(
                icon: Icon(destination.icon),
                label: destination.label,
              ),
            )
            .toList(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showExpenseForm(context),
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  void _showExpenseForm(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => BlocProvider(
        create: (context) => tpGetIt.get<ExpenseBloc>(),
        child: const ExpenseFormBottomSheet(),
      ),
    );
  }
}

class _HomeDestination {
  const _HomeDestination({
    required this.path,
    required this.icon,
    required this.label,
  });

  final String path;
  final IconData icon;
  final String label;
}
