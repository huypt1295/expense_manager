import 'package:expense_manager/features/transactions/domain/entities/transaction_entity.dart';
import 'package:expense_manager/features/transactions/presentation/transactions/bloc/transactions_bloc.dart';
import 'package:expense_manager/features/transactions/presentation/transactions/bloc/transactions_effect.dart';
import 'package:expense_manager/features/transactions/presentation/transactions/bloc/transactions_event.dart';
import 'package:expense_manager/features/transactions/presentation/transactions/bloc/transactions_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_core/flutter_core.dart';
import 'package:intl/intl.dart';

class TransactionPage extends BaseStatelessWidget {
  const TransactionPage({super.key});

  @override
  Widget buildContent(BuildContext context) {
    return BlocProvider(
      create: (context) => tpGetIt.get<TransactionsBloc>()
        ..add(const TransactionsStarted()),
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
              return _TransactionTile(
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
    final bloc = context.read<TransactionsBloc>();
    final titleController = TextEditingController(text: transaction.title);
    final amountController =
        TextEditingController(text: transaction.amount.toStringAsFixed(2));
    final categoryController = TextEditingController(text: transaction.category);
    final noteController = TextEditingController(text: transaction.note);
    DateTime selectedDate = transaction.date;

    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Edit transaction'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: titleController,
                      decoration: const InputDecoration(labelText: 'Title'),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: amountController,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      decoration: const InputDecoration(labelText: 'Amount'),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: categoryController,
                      decoration: const InputDecoration(labelText: 'Category'),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: noteController,
                      decoration: const InputDecoration(labelText: 'Note'),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(DateFormat.yMMMd().format(selectedDate)),
                        TextButton(
                          onPressed: () async {
                            final picked = await showDatePicker(
                              context: dialogContext,
                              initialDate: selectedDate,
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2100),
                            );
                            if (picked != null) {
                              setState(() => selectedDate = picked);
                            }
                          },
                          child: const Text('Change date'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    final amount = double.tryParse(amountController.text);
                    if (amount == null) {
                      ScaffoldMessenger.of(dialogContext).showSnackBar(
                        const SnackBar(content: Text('Invalid amount value')),
                      );
                      return;
                    }

                    final updated = transaction.copyWith(
                      title: titleController.text.trim(),
                      amount: amount,
                      category: categoryController.text.trim().isEmpty
                          ? null
                          : categoryController.text.trim(),
                      note: noteController.text.trim().isEmpty
                          ? null
                          : noteController.text.trim(),
                      date: selectedDate,
                    );
                    bloc.add(TransactionsUpdated(updated));
                    Navigator.of(dialogContext).pop();
                  },
                  child: const Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}

class _TransactionTile extends StatelessWidget {
  const _TransactionTile({
    required this.transaction,
    required this.onEdit,
    required this.onDelete,
  });

  final TransactionEntity transaction;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final formatter = NumberFormat.currency(symbol: 'VND ', decimalDigits: 0);
    final dateFormatter = DateFormat.yMMMd();

    return Dismissible(
      key: ValueKey<String>(transaction.id),
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
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        child: ListTile(
          onTap: onEdit,
          title: Text(transaction.title, style: theme.textTheme.titleMedium),
          subtitle: Text(
            [
              dateFormatter.format(transaction.date),
              if ((transaction.category ?? '').isNotEmpty) transaction.category,
            ].whereType<String>().join(' · '),
          ),
          trailing: Text(
            formatter.format(transaction.amount),
            style: theme.textTheme.titleMedium
                ?.copyWith(color: theme.colorScheme.primary),
          ),
        ),
      ),
    );
  }
}
