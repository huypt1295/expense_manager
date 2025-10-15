import 'package:expense_manager/core/routing/app_routes.dart';
import 'package:expense_manager/features/home/presentation/summary/widget/summary_transaction_item.dart';
import 'package:expense_manager/features/transactions/domain/entities/transaction_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_common/flutter_common.dart';
import 'package:flutter_core/flutter_core.dart';
import 'package:flutter_resource/flutter_resource.dart';

class SummarySliverListTransactionWidget extends BaseStatelessWidget {
  const SummarySliverListTransactionWidget({
    super.key,
    required this.recentTransactions,
  });

  final List<TransactionEntity> recentTransactions;

  @override
  Widget buildContent(BuildContext context) {
    final hasTransactions = recentTransactions.isNotEmpty;
    final backgroundColor = context.tpColors.surfaceMain;
    final borderColor = context.tpColors.borderDefault;
    const radius16 = Radius.circular(16);

    return SliverList(
      delegate: SliverChildBuilderDelegate((context, index) {
        if (index == 0) {
          final headerBorderRadius = BorderRadius.vertical(
            top: radius16,
            bottom: hasTransactions ? Radius.zero : radius16,
          );

          return DecoratedBox(
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: headerBorderRadius,
              border: Border.all(color: borderColor),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      S.current.recent_transactions,
                      style: TPTextStyle.titleS.copyWith(
                        color: context.tpColors.textMain,
                      ),
                    ),
                  ),
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => context.go(AppRoute.homeTransactions.path),
                    child: Text(
                      S.current.see_all,
                      style: TPTextStyle.bodyM.copyWith(
                        color: context.tpColors.textLink,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        final transactionIndex = index - 1;
        if (transactionIndex >= recentTransactions.length) {
          return const SizedBox.shrink();
        }

        final transaction = recentTransactions[transactionIndex];
        final isLast = transactionIndex == recentTransactions.length - 1;

        final decoration = BoxDecoration(
          color: backgroundColor,
          borderRadius: isLast
              ? const BorderRadius.vertical(bottom: radius16)
              : BorderRadius.zero,
          border: Border(
            left: BorderSide(color: borderColor),
            right: BorderSide(color: borderColor),
            bottom: BorderSide(color: borderColor),
          ),
        );

        return DecoratedBox(
          decoration: decoration,
          child: SummaryTransactionItem(transaction: transaction),
        );
      }, childCount: hasTransactions ? recentTransactions.length + 1 : 1),
    );
  }
}
