import 'package:expense_manager/features/home/presentation/summary/bloc/summary_bloc.dart';
import 'package:expense_manager/features/home/presentation/summary/bloc/summary_effect.dart';
import 'package:expense_manager/features/home/presentation/summary/bloc/summary_event.dart';
import 'package:expense_manager/features/home/presentation/summary/bloc/summary_state.dart';
import 'package:expense_manager/features/transactions/domain/entities/transaction_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_core/flutter_core.dart';
import 'package:intl/intl.dart';

class SummaryPage extends BaseStatelessWidget {
  const SummaryPage({super.key});

  @override
  Widget buildContent(BuildContext context) {
    return BlocProvider(
      create: (context) => tpGetIt.get<SummaryBloc>()
        ..add(const SummaryStarted()),
      child: const _SummaryView(),
    );
  }
}

class _SummaryView extends StatelessWidget {
  const _SummaryView();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final numberFormatter = NumberFormat.currency(symbol: 'VND ', decimalDigits: 0);

    return EffectBlocListener<SummaryState, SummaryEffect, SummaryBloc>(
      listener: (effect, emitUi) {
        if (effect is SummaryShowErrorEffect) {
          emitUi(
            (uiContext) => ScaffoldMessenger.of(uiContext).showSnackBar(
              SnackBar(content: Text(effect.message)),
            ),
          );
        }
      },
      child: BlocBuilder<SummaryBloc, SummaryState>(
        builder: (context, state) {
          if (state.isLoading && state.recentTransactions.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hello, ${state.greeting}! 👋',
                  style: theme.textTheme.headlineSmall,
                ),
                const SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'This month spending',
                        style: theme.textTheme.titleSmall,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        numberFormatter.format(state.monthTotal),
                        style: theme.textTheme.headlineMedium?.copyWith(
                          color: theme.colorScheme.onPrimaryContainer,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Recent transactions',
                  style: theme.textTheme.titleMedium,
                ),
                const SizedBox(height: 12),
                if (state.recentTransactions.isEmpty)
                  Text(
                    'No activity recorded yet. Add your first transaction!',
                    style: theme.textTheme.bodyMedium,
                  )
                else
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: state.recentTransactions.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final transaction = state.recentTransactions[index];
                      return _TransactionRow(
                        transaction: transaction,
                        formatter: numberFormatter,
                      );
                    },
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _TransactionRow extends StatelessWidget {
  const _TransactionRow({
    required this.transaction,
    required this.formatter,
  });

  final TransactionEntity transaction;
  final NumberFormat formatter;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dateFormatter = DateFormat.MMMd();

    return Material(
      borderRadius: BorderRadius.circular(12),
      color: theme.colorScheme.surface,
      child: ListTile(
        title: Text(transaction.title),
        subtitle: Text(
          [
            dateFormatter.format(transaction.date),
            if ((transaction.category ?? '').isNotEmpty) transaction.category,
          ].whereType<String>().join(' · '),
        ),
        trailing: Text(
          formatter.format(transaction.amount),
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
