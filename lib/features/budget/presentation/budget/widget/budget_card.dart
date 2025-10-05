import 'package:expense_manager/features/budget/domain/entities/budget_entity.dart';
import 'package:expense_manager/features/budget/domain/entities/budget_progress.dart';
import 'package:flutter/material.dart';
import 'package:flutter_common/flutter_common.dart';

class BudgetCard extends StatelessWidget {
  const BudgetCard({
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
    final theme = Theme.of(context);
    final spent = progress?.spentAmount ?? 0;
    final remaining = progress?.remainingAmount ?? budget.limitAmount;
    final limit = budget.limitAmount;
    final percentage = progress?.percentage ?? 0;
    final remainingStyle = remaining < 0
        ? theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.error)
        : theme.textTheme.bodyMedium;

    return Dismissible(
      key: ValueKey<String>(budget.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onDelete(),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: theme.colorScheme.error,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(Icons.delete, color: theme.colorScheme.onError),
      ),
      child: Material(
        borderRadius: BorderRadius.circular(12),
        color: theme.colorScheme.surface,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onEdit,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  budget.category,
                  style: theme.textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: percentage.clamp(0.0, 1.0),
                  minHeight: 8,
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Spent: ${CurrencyUtils.formatVndFromDouble(spent)}',
                      style: theme.textTheme.bodyMedium,
                    ),
                    Text(
                      'Remaining: ${CurrencyUtils.formatVndFromDouble(remaining)}',
                      style: remainingStyle,
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    'Limit: ${CurrencyUtils.formatVndFromDouble(limit)}',
                    style:
                        theme.textTheme.bodySmall ?? theme.textTheme.bodyMedium,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
