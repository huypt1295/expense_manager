import 'package:expense_manager/features/add_expense/presentation/add_expense/bloc/expense_bloc.dart';
import 'package:expense_manager/features/add_expense/presentation/add_expense/expense_form_bottom_sheet.dart';
import 'package:expense_manager/features/budget/presentation/budget/budget_page.dart';
import 'package:expense_manager/features/home/presentation/home/home_tab.dart';
import 'package:expense_manager/features/profile_setting/presentation/profile/profile_setting_page.dart';
import 'package:expense_manager/features/transactions/presentation/transactions/transaction_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_core/flutter_core.dart';
import 'package:flutter_resource/flutter_resource.dart';

class HomePage extends BaseStatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  static const List<Widget> _tabs = [
    HomeTab(),
    TransactionPage(),
    BudgetPage(),
    ProfilePage(),
  ];

  List<BottomNavigationBarItem> _tabItems(BuildContext context) {
    return [
      BottomNavigationBarItem(
          icon: const Icon(Icons.home), label: L10n.of(context).tab_home),
      BottomNavigationBarItem(
          icon: const Icon(Icons.money),
          label: L10n.of(context).tab_transactions),
      BottomNavigationBarItem(
          icon: const Icon(Icons.wallet), label: L10n.of(context).tab_budget),
      BottomNavigationBarItem(
          icon: const Icon(Icons.person), label: L10n.of(context).tab_profile),
    ];
  }

  void _onTabChanged(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _showExpenseForm() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => BlocProvider(
        create: (context) => ExpenseBloc(),
        child: const ExpenseFormBottomSheet(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _tabs[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: _onTabChanged,
        items: _tabItems(context),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showExpenseForm,
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
