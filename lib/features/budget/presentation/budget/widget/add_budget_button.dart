import 'package:expense_manager/features/budget/presentation/budget/bloc/budget_bloc.dart';
import 'package:expense_manager/features/budget/presentation/budget/bloc/budget_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_common/flutter_common.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_core/flutter_core.dart';

class AddBudgetButton extends BaseStatelessWidget {
  const AddBudgetButton({super.key, this.enabled = true});

  final bool enabled;

  @override
  Widget buildContent(BuildContext context) {
    return FloatingActionButton(
      onPressed: enabled
          ? () => context.read<BudgetBloc>().add(BudgetShowDialogAdd())
          : null,
      backgroundColor: context.tpColors.surfaceNeutralComponent,
      foregroundColor: context.tpColors.iconReverse,
      child: const Icon(Icons.add),
    );
  }
}
