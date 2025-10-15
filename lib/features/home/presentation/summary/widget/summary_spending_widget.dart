import 'package:flutter/material.dart';
import 'package:flutter_common/flutter_common.dart';
import 'package:flutter_core/flutter_core.dart';
import 'package:flutter_resource/flutter_resource.dart';

class SummarySpendingWidget extends BaseStatelessWidget {
  const SummarySpendingWidget({
    super.key,
    required this.expense,
    required this.income,
    required this.remaining,
  });

  final double expense;
  final double income;
  final double remaining;

  @override
  Widget buildContent(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: context.tpColors.surfaceNeutralComponent,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // income
          Text(
            S.current.income,
            style: TPTextStyle.labelS.copyWith(
              color: context.tpColors.textReverse,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            CurrencyUtils.formatVndFromDouble(income),
            style: TPTextStyle.titleL.copyWith(
              color: context.tpColors.textReverse,
            ),
          ),
          const SizedBox(height: 16),
          // expense
          Text(
            S.current.expense,
            style: TPTextStyle.labelS.copyWith(
              color: context.tpColors.textReverse,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            CurrencyUtils.formatVndFromDouble(expense),
            style: TPTextStyle.titleL.copyWith(
              color: context.tpColors.textReverse,
            ),
          ),
          const SizedBox(height: 16),
          Divider(
            height: 2,
            thickness: 1,
            color: context.tpColors.borderDefault,
          ),
          const SizedBox(height: 16),
          // remaining
          Text(
            S.current.remaining,
            style: TPTextStyle.labelS.copyWith(
              color: context.tpColors.textReverse,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            CurrencyUtils.formatVndFromDouble(remaining),
            style: TPTextStyle.titleL.copyWith(
              color: context.tpColors.textReverse,
            ),
          ),
        ],
      ),
    );
  }
}
