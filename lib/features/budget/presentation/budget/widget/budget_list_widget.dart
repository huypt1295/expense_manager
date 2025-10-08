import 'package:expense_manager/features/budget/domain/entities/budget_entity.dart';
import 'package:expense_manager/features/budget/domain/entities/budget_progress.dart';
import 'package:expense_manager/features/budget/presentation/budget/bloc/budget_bloc.dart';
import 'package:expense_manager/features/budget/presentation/budget/bloc/budget_event.dart';
import 'package:expense_manager/features/budget/presentation/budget/widget/budget_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_core/flutter_core.dart';

class BudgetListWidget extends BaseStatelessWidget {
  const BudgetListWidget(
      {super.key, required this.budgets, required this.progress});

  final List<BudgetEntity> budgets;
  final Map<String, BudgetProgress> progress;

  @override
  Widget buildContent(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 24,
      ),
      itemCount: budgets.length,
      separatorBuilder: (_, _) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final budget = budgets[index];
        final progress = this.progress[budget.id];
        return BudgetItem(
          budget: budget,
          progress: progress,
          onEdit: () => context
              .read<BudgetBloc>()
              .add(BudgetShowDialogAdd(budget: budget)),
          onDelete: () =>
              context.read<BudgetBloc>().add(BudgetDeleteRequested(budget)),
        );
      },
    );
  }
}
