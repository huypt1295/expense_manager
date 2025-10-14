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

    return Material(
      borderRadius: BorderRadius.circular(12),
      color: context.tpColors.backgroundMain,
      child: ListTile(
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
        subtitle: Text(
          [
            transaction.date.toStringWithFormat(DateFormat.MMMd()),
            if ((transaction.category ?? '').isNotEmpty) transaction.category,
          ].whereType<String>().join(' · '),
        ),
        trailing: Text(
          CurrencyUtils.formatVndFromDouble(transaction.amount),
          style: TPTextStyle.bodyInfoM,
        ),
      ),
    );
  }
}
