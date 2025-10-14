import 'package:expense_manager/features/home/presentation/summary/widget/summary_transaction_item.dart';
import 'package:expense_manager/features/transactions/domain/entities/transaction_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_core/flutter_core.dart';

class SummarySliverListTransactionWidget extends BaseStatelessWidget {
  const SummarySliverListTransactionWidget({
    super.key,
    required this.recentTransactions,
  });

  final List<TransactionEntity> recentTransactions;

  @override
  Widget buildContent(BuildContext context) {
    return SliverList.separated(
      itemCount: recentTransactions.length,
      separatorBuilder: (_, _) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final transaction = recentTransactions[index];
        return SummaryTransactionItem(transaction: transaction);
      },
    );
  }
}
