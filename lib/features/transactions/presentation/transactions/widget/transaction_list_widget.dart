import 'package:collection/collection.dart';
import 'package:expense_manager/core/enums/transaction_type.dart';
import 'package:expense_manager/features/transactions/domain/entities/transaction_entity.dart';
import 'package:expense_manager/features/transactions/presentation/add_transaction/add_expense_bottom_sheet.dart';
import 'package:expense_manager/features/transactions/presentation/transactions/bloc/transactions_bloc.dart';
import 'package:expense_manager/features/transactions/presentation/transactions/bloc/transactions_event.dart';
import 'package:expense_manager/features/transactions/presentation/transactions/widget/transaction_item.dart'
    show TransactionItem;
import 'package:expense_manager/features/workspace/domain/entities/workspace_entity.dart';
import 'package:expense_manager/features/workspace/presentation/bloc/workspace_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_common/flutter_common.dart';
import 'package:flutter_core/flutter_core.dart';
import 'package:flutter_resource/flutter_resource.dart';

class TransactionSliverListWidget extends BaseStatelessWidget {
  const TransactionSliverListWidget({super.key, required this.transactions});

  final List<TransactionEntity> transactions;

  @override
  Widget buildContent(BuildContext context) {
    final workspaceState = context.watch<WorkspaceBloc>().state;
    final groups = _groupTransactions(transactions);
    final selectedId = workspaceState.selectedWorkspaceId ??
        (workspaceState.workspaces.isNotEmpty
            ? workspaceState.workspaces.first.id
            : null);
    WorkspaceEntity? selectedWorkspace;
    if (selectedId != null) {
      selectedWorkspace = workspaceState.workspaces
          .firstWhereOrNull((workspace) => workspace.id == selectedId);
    }
    selectedWorkspace ??= workspaceState.workspaces.isNotEmpty
        ? workspaceState.workspaces.first
        : null;
    final workspaces = workspaceState.workspaces
        .where((workspace) => !workspace.isPersonal)
        .toList(growable: false);
    final canShare =
        (selectedWorkspace?.isPersonal ?? true) && workspaces.isNotEmpty;

    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate((context, index) {
          final group = groups[index];
          return Padding(
            padding: EdgeInsets.only(
              bottom: index == groups.length - 1 ? 0 : 16,
            ),
            child: _TransactionGroupSection(
              group: group,
              onEdit: (transaction) =>
                  _showEditBottomSheet(context, transaction),
              onDelete: (transaction) => context.read<TransactionsBloc>().add(
                TransactionsDeleteRequested(transaction),
              ),
              onShare: canShare
                  ? (transaction) => _showShareBottomSheet(
                        context,
                        transaction,
                        workspaces,
                      )
                  : null,
            ),
          );
        }, childCount: groups.length),
      ),
    );
  }

  Future<void> _showEditBottomSheet(
    BuildContext context,
    TransactionEntity transaction,
  ) async {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useRootNavigator: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AddExpenseBottomSheet(transaction: transaction),
    );
  }

  Future<void> _showShareBottomSheet(
    BuildContext context,
    TransactionEntity transaction,
    List<WorkspaceEntity> workspaces,
  ) async {
    if (workspaces.isEmpty) {
      return;
    }
    final selected = await showModalBottomSheet<WorkspaceEntity>(
      context: context,
      builder: (context) {
        return SafeArea(
          child: ListView.separated(
            shrinkWrap: true,
            itemCount: workspaces.length,
            separatorBuilder: (_, _) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final workspace = workspaces[index];
              return ListTile(
                leading: const Icon(Icons.group_outlined),
                title: Text(workspace.name),
                onTap: () => Navigator.of(context).pop(workspace),
              );
            },
          ),
        );
      },
    );

    if (selected == null) {
      return;
    }
    if (context.mounted) {
      context.read<TransactionsBloc>().add(
            TransactionsShareRequested(
              entity: transaction,
              targetWorkspaceId: selected.id,
              targetWorkspaceName: selected.name,
            ),
          );
    }
  }
}

List<_TransactionDayGroup> _groupTransactions(
  List<TransactionEntity> transactions,
) {
  final grouped = groupBy(
    transactions,
    (TransactionEntity transaction) => DateTime(
      transaction.date.year,
      transaction.date.month,
      transaction.date.day,
    ),
  );

  final groups = grouped.entries.map((entry) {
    final items = entry.value.toList()
      ..sort((a, b) => b.date.compareTo(a.date));
    return _TransactionDayGroup(date: entry.key, transactions: items);
  }).toList()..sort((a, b) => b.date.compareTo(a.date));

  return groups;
}

class _TransactionDayGroup {
  const _TransactionDayGroup({required this.date, required this.transactions});

  final DateTime date;
  final List<TransactionEntity> transactions;
}

class _TransactionGroupSection extends StatelessWidget {
  const _TransactionGroupSection({
    required this.group,
    required this.onEdit,
    required this.onDelete,
    this.onShare,
  });

  final _TransactionDayGroup group;
  final ValueChanged<TransactionEntity> onEdit;
  final ValueChanged<TransactionEntity> onDelete;
  final ValueChanged<TransactionEntity>? onShare;

  @override
  Widget build(BuildContext context) {
    final dateLabel = DateFormat('d/M').format(group.date);
    final theme = context.tpColors;
    final totalExpense = group.transactions
        .where((t) => t.type.isExpense)
        .fold<double>(0, (sum, t) => sum + t.amount);
    final totalIncome = group.transactions
        .where((t) => t.type.isIncome)
        .fold<double>(0, (sum, t) => sum + t.amount);
    final net = totalIncome - totalExpense;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              dateLabel,
              style: TPTextStyle.labelM.copyWith(color: theme.textSub),
            ),
            PopupMenuButton<int>(
              tooltip: '',
              color: theme.surfaceMain,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(color: theme.borderDefault, width: 1),
              ),
              itemBuilder: (context) => [
                PopupMenuItem<int>(
                  enabled: false,
                  child: Text(
                    "Chi tiết ngày ${group.date.toStringWithFormat(DateFormat.yMMMMEEEEd())}",
                    style: TPTextStyle.bodyM.copyWith(
                      color: context.tpColors.textMain,
                    ),
                  ),
                ),
                PopupMenuDivider(color: context.tpColors.borderDefault),
                PopupMenuItem<int>(
                  enabled: false,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Tổng chi',
                        style: TPTextStyle.bodyM.copyWith(
                          color: context.tpColors.textSub,
                        ),
                      ),
                      Text(
                        CurrencyUtils.formatVndFromDouble(totalExpense),
                        style: TPTextStyle.bodyM.copyWith(
                          color: context.tpColors.textNegative,
                        ),
                      ),
                    ],
                  ),
                ),
                PopupMenuItem<int>(
                  enabled: false,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Tổng thu',
                        style: TPTextStyle.bodyM.copyWith(
                          color: context.tpColors.textSub,
                        ),
                      ),
                      Text(
                        CurrencyUtils.formatVndFromDouble(totalIncome),
                        style: TPTextStyle.bodyM.copyWith(
                          color: context.tpColors.textPositive,
                        ),
                      ),
                    ],
                  ),
                ),
                PopupMenuItem<int>(
                  enabled: false,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Net',
                        style: TPTextStyle.bodyM.copyWith(
                          color: context.tpColors.textSub,
                        ),
                      ),
                      Text(
                        CurrencyUtils.formatVndFromDouble(net),
                        style: TPTextStyle.bodyM.copyWith(
                          color: net >= 0
                              ? context.tpColors.textPositive
                              : context.tpColors.textNegative,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              child: Container(
                height: 36,
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: context.tpColors.surfaceNeutral,
                ),
                child: Text(
                  'Tổng chi ${CurrencyUtils.formatVndFromDouble(totalExpense)}',
                  style: TPTextStyle.labelS.copyWith(
                    color: context.tpColors.surfaceNeutralComponent,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        DecoratedBox(
          decoration: BoxDecoration(
            color: theme.surfaceMain,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: theme.borderDefault, width: 1),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: ListView.separated(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: group.transactions.length,
              itemBuilder: (context, index) {
                final transaction = group.transactions[index];
                return TransactionItem(
                  transaction: transaction,
                  onEdit: () => onEdit(transaction),
                  onDelete: onDelete,
                  onShare:
                      onShare != null ? () => onShare!(transaction) : null,
                  backgroundColor: Colors.transparent,
                  borderRadius: BorderRadius.zero,
                );
              },
              separatorBuilder: (_, _) => Divider(
                height: 1,
                thickness: 1,
                color: theme.borderDefault,
                indent: 32,
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
