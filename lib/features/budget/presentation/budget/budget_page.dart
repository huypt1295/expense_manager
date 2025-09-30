import 'package:expense_manager/features/budget/domain/entities/budget_entity.dart';
import 'package:expense_manager/features/budget/domain/entities/budget_progress.dart';
import 'package:expense_manager/features/budget/presentation/budget/bloc/budget_bloc.dart';
import 'package:expense_manager/features/budget/presentation/budget/bloc/budget_effect.dart';
import 'package:expense_manager/features/budget/presentation/budget/bloc/budget_event.dart';
import 'package:expense_manager/features/budget/presentation/budget/bloc/budget_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_core/flutter_core.dart';
import 'package:intl/intl.dart';

class BudgetPage extends BaseStatelessWidget {
  const BudgetPage({super.key});

  @override
  Widget buildContent(BuildContext context) {
    return BlocProvider(
      create: (context) => tpGetIt.get<BudgetBloc>()
        ..add(const BudgetStarted()),
      child: const _BudgetView(),
    );
  }
}

class _BudgetView extends StatelessWidget {
  const _BudgetView();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return EffectBlocListener<BudgetState, BudgetEffect, BudgetBloc>(
      listener: (effect, emitUi) {
        if (effect is BudgetShowErrorEffect) {
          emitUi(
            (uiContext) => ScaffoldMessenger.of(uiContext).showSnackBar(
              SnackBar(content: Text(effect.message)),
            ),
          );
        }
      },
      child: BlocBuilder<BudgetBloc, BudgetState>(
        builder: (context, state) {
          if (state.isLoading && state.budgets.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          return Column(
            children: [
              Expanded(
                child: state.budgets.isEmpty
                    ? Center(
                        child: Text(
                          'No budgets configured',
                          style: theme.textTheme.bodyLarge,
                        ),
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 24,
                        ),
                        itemCount: state.budgets.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final budget = state.budgets[index];
                          final progress = state.progress[budget.id];
                          return _BudgetCard(
                            budget: budget,
                            progress: progress,
                            onEdit: () => _showBudgetDialog(
                              context,
                              initial: budget,
                            ),
                            onDelete: () => context
                                .read<BudgetBloc>()
                                .add(BudgetDeleted(budget.id)),
                          );
                        },
                      ),
              ),
              SafeArea(
                top: false,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () => _showBudgetDialog(context),
                      icon: const Icon(Icons.add),
                      label: const Text('Add budget'),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _showBudgetDialog(
    BuildContext context, {
    BudgetEntity? initial,
  }) async {
    final bloc = context.read<BudgetBloc>();
    final categoryController =
        TextEditingController(text: initial?.category ?? '');
    final limitController = TextEditingController(
      text: initial?.limitAmount.toStringAsFixed(0) ?? '',
    );
    DateTime startDate = initial?.startDate ?? DateTime.now();
    DateTime endDate = initial?.endDate ?? DateTime.now().add(const Duration(days: 30));
    final dateFormatter = DateFormat.yMMMd();

    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setState) {
            Future<void> pickDate({required bool isStart}) async {
              final picked = await showDatePicker(
                context: dialogContext,
                initialDate: isStart ? startDate : endDate,
                firstDate: DateTime(2000),
                lastDate: DateTime(2100),
              );
              if (picked != null) {
                setState(() {
                  if (isStart) {
                    startDate = picked;
                    if (endDate.isBefore(startDate)) {
                      endDate = startDate;
                    }
                  } else {
                    endDate = picked.isBefore(startDate) ? startDate : picked;
                  }
                });
              }
            }

            return AlertDialog(
              title: Text(initial == null ? 'Create budget' : 'Edit budget'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextField(
                      controller: categoryController,
                      decoration:
                          const InputDecoration(labelText: 'Category name'),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: limitController,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      decoration:
                          const InputDecoration(labelText: 'Limit amount'),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Start date'),
                            Text(dateFormatter.format(startDate)),
                          ],
                        ),
                        TextButton(
                          onPressed: () => pickDate(isStart: true),
                          child: const Text('Change'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('End date'),
                            Text(dateFormatter.format(endDate)),
                          ],
                        ),
                        TextButton(
                          onPressed: () => pickDate(isStart: false),
                          child: const Text('Change'),
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
                    final limit = double.tryParse(limitController.text);
                    final category = categoryController.text.trim();
                    if (category.isEmpty) {
                      ScaffoldMessenger.of(dialogContext).showSnackBar(
                        const SnackBar(content: Text('Category is required')),
                      );
                      return;
                    }
                    if (limit == null || limit <= 0) {
                      ScaffoldMessenger.of(dialogContext).showSnackBar(
                        const SnackBar(content: Text('Invalid limit amount')),
                      );
                      return;
                    }

                    final entity = (initial ?? BudgetEntity(
                      id: '',
                      category: category,
                      limitAmount: limit,
                      startDate: startDate,
                      endDate: endDate,
                    ))
                        .copyWith(
                      category: category,
                      limitAmount: limit,
                      startDate: startDate,
                      endDate: endDate,
                    );

                    if (initial == null) {
                      bloc.add(BudgetAdded(entity));
                    } else {
                      bloc.add(BudgetUpdated(entity));
                    }
                    Navigator.of(dialogContext).pop();
                  },
                  child: Text(initial == null ? 'Create' : 'Save'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}

class _BudgetCard extends StatelessWidget {
  const _BudgetCard({
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
    final numberFormatter = NumberFormat.currency(symbol: 'VND ', decimalDigits: 0);
    final spent = progress?.spentAmount ?? 0;
    final percentage = progress?.percentage ?? 0;

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
                      'Spent: ${numberFormatter.format(spent)}',
                      style: theme.textTheme.bodyMedium,
                    ),
                    Text(
                      'Limit: ${numberFormatter.format(budget.limitAmount)}',
                      style: theme.textTheme.bodyMedium,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
