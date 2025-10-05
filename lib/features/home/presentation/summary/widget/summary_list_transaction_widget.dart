import 'package:expense_manager/features/home/presentation/summary/widget/summary_transaction_item.dart';
import 'package:expense_manager/features/transactions/domain/entities/transaction_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_core/flutter_core.dart';

class SummaryListTransactionWidget extends BaseStatelessWidget {
  const SummaryListTransactionWidget({super.key, required this.recentTransactions});

  final List<TransactionEntity> recentTransactions;

  @override
  Widget buildContent(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: recentTransactions.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final transaction = recentTransactions[index];
        return SummaryTransactionItem(
          transaction: transaction,
        );
      },
    );
  }
}
