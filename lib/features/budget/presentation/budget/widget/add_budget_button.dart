import 'package:expense_manager/features/budget/presentation/budget/bloc/budget_bloc.dart';
import 'package:expense_manager/features/budget/presentation/budget/bloc/budget_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_core/flutter_core.dart';

class AddBudgetButton extends BaseStatelessWidget {
  const AddBudgetButton({super.key});

  @override
  Widget buildContent(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          onPressed: () =>
              context.read<BudgetBloc>().add(BudgetShowDialogAdd()),
          icon: const Icon(Icons.add),
          label: const Text('Add budget'),
        ),
      ),
    );
  }
}
