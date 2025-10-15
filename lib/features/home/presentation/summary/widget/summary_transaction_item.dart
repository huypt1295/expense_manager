import 'package:expense_manager/core/enums/transaction_type.dart';
import 'package:expense_manager/features/transactions/domain/entities/transaction_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_common/flutter_common.dart';
import 'package:flutter_core/flutter_core.dart';
import 'package:flutter_resource/flutter_resource.dart';

class SummaryTransactionItem extends BaseStatelessWidget {
  const SummaryTransactionItem({super.key, required this.transaction});

  final TransactionEntity transaction;

  @override
  Widget buildContent(BuildContext context) {
    final icon = transaction.categoryIcon?.trim();
    final amountPrefix = transaction.type.isExpense ? '-' : '+';

    return Material(
      color: Colors.transparent,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        leading: (icon == null || icon.isEmpty)
            ? null
            : Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: context.tpColors.surfaceNeutralComponent2,
                  borderRadius: BorderRadius.circular(100),
                ),
                alignment: Alignment.center,
                child: Text(icon, style: TPTextStyle.bodyL),
              ),
        title: Text(transaction.title),
        subtitle: Text(transaction.date.toStringWithFormat(DateFormat.MMMd())),
        trailing: Text(
          '$amountPrefix ${CurrencyUtils.formatVndFromDouble(transaction.amount)}',
          style: TPTextStyle.titleM.copyWith(
            color: transaction.type.isExpense
                ? context.tpColors.textNegative
                : context.tpColors.textPositive,
          ),
        ),
      ),
    );
  }
}
