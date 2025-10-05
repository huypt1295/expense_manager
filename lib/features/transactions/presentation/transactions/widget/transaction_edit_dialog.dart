import 'package:expense_manager/features/transactions/domain/entities/transaction_entity.dart';
import 'package:expense_manager/features/transactions/presentation/transactions/bloc/transactions_bloc.dart';
import 'package:expense_manager/features/transactions/presentation/transactions/bloc/transactions_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_core/flutter_core.dart';
import 'package:flutter_resource/flutter_resource.dart';

class TransactionEditDialog extends BaseStatefulWidget {
  const TransactionEditDialog({super.key, required this.transaction});

  final TransactionEntity transaction;

  @override
  State<TransactionEditDialog> createState() => _TransactionEditDialogState();
}

class _TransactionEditDialogState extends BaseState<TransactionEditDialog> {
  late final TextEditingController titleController;
  late final TextEditingController amountController;
  late final TextEditingController categoryController;
  late final TextEditingController noteController;
  late final DateTime selectedDate;

  @override
  void onInitState() {
    super.onInitState();

    titleController = TextEditingController(text: widget.transaction.title);
    amountController = TextEditingController(
        text: widget.transaction.amount.toStringAsFixed(2));
    categoryController =
        TextEditingController(text: widget.transaction.category);
    noteController = TextEditingController(text: widget.transaction.note);
    selectedDate = widget.transaction.date;
  }

  @override
  Widget build(BuildContext context) {
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
                      context: context,
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
          onPressed: () => context.pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            final amount = double.tryParse(amountController.text);
            if (amount == null) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Invalid amount value')),
              );
              return;
            }

            final updated = widget.transaction.copyWith(
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
            context.read<TransactionsBloc>().add(TransactionsUpdated(updated));
            context.pop();
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}
