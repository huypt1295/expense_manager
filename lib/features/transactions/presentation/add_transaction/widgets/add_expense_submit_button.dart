import 'package:expense_manager/core/enums/transaction_type.dart';
import 'package:expense_manager/features/transactions/presentation/add_transaction/bloc/expense_bloc.dart';
import 'package:expense_manager/features/transactions/presentation/add_transaction/bloc/expense_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_common/flutter_common.dart';
import 'package:flutter_core/flutter_core.dart';
import 'package:flutter_resource/l10n/gen/l10n.dart';

class AddExpenseSubmitButton extends BaseStatelessWidget {
  const AddExpenseSubmitButton({
    super.key,
    required this.type,
    required this.onPressed,
  });

  final TransactionType type;
  final VoidCallback onPressed;

  @override
  Widget buildContent(BuildContext context) {
    return BlocBuilder<ExpenseBloc, ExpenseState>(
      builder: (context, state) {
        final isLoading = state is ExpenseFormLoading;
        return CommonPrimaryButton(
          onPressed: onPressed,
          isLoading: isLoading,
          child: Text(
            type == TransactionType.expense
                ? S.current.add_expense
                : S.current.add_income,
            style: TextStyle(fontSize: 16),
          ),
        );
      },
    );
  }
}
