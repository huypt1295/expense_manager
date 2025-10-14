import 'package:expense_manager/features/transactions/domain/entities/transaction_entity.dart';
import 'package:expense_manager/features/transactions/presentation/transactions/bloc/transactions_bloc.dart';
import 'package:expense_manager/features/transactions/presentation/transactions/bloc/transactions_event.dart';
import 'package:expense_manager/features/transactions/presentation/transactions/widget/transaction_edit_dialog.dart';
import 'package:expense_manager/features/transactions/presentation/transactions/widget/transaction_item.dart'
    show TransactionItem;
import 'package:flutter/material.dart';
import 'package:flutter_core/flutter_core.dart';

class TransactionSliverListWidget extends BaseStatelessWidget {
  const TransactionSliverListWidget({super.key, required this.transactions});

  final List<TransactionEntity> transactions;

  @override
  Widget buildContent(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      sliver: SliverList.separated(
        itemCount: transactions.length,
        separatorBuilder: (_, _) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final transaction = transactions[index];
          return TransactionItem(
            transaction: transaction,
            onEdit: () => _showEditDialog(context, transaction),
            onDelete: (item) => context.read<TransactionsBloc>().add(
              TransactionsDeleteRequested(item),
            ),
          );
        },
      ),
    );
  }

  Future<void> _showEditDialog(
    BuildContext context,
    TransactionEntity transaction,
  ) async {
    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return BlocProvider.value(
          value: context.read<TransactionsBloc>(),
          child: TransactionEditDialog(transaction: transaction),
        );
      },
    );
  }
}
