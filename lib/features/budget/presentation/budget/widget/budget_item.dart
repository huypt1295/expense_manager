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
    final remainingStyle = remaining < 0
        ? TPTextStyle.bodyM.copyWith(color: context.tpColors.textNegative)
        : TPTextStyle.bodyM;

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
                Text(budget.category, style: TPTextStyle.titleM),
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: percentage.clamp(0.0, 1.0),
                  minHeight: 8,
                ),
                const SizedBox(height: 8),
                _buildSpendAndRemainingWidget(spent, remainingStyle, remaining),
                const SizedBox(height: 4),
                _buildLimitWidget(limit),
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

  Widget _buildSpendAndRemainingWidget(
    double spent,
    TextStyle remainingStyle,
    double remaining,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          children: [
            Text('Spent', style: TPTextStyle.bodyM),
            Text(
              CurrencyUtils.formatVndFromDouble(spent),
              style: TPTextStyle.bodyM,
            ),
          ],
        ),
        Column(
          children: [
            Text('Remaining', style: remainingStyle),
            Text(
              CurrencyUtils.formatVndFromDouble(remaining),
              style: remainingStyle,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildLimitWidget(double limit) {
    return Align(
      alignment: Alignment.centerRight,
      child: Text(
        'Limit: ${CurrencyUtils.formatVndFromDouble(limit)}',
        style: TPTextStyle.bodyM,
      ),
    );
  }
}
