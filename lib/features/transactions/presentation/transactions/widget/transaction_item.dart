import 'package:expense_manager/features/transactions/domain/entities/transaction_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_common/flutter_common.dart';
import 'package:flutter_core/flutter_core.dart';
import 'package:flutter_resource/flutter_resource.dart';

class TransactionItem extends BaseStatelessWidget {
  const TransactionItem({
    super.key,
    required this.transaction,
    required this.onEdit,
    required this.onDelete,
  });

  final TransactionEntity transaction;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget buildContent(BuildContext context) {
    return Dismissible(
      key: ValueKey<String>(transaction.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onDelete(),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: context.tpColors.surfaceNegative,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(Icons.delete, color: context.tpColors.iconNegative),
      ),
      child: Material(
        color: context.tpColors.surfaceMain,
        borderRadius: BorderRadius.circular(12),
        child: ListTile(
          onTap: onEdit,
          title: Text(transaction.title, style: TPTextStyle.bodyM),
          subtitle: Text(
            [
              transaction.date.toStringWithFormat(DateFormat.yMMMd()),
              if ((transaction.category ?? '').isNotEmpty) transaction.category,
            ].whereType<String>().join(' · '),
          ),
          trailing: Text(
            CurrencyUtils.formatVndFromDouble(transaction.amount),
            style: TPTextStyle.bodyL,
          ),
        ),
      ),
    );
  }
}
