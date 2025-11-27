import 'package:expense_manager/core/enums/transaction_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter_common/flutter_common.dart';
import 'package:flutter_core/flutter_core.dart';
import 'package:flutter_resource/flutter_resource.dart';

class AddExpenseOrIncomeSelection extends BaseStatelessWidget {
  const AddExpenseOrIncomeSelection({
    super.key,
    required this.selectedType,
    required this.onTypeChanged,
  });

  final TransactionType selectedType;
  final ValueChanged<TransactionType> onTypeChanged;

  @override
  Widget buildContent(BuildContext context) {
    return Row(
      children: [_buildExpenseButton(context), _buildIncomeButton(context)],
    );
  }

  Widget _buildIncomeButton(BuildContext context) {
    final isSelected = selectedType == TransactionType.income;
    return Expanded(
      child: CommonPrimaryButton(
        onPressed: () => onTypeChanged.call(TransactionType.income),
        backgroundColor: isSelected
            ? context.tpColors.surfacePositiveComponent
            : context.tpColors.surfaceSub,
        padding: EdgeInsets.only(left: 4, right: 16),
        child: Text(
          S.current.income,
          style: TPTextStyle.captionM.copyWith(
            color: isSelected
                ? context.tpColors.textReverse
                : context.tpColors.textMain,
          ),
        ),
      ),
    );
  }

  Widget _buildExpenseButton(BuildContext context) {
    final isSelected = selectedType == TransactionType.expense;
    return Expanded(
      child: CommonPrimaryButton(
        onPressed: () => onTypeChanged.call(TransactionType.expense),
        backgroundColor: isSelected
            ? context.tpColors.surfaceNegativeComponent
            : context.tpColors.surfaceSub,
        padding: EdgeInsets.only(left: 16, right: 4),
        child: Text(
          S.current.expense,
          style: TPTextStyle.captionM.copyWith(
            color: isSelected
                ? context.tpColors.textReverse
                : context.tpColors.textMain,
          ),
        ),
      ),
    );
  }
}
