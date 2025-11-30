import 'dart:math' as math;

import 'package:expense_manager/features/budget/domain/entities/budget_entity.dart';
import 'package:expense_manager/features/transactions/domain/entities/transaction_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_common/flutter_common.dart';
import 'package:flutter_core/flutter_core.dart';
import 'package:flutter_resource/flutter_resource.dart';

class BudgetOverviewWidget extends BaseStatelessWidget {
  const BudgetOverviewWidget({
    super.key,
    required this.budgets,
    required this.transactions,
  });

  final List<BudgetEntity> budgets;
  final List<TransactionEntity> transactions;

  double get totalLimit =>
      budgets.fold<double>(0, (sum, budget) => sum + budget.limitAmount);

  double get totalSpent => transactions.fold<double>(
    0,
    (sum, transaction) => sum + math.max(transaction.amount, 0),
  );

  @override
  Widget buildContent(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: context.tpColors.surfaceNeutralComponent,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            S.current.total_budget,
            style: TPTextStyle.bodyM.copyWith(
              color: context.tpColors.textReverse,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            CurrencyUtils.formatVndFromDouble(totalLimit),
            style: TPTextStyle.titleL.copyWith(
              color: context.tpColors.textReverse,
            ),
          ),
          _progressBudgetsWidget(context),
        ],
      ),
    );
  }

  Widget _progressBudgetsWidget(BuildContext context) {
    final remaining = math.max(totalLimit - totalSpent, 0);
    final progress = totalLimit <= 0
        ? 0.0
        : (totalSpent / totalLimit).clamp(0.0, 1.0);
    final percentageLabel = '${(progress * 100).toStringAsFixed(0)}%';

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Đã chi",
              style: TPTextStyle.bodyM.copyWith(
                color: context.tpColors.textReverse,
              ),
            ),
            Text(
              percentageLabel,
              style: TPTextStyle.titleS.copyWith(
                color: context.tpColors.textReverse,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 12,
            backgroundColor: context.tpColors.textReverse.withValues(alpha: 0.2),
            valueColor: AlwaysStoppedAnimation<Color>(
              context.tpColors.textReverse,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              CurrencyUtils.formatVndFromDouble(totalSpent),
              style: TPTextStyle.titleM.copyWith(
                color: context.tpColors.textReverse,
              ),
            ),
            Text(
              "Còn lại ${CurrencyUtils.formatVndFromDouble(remaining.toDouble())}",
              style: TPTextStyle.bodyS.copyWith(
                color: context.tpColors.textReverse,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
