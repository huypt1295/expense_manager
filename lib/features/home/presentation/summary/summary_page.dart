import 'package:collection/collection.dart';
import 'package:expense_manager/features/home/presentation/summary/bloc/summary_bloc.dart';
import 'package:expense_manager/features/home/presentation/summary/bloc/summary_effect.dart';
import 'package:expense_manager/features/home/presentation/summary/bloc/summary_event.dart';
import 'package:expense_manager/features/home/presentation/summary/bloc/summary_state.dart';
import 'package:expense_manager/features/home/presentation/summary/widget/summary_empty_widget.dart';
import 'package:expense_manager/features/home/presentation/summary/widget/summary_greeting_widget.dart';
import 'package:expense_manager/features/home/presentation/summary/widget/summary_list_transaction_widget.dart';
import 'package:expense_manager/features/home/presentation/summary/widget/summary_spending_widget.dart';
import 'package:expense_manager/features/home/presentation/summary/widget/summary_weekly_transactions_line_chart_widget.dart';
import 'package:expense_manager/features/home/presentation/summary/widget/workspace_onboarding_banner.dart';
import 'package:expense_manager/features/workspace/domain/entities/workspace_entity.dart';
import 'package:expense_manager/features/workspace/presentation/bloc/workspace_bloc.dart';
import 'package:expense_manager/features/workspace/presentation/bloc/workspace_state.dart';
import 'package:expense_manager/features/workspace/presentation/settings/workspace_management_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_common/flutter_common.dart';
import 'package:flutter_core/flutter_core.dart';
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
                      _buildGreetingWidget(state),
                      SliverToBoxAdapter(child: const SizedBox(height: 16)),
                      _buildOverviewWidget(state),
                      SliverToBoxAdapter(child: const SizedBox(height: 24)),
                      _buildChart(state),
                      SliverToBoxAdapter(child: const SizedBox(height: 24)),
                      _buildListRecent(state),
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

  Widget _buildGreetingWidget(SummaryState state) {
    return SliverToBoxAdapter(
      child: BlocBuilder<WorkspaceBloc, WorkspaceState>(
        builder: (context, workspaceState) {
          final selectedId =
              workspaceState.selectedWorkspaceId ??
              (workspaceState.workspaces.isNotEmpty
                  ? workspaceState.workspaces.first.id
                  : null);
          WorkspaceEntity? selected;
          if (selectedId != null) {
            selected = workspaceState.workspaces.firstWhereOrNull(
              (w) => w.id == selectedId,
            );
          }
          selected ??= workspaceState.workspaces.isNotEmpty
              ? workspaceState.workspaces.first
              : null;
          final showManageButton =
              selected != null &&
              !selected.isPersonal &&
              (selected.role.toLowerCase() == 'owner' ||
                  selected.role.toLowerCase() == 'editor');
          final showOnboardingBanner =
              workspaceState.workspaces.isNotEmpty &&
              workspaceState.workspaces.every(
                (workspace) => workspace.isPersonal,
              );

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SummaryGreetingWidget(
                username: state.greeting,
                workspace: selected,
                onWorkspaceTap: showManageButton
                    ? () {
                        final target = selected;
                        if (target == null) {
                          return;
                        }
                        WorkspaceManagementSheet.show(
                          context,
                          workspaceId: target.id,
                          workspaceName: target.name,
                          currentRole: target.role,
                        );
                      }
                    : null,
              ),
              if (showOnboardingBanner) ...[
                const SizedBox(height: 12),
                const WorkspaceOnboardingBanner(),
              ],
            ],
          );
        },
      ),
    );
  }

  Widget _buildOverviewWidget(SummaryState state) {
    return SliverToBoxAdapter(
      child: SummarySpendingWidget(
        income: state.monthlyIncome,
        expense: state.monthlyExpense,
        remaining: state.monthlyRemaining,
      ),
    );
  }

  Widget _buildChart(SummaryState state) {
    return SliverToBoxAdapter(
      child: SummaryWeeklyTransactionsLineChartWidget(
        weeklyExpenses: state.weeklyExpenses,
      ),
    );
  }

  Widget _buildListRecent(SummaryState state) {
    return state.recentTransactions.isEmpty
        ? SliverToBoxAdapter(child: SummaryEmptyWidget())
        : SummarySliverListTransactionWidget(
            recentTransactions: state.recentTransactions,
          );
  }
}
