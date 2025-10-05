import 'package:expense_manager/features/transactions/domain/entities/transaction_entity.dart';
import 'package:expense_manager/features/transactions/presentation/transactions/bloc/transactions_bloc.dart';
import 'package:expense_manager/features/transactions/presentation/transactions/bloc/transactions_effect.dart';
import 'package:expense_manager/features/transactions/presentation/transactions/bloc/transactions_event.dart';
import 'package:expense_manager/features/transactions/presentation/transactions/bloc/transactions_state.dart';
import 'package:expense_manager/features/transactions/presentation/transactions/widget/transaction_edit_dialog.dart';
import 'package:expense_manager/features/transactions/presentation/transactions/widget/transaction_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_core/flutter_core.dart';
import 'package:intl/intl.dart';

class TransactionPage extends BaseStatelessWidget {
  const TransactionPage({super.key});

  @override
  Widget buildContent(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          tpGetIt.get<TransactionsBloc>()..add(const TransactionsStarted()),
      child: const _TransactionView(),
    );
  }
}

class _TransactionView extends StatelessWidget {
  const _TransactionView();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return EffectBlocListener<TransactionsState, TransactionsEffect,
        TransactionsBloc>(
      listener: (effect, emitUi) {
        if (effect is TransactionsShowErrorEffect) {
          emitUi(
            (uiContext) => ScaffoldMessenger.of(uiContext).showSnackBar(
              SnackBar(content: Text(effect.message)),
            ),
          );
        }
      },
      child: BlocBuilder<TransactionsBloc, TransactionsState>(
        builder: (context, state) {
          if (state.isLoading && state.items.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.items.isEmpty) {
            return Center(
              child: Text(
                'No transactions yet',
                style: theme.textTheme.bodyLarge,
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            itemBuilder: (context, index) {
              final transaction = state.items[index];
              return TransactionItem(
                transaction: transaction,
                onEdit: () => _showEditDialog(context, transaction),
                onDelete: () => context
                    .read<TransactionsBloc>()
                    .add(TransactionsDeleted(transaction.id)),
              );
            },
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemCount: state.items.length,
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
            child: TransactionEditDialog(
              transaction: transaction,
            ));
      },
    );
  }
}
