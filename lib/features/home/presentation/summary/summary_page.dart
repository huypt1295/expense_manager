import 'package:expense_manager/features/home/presentation/summary/bloc/summary_bloc.dart';
import 'package:expense_manager/features/home/presentation/summary/bloc/summary_effect.dart';
import 'package:expense_manager/features/home/presentation/summary/bloc/summary_event.dart';
import 'package:expense_manager/features/home/presentation/summary/bloc/summary_state.dart';
import 'package:expense_manager/features/home/presentation/summary/widget/summary_empty_widget.dart';
import 'package:expense_manager/features/home/presentation/summary/widget/summary_greeting_widget.dart';
import 'package:expense_manager/features/home/presentation/summary/widget/summary_list_transaction_widget.dart';
import 'package:expense_manager/features/home/presentation/summary/widget/summary_spending_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_common/flutter_common.dart';
import 'package:flutter_core/flutter_core.dart';
import 'package:flutter_resource/flutter_resource.dart';
import 'package:sliver_tools/sliver_tools.dart' show MultiSliver;

class SummaryPage extends BaseStatelessWidget {
  const SummaryPage({super.key});

  @override
  Widget buildContent(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          tpGetIt.get<SummaryBloc>()..add(const SummaryStarted()),
      child: const _SummaryView(),
    );
  }
}

class _SummaryView extends StatelessWidget {
  const _SummaryView();

  @override
  Widget build(BuildContext context) {
    return EffectBlocListener<SummaryState, SummaryEffect, SummaryBloc>(
      listener: (effect, emitUi) {
        if (effect is SummaryShowErrorEffect) {
          emitUi.showSnackBar(SnackBar(content: Text(effect.message)));
        }
      },
      child: BlocBuilder<SummaryBloc, SummaryState>(
        builder: (context, state) {
          if (state.isLoading && state.recentTransactions.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          return ColoredBox(
            color: context.tpColors.backgroundMain,
            child: CustomScrollView(
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 24,
                  ),
                  sliver: MultiSliver(
                    children: [
                      SliverToBoxAdapter(
                        child: SummaryGreetingWidget(greeting: state.greeting),
                      ),
                      SliverToBoxAdapter(child: const SizedBox(height: 12)),
                      SliverToBoxAdapter(
                        child: SummarySpendingWidget(
                          monthTotal: state.monthTotal,
                        ),
                      ),
                      SliverToBoxAdapter(child: const SizedBox(height: 24)),
                      SliverToBoxAdapter(
                        child: Text(
                          'Recent transactions',
                          style: TPTextStyle.titleM,
                        ),
                      ),
                      SliverToBoxAdapter(child: const SizedBox(height: 12)),
                      state.recentTransactions.isEmpty
                          ? SliverToBoxAdapter(child: SummaryEmptyWidget())
                          : SummarySliverListTransactionWidget(
                              recentTransactions: state.recentTransactions,
                            ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
