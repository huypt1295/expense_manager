import 'package:expense_manager/core/enums/transaction_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter_common/flutter_common.dart';
import 'package:flutter_core/flutter_core.dart';
import 'package:flutter_resource/flutter_resource.dart';

class AddExpenseOrIncomeSelection extends BaseStatelessWidget {
  const AddExpenseOrIncomeSelection({super.key, required this.onTypeChanged});

  final ValueChanged<TransactionType> onTypeChanged;

  @override
  Widget buildContent(BuildContext context) {
    return Row(
      children: [_buildExpenseButton(context), _buildIncomeButton(context)],
    );
  }

  Widget _buildIncomeButton(BuildContext context) {
    return Expanded(
      child: CommonPrimaryButton(
        onPressed: () => onTypeChanged.call(TransactionType.income),
        backgroundColor: context.tpColors.surfacePositiveComponent,
        padding: EdgeInsets.only(left: 4, right: 16),
        child: Text(
          S.current.income,
          style: TPTextStyle.captionM.copyWith(
            color: context.tpColors.textReverse,
          ),
        ),
      ),
    );
  }

  Widget _buildExpenseButton(BuildContext context) {
    return Expanded(
      child: CommonPrimaryButton(
        onPressed: () => onTypeChanged.call(TransactionType.expense),
        backgroundColor: context.tpColors.surfaceNegativeComponent,
        padding: EdgeInsets.only(left: 16, right: 4),
        child: Text(
          S.current.expense,
          style: TPTextStyle.captionM.copyWith(
            color: context.tpColors.textReverse,
          ),
        ),
      ),
    );
  }
}
