import 'package:expense_manager/features/budget/domain/entities/budget_entity.dart';
import 'package:expense_manager/features/budget/domain/entities/budget_progress.dart';
import 'package:flutter/material.dart';
import 'package:flutter_common/flutter_common.dart';
import 'package:flutter_resource/flutter_resource.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class BudgetItem extends StatelessWidget {
  const BudgetItem({
    super.key,
    required this.budget,
    required this.progress,
    required this.onEdit,
    required this.onDelete,
  });

  final BudgetEntity budget;
  final BudgetProgress? progress;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: context.tpColors.borderDefault),
        color: context.tpColors.surfaceMain,
      ),
      child: Slidable(
        key: ValueKey<String>(budget.id),
        groupTag: "budget",
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [_buildEditAction(context), _buildDeleteAction(context)],
        ),
        child: _buildItem(context),
      ),
    );
  }

  Widget _buildDeleteAction(BuildContext context) {
    return SlidableAction(
      onPressed: (_) => onDelete(),
      borderRadius: BorderRadius.horizontal(right: Radius.circular(12)),
      backgroundColor: context.tpColors.surfaceNegativeComponent,
      foregroundColor: context.tpColors.iconReverse,
      icon: Icons.delete,
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

  Widget _buildItem(BuildContext context) {
    final spent = progress?.spentAmount ?? 0;
    final limit = budget.limitAmount;
    final percentage = progress?.percentage ?? 0;
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            onTap: onEdit,
            contentPadding: EdgeInsets.zero,
            leading: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: context.tpColors.surfaceNeutralComponent2,
                borderRadius: BorderRadius.circular(100),
              ),
              alignment: Alignment.center,
              child: Text(budget.categoryIcon ?? "", style: TPTextStyle.bodyL),
            ),
            title: Text(budget.category, style: TPTextStyle.titleS),
            subtitle: Text(DateFormat.yM().format(budget.startDate)),
            trailing: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                children: [
                  TextSpan(
                    text: "${CurrencyUtils.formatVndFromDouble(spent)}\n",
                    style: TPTextStyle.bodyL.copyWith(
                      color: context.tpColors.textMain,
                    ),
                  ),
                  TextSpan(
                    text: "/${CurrencyUtils.formatVndFromDouble(limit)}",
                    style: TPTextStyle.captionM.copyWith(
                      color: context.tpColors.textSub,
                    ),
                  ),
                ],
              ),
            ),
          ),
          LinearProgressIndicator(
            value: percentage.clamp(0.0, 1.0),
            minHeight: 8,
            borderRadius: BorderRadius.circular(16),
          ),
        ],
      ),
    );
  }
}
