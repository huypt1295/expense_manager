import 'dart:async';
import 'package:expense_manager/features/transactions/presentation/transactions/bloc/transactions_bloc.dart';
import 'package:expense_manager/features/transactions/presentation/transactions/bloc/transactions_effect.dart';
import 'package:expense_manager/features/transactions/presentation/transactions/bloc/transactions_event.dart';
import 'package:expense_manager/features/transactions/presentation/transactions/bloc/transactions_state.dart';
import 'package:expense_manager/features/transactions/presentation/transactions/widget/transaction_empty_widget.dart';
import 'package:expense_manager/features/transactions/presentation/transactions/widget/transaction_list_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_common/flutter_common.dart';
import 'package:flutter_core/flutter_core.dart';

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

class _TransactionView extends StatefulWidget {
  const _TransactionView();

  @override
  State<_TransactionView> createState() => _TransactionViewState();
}

class _TransactionViewState extends State<_TransactionView> {
  late DateTime _selectedMonth;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _selectedMonth = DateTime(now.year, now.month);
  }

  @override
  Widget build(BuildContext context) {
    return EffectBlocListener<
      TransactionsState,
      TransactionsEffect,
      TransactionsBloc
    >(
      listener: _handleEffect,
      child: BlocBuilder<TransactionsBloc, TransactionsState>(
        builder: (context, state) {
          if (state.isLoading && state.items.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          final transactionsByMonth = state.items
              .where(
                (transaction) =>
                    transaction.date.year == _selectedMonth.year &&
                    transaction.date.month == _selectedMonth.month,
              )
              .toList();

          return ColoredBox(
            color: context.tpColors.backgroundMain,
            child: CustomScrollView(
              slivers: [
                MonthSelectorBar(
                  selectedMonth: _selectedMonth,
                  onNext: _goToNextMonth,
                  onPrevious: _goToPreviousMonth,
                ),
                Expanded(
                  child: transactionsByMonth.isEmpty
                      ? SliverToBoxAdapter(child: const TransactionEmptyWidget())
                      : TransactionSliverListWidget(transactions: transactionsByMonth),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _goToPreviousMonth() {
    setState(() {
      _selectedMonth = _selectedMonth.previousMonth;
    });
  }

  void _goToNextMonth() {
    setState(() {
      _selectedMonth = _selectedMonth.nextMonth;
    });
  }

  FutureOr<void> _handleEffect(Effect effect, UiActions emitUi) {
    if (effect is TransactionsShowUndoDeleteEffect) {
      emitUi.showSnackBar(
        SnackBar(
          duration: effect.duration,
          content: UndoSnackBarContent(
            message: effect.message,
            label: effect.actionLabel,
            duration: effect.duration,
            onUndo: () {
              emitUi.call((context) {
                context.read<TransactionsBloc>().add(
                  const TransactionsDeleteUndoRequested(),
                );
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
              });
            },
          ),
        ),
      );
    } else if (effect is TransactionsShowErrorEffect) {
      emitUi.showSnackBar(SnackBar(content: Text(effect.message)));
    }
  }
}
