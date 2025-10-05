import 'dart:async';
import 'package:expense_manager/features/budget/presentation/budget/bloc/budget_bloc.dart';
import 'package:expense_manager/features/budget/presentation/budget/bloc/budget_effect.dart';
import 'package:expense_manager/features/budget/presentation/budget/bloc/budget_event.dart';
import 'package:expense_manager/features/budget/presentation/budget/bloc/budget_state.dart';
import 'package:expense_manager/features/budget/presentation/budget/widget/add_budget_button.dart';
import 'package:expense_manager/features/budget/presentation/budget/widget/add_budget_dialog.dart';
import 'package:expense_manager/features/budget/presentation/budget/widget/empty_budget_widget.dart';
import 'package:expense_manager/features/budget/presentation/budget/widget/list_budget_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_core/flutter_core.dart';

class BudgetPage extends BaseStatelessWidget {
  const BudgetPage({super.key});

  @override
  Widget buildContent(BuildContext context) {
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

            return Column(
              children: [
                Expanded(
                  child: state.budgets.isEmpty
                      ? EmptyBudgetWidget()
                      : ListBudgetWidget(
                          budgets: state.budgets,
                          progress: state.progress,
                        ),
                ),
                AddBudgetButton(),
              ],
            );
          },
        ),
      ),
    );
  }

  FutureOr<void> handleEffect(Effect effect, UiActions emitUi) {
    if (effect is BudgetShowErrorEffect) {
      emitUi.showSnackBar(SnackBar(content: Text(effect.message)));
    } else if (effect is BudgetShowDialogAddEffect) {
      emitUi.showDialogSafe(
          builder: (ctx) => BlocProvider.value(
              value: ctx.read<BudgetBloc>(),
              child: AddBudgetDialog(initial: effect.budget)));
    }
  }
}
