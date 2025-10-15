import 'dart:async';
import 'package:expense_manager/features/budget/domain/entities/budget_entity.dart';
import 'package:expense_manager/features/budget/presentation/budget/bloc/budget_bloc.dart';
import 'package:expense_manager/features/budget/presentation/budget/bloc/budget_effect.dart';
import 'package:expense_manager/features/budget/presentation/budget/bloc/budget_event.dart';
import 'package:expense_manager/features/budget/presentation/budget/bloc/budget_state.dart';
import 'package:expense_manager/core/enums/transaction_type.dart';
import 'package:expense_manager/features/budget/presentation/budget/widget/add_budget_button.dart';
import 'package:expense_manager/features/budget/presentation/budget/widget/add_budget/add_budget_bottom_sheet.dart';
import 'package:expense_manager/features/budget/presentation/budget/widget/budget_empty_widget.dart';
import 'package:expense_manager/features/budget/presentation/budget/widget/budget_list_widget.dart';
import 'package:expense_manager/features/budget/presentation/budget/widget/budget_overview_widget.dart';
import 'package:expense_manager/features/budget/presentation/budget/widget/chart/budget_chart_widget.dart';
import 'package:expense_manager/features/transactions/domain/entities/transaction_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_common/flutter_common.dart'
    show UndoSnackBarContent, DateTimeExtensions, MonthSelectorBar, ContextX;
import 'package:flutter_core/flutter_core.dart';

class BudgetPage extends BaseStatefulWidget {
  const BudgetPage({super.key});

  @override
  State<BudgetPage> createState() => _BudgetPageState();
}

class _BudgetPageState extends BaseState<BudgetPage> {
  late DateTime _selectedMonth;

  @override
  void onInitState() {
    super.onInitState();
    final now = DateTime.now();
    _selectedMonth = DateTime(now.year, now.month);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          tpGetIt.get<BudgetBloc>()..add(const BudgetStarted()),
      child: EffectBlocListener<BudgetState, BudgetEffect, BudgetBloc>(
        listener: handleEffect,
        child: BlocBuilder<BudgetBloc, BudgetState>(
          builder: (context, state) {
            if (state.isLoading && state.budgets.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }

            final budgetsByMonth = state.budgets
                .where(_isBudgetInMonth)
                .toList();
            final spendingTransactionsByMonth = state.transactions
                .where((transaction) => transaction.type.isExpense)
                .where(_isTransactionInMonth)
                .toList();

            return ColoredBox(
              color: context.tpColors.backgroundMain,
              child: Stack(
                children: [
                  CustomScrollView(
                    slivers: [
                      _buildMonthSelectorWidget(),
                      _buildBudgetOverviewWidget(
                        budgetsByMonth,
                        spendingTransactionsByMonth,
                      ),
                      _buildChart(budgetsByMonth),
                      _buildListRecentBudget(budgetsByMonth, state),
                    ],
                  ),
                  _buildSubmitButton(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildMonthSelectorWidget() {
    return MonthSelectorBar(
      selectedMonth: _selectedMonth,
      onNext: _goToNextMonth,
      onPrevious: _goToPreviousMonth,
    );
  }

  Widget _buildBudgetOverviewWidget(
    List<BudgetEntity> budgetsByMonth,
    List<TransactionEntity> spendingTransactionsByMonth,
  ) {
    return SliverToBoxAdapter(
      child: BudgetOverviewWidget(
        budgets: budgetsByMonth,
        transactions: spendingTransactionsByMonth,
      ),
    );
  }

  Widget _buildChart(List<BudgetEntity> budgetsByMonth) {
    return SliverToBoxAdapter(
      child: BudgetChartWidget(budgets: budgetsByMonth),
    );
  }

  Widget _buildListRecentBudget(
    List<BudgetEntity> budgetsByMonth,
    BudgetState state,
  ) {
    return budgetsByMonth.isEmpty
        ? SliverToBoxAdapter(child: const BudgetEmptyWidget())
        : BudgetSliverListWidget(
            budgets: budgetsByMonth,
            progress: state.progress,
          );
  }

  Widget _buildSubmitButton() =>
      Positioned(bottom: 16, right: 16, child: AddBudgetButton());

  FutureOr<void> handleEffect(Effect effect, UiActions emitUi) {
    if (effect is BudgetShowErrorEffect) {
      emitUi.showSnackBar(SnackBar(content: Text(effect.message)));
    } else if (effect is BudgetShowDialogAddEffect) {
      emitUi(
        (uiContext) => showModalBottomSheet(
          context: uiContext,
          useRootNavigator: true,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (context) => BlocProvider.value(
            value: uiContext.read<BudgetBloc>(),
            child: AddBudgetBottomSheet(initial: effect.budget),
          ),
        ),
      );
    } else if (effect is BudgetShowUndoDeleteEffect) {
      emitUi.showSnackBar(
        SnackBar(
          duration: effect.duration,
          content: UndoSnackBarContent(
            message: effect.message,
            label: effect.actionLabel,
            duration: effect.duration,
            onUndo: () {
              emitUi.call((context) {
                context.read<BudgetBloc>().add(
                  const BudgetDeleteUndoRequested(),
                );
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
              });
            },
          ),
        ),
      );
    }
  }

  bool _isBudgetInMonth(BudgetEntity budget) {
    final monthStart = DateTime(_selectedMonth.year, _selectedMonth.month);
    final nextMonthStart = DateTime(monthStart.year, monthStart.month + 1);
    return !budget.endDate.isBefore(monthStart) &&
        budget.startDate.isBefore(nextMonthStart);
  }

  bool _isTransactionInMonth(TransactionEntity transaction) {
    final monthStart = DateTime(_selectedMonth.year, _selectedMonth.month);
    final nextMonthStart = DateTime(monthStart.year, monthStart.month + 1);
    return !transaction.date.isBefore(monthStart) &&
        transaction.date.isBefore(nextMonthStart);
  }

  void _goToPreviousMonth() {
    setState(() {
      _selectedMonth = _selectedMonth.previousMonth;
    });
  }

  void _goToNextMonth() {
    setState(() {
      _selectedMonth = _selectedMonth.nextMonth;
    });
  }
}
