import 'package:expense_manager/features/budget/presentation/budget/bloc/budget_bloc.dart';
import 'package:expense_manager/features/budget/presentation/budget/bloc/budget_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_common/flutter_common.dart';
import 'package:flutter_core/flutter_core.dart';

class AddBudgetButton extends BaseStatelessWidget {
  const AddBudgetButton({super.key});

  @override
  Widget buildContent(BuildContext context) {
    return FloatingActionButton(
      onPressed: () =>
          context.read<BudgetBloc>().add(BudgetShowDialogAdd()),
      backgroundColor: context.tpColors.surfaceNeutralComponent,
      foregroundColor: context.tpColors.iconReverse,
      child: Icon(Icons.add),
    );
  }
}
