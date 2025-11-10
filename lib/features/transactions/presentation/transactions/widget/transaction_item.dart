import 'package:expense_manager/core/enums/transaction_type.dart';
import 'package:expense_manager/features/transactions/domain/entities/transaction_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_common/flutter_common.dart';
import 'package:flutter_core/flutter_core.dart';
import 'package:flutter_resource/flutter_resource.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class TransactionItem extends BaseStatelessWidget {
  const TransactionItem({
    super.key,
    required this.transaction,
    required this.onEdit,
    required this.onDelete,
    this.onShare,
    this.backgroundColor,
    this.borderRadius,
  });

  final TransactionEntity transaction;
  final VoidCallback onEdit;
  final ValueChanged<TransactionEntity> onDelete;
  final VoidCallback? onShare;
  final Color? backgroundColor;
  final BorderRadius? borderRadius;

  @override
  Widget buildContent(BuildContext context) {
    final resolvedBorderRadius = borderRadius ?? BorderRadius.circular(12);
    final resolvedBackgroundColor =
        backgroundColor ?? context.tpColors.surfaceMain;

    return Material(
      color: resolvedBackgroundColor,
      borderRadius: resolvedBorderRadius,
      clipBehavior: Clip.antiAlias,
      child: Slidable(
        key: ValueKey<String>(transaction.id),
        groupTag: "transaction",
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [
            if (onShare != null) _buildShareAction(context),
            _buildEditAction(context),
            _buildDeleteAction(context, resolvedBorderRadius),
          ],
        ),
        child: _buildItem(context),
      ),
    );
  }

  Widget _buildDeleteAction(
    BuildContext context,
    BorderRadius resolvedBorderRadius,
  ) {
    return SlidableAction(
      onPressed: (_) => onDelete(transaction),
      borderRadius: BorderRadius.only(
        topRight: resolvedBorderRadius.topRight,
        bottomRight: resolvedBorderRadius.bottomRight,
      ),
      backgroundColor: context.tpColors.surfaceNegativeComponent,
      foregroundColor: context.tpColors.iconReverse,
      icon: Icons.delete,
    );
  }

  Widget _buildShareAction(BuildContext context) {
    return SlidableAction(
      onPressed: (_) => onShare?.call(),
      backgroundColor: context.tpColors.surfaceNeutralComponent,
      foregroundColor: context.tpColors.iconReverse,
      icon: Icons.share,
    );
  }

  Widget _buildEditAction(BuildContext context) {
    return SlidableAction(
      onPressed: (_) => onEdit(),
      backgroundColor: context.tpColors.surfacePositiveComponent,
      foregroundColor: context.tpColors.iconReverse,
      icon: Icons.edit,
    );
  }

  ListTile _buildItem(BuildContext context) {
    final icon = transaction.categoryIcon?.trim();
    final amountPrefix = transaction.type.isExpense ? '-' : '+';

    return ListTile(
      onTap: onEdit,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      leading: (icon == null || icon.isEmpty)
          ? null
          : Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: context.tpColors.surfaceNeutralComponent2,
                borderRadius: BorderRadius.circular(100),
              ),
              alignment: Alignment.center,
              child: Text(icon, style: TPTextStyle.bodyL),
            ),
      title: Text(transaction.title, style: TPTextStyle.bodyM),
      subtitle: Text(transaction.date.toStringWithFormat(DateFormat.MMMd())),
      trailing: Text(
        '$amountPrefix ${CurrencyUtils.formatVndFromDouble(transaction.amount)}',
        style: TPTextStyle.titleM.copyWith(
          color: transaction.type.isExpense
              ? context.tpColors.textNegative
              : context.tpColors.textPositive,
        ),
      ),
    );
  }
}
