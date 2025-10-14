import 'package:expense_manager/features/budget/domain/entities/budget_entity.dart';
import 'package:expense_manager/features/budget/domain/entities/budget_progress.dart';
import 'package:flutter/material.dart';
import 'package:flutter_common/flutter_common.dart';
import 'package:flutter_resource/flutter_resource.dart';

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
    final spent = progress?.spentAmount ?? 0;
    final remaining = progress?.remainingAmount ?? budget.limitAmount;
    final limit = budget.limitAmount;
    final percentage = progress?.percentage ?? 0;

    return Dismissible(
      key: ValueKey<String>(budget.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onDelete(),
      background: _buildBackground(context),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: context.tpColors.borderDefault),
          color: context.tpColors.surfaceMain,
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onEdit,
          child: Padding(
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
                    child: Text(
                      budget.categoryIcon ?? "",
                      style: TPTextStyle.bodyL,
                    ),
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
                          text:
                              "/${CurrencyUtils.formatVndFromDouble(limit)}",
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
          ),
        ),
      ),
    );
  }

  Widget _buildBackground(BuildContext context) {
    return Container(
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: context.tpColors.surfaceNegative,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(Icons.delete, color: context.tpColors.iconNegative),
    );
  }
}
