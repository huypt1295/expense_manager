import 'package:expense_manager/features/transactions/domain/entities/transaction_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_common/flutter_common.dart';
import 'package:flutter_core/flutter_core.dart';
import 'package:flutter_resource/flutter_resource.dart';

class SummaryTransactionItem extends BaseStatelessWidget {
  const SummaryTransactionItem({
    super.key,
    required this.transaction,
  });

  final TransactionEntity transaction;

  @override
  Widget buildContent(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(12),
      color: context.tpColors.backgroundMain,
      child: ListTile(
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
