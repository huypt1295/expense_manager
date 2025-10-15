import 'package:expense_manager/features/budget/domain/entities/budget_entity.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_common/flutter_common.dart';
import 'package:flutter_core/flutter_core.dart';
import 'package:flutter_resource/flutter_resource.dart';

import 'chart_slice.dart';

class BudgetChartWidget extends BaseStatefulWidget {
  const BudgetChartWidget({super.key, required this.budgets});

  final List<BudgetEntity> budgets;

  @override
  State<StatefulWidget> createState() => BudgetChartWidgetState();
}

class BudgetChartWidgetState extends BaseState<BudgetChartWidget> {
  static const _maxTopSlices = 5;
  static const _topSliceColors = <Color>[
    AppColors.purpleBranding500,
    AppColors.purpleBranding400,
    AppColors.purpleBranding300,
    AppColors.purpleBranding200,
    AppColors.purpleBranding100,
  ];

  int touchedIndex = -1;
  List<ChartSlice> _slices = const <ChartSlice>[];
  double _totalAmount = 0;

  @override
  void onInitState() {
    super.onInitState();
    _recomputeSlices(shouldNotify: false);
  }

  @override
  void didUpdateWidget(covariant BudgetChartWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!listEquals(oldWidget.budgets, widget.budgets)) {
      _recomputeSlices();
    }
  }

  void _recomputeSlices({bool shouldNotify = true}) {
    final entries = widget.budgets
        .map((budget) => (budget: budget, amount: budget.limitAmount))
        .where((entry) => entry.amount > 0)
        .toList();

    void applyEmpty() {
      _slices = const <ChartSlice>[];
      _totalAmount = 0;
      touchedIndex = -1;
    }

    if (entries.isEmpty) {
      if (shouldNotify && mounted) {
        setState(applyEmpty);
      } else {
        applyEmpty();
      }
      return;
    }

    entries.sort((a, b) => b.amount.compareTo(a.amount));
    final total = entries.fold<double>(0, (sum, entry) => sum + entry.amount);

    if (total <= 0) {
      if (shouldNotify && mounted) {
        setState(applyEmpty);
      } else {
        applyEmpty();
      }
      return;
    }

    final topEntries = entries.take(_maxTopSlices).toList();
    final otherEntries = entries.skip(_maxTopSlices);

    final slices = <ChartSlice>[
      for (var index = 0; index < topEntries.length; index++)
        ChartSlice(
          label: topEntries[index].budget.category,
          amount: topEntries[index].amount,
          color: _topSliceColors[index],
        ),
    ];

    final otherAmount = otherEntries.fold<double>(
      0,
      (sum, entry) => sum + entry.amount,
    );
    if (otherAmount > 0) {
      slices.add(
        ChartSlice(
          label: 'Other',
          amount: otherAmount,
          color: AppColors.purpleBranding200,
        ),
      );
    }

    void apply() {
      _slices = slices;
      _totalAmount = total;
      if (touchedIndex >= _slices.length) {
        touchedIndex = -1;
      }
    }

    if (shouldNotify && mounted) {
      setState(apply);
    } else {
      apply();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_slices.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: context.tpColors.borderDefault),
      ),
      margin: EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                S.current.total_budget_by_category,
                style: TPTextStyle.titleM.copyWith(
                  color: context.tpColors.textMain,
                ),
              ),
            ),
          ),
          AspectRatio(
            aspectRatio: 1.5,
            child: AspectRatio(
              aspectRatio: 1.2,
              child: PieChart(
                PieChartData(
                  pieTouchData: PieTouchData(
                    touchCallback: (event, pieTouchResponse) {
                      setState(() {
                        if (!event.isInterestedForInteractions ||
                            pieTouchResponse == null ||
                            pieTouchResponse.touchedSection == null) {
                          touchedIndex = -1;
                          return;
                        }
                        touchedIndex = pieTouchResponse
                            .touchedSection!
                            .touchedSectionIndex;
                      });
                    },
                  ),
                  borderData: FlBorderData(show: false),
                  sectionsSpace: 0,
                  centerSpaceRadius: 0,
                  sections: _buildSections(),
                ),
              ),
            ),
          ),
          _buildIndicator(),
        ],
      ),
    );
  }

  List<PieChartSectionData> _buildSections() {
    if (_totalAmount <= 0) {
      return const [];
    }

    return List<PieChartSectionData>.generate(_slices.length, (index) {
      final slice = _slices[index];
      final percentage = slice.amount / _totalAmount;
      final isTouched = index == touchedIndex;

      return PieChartSectionData(
        color: slice.color,
        value: slice.amount,
        title: '${(percentage * 100).toStringAsFixed(0)}%',
        radius: isTouched ? 110 : 100,
        titleStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          shadows: [Shadow(color: Colors.black26, blurRadius: 2)],
        ),
      );
    });
  }

  Widget _buildIndicator() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          for (var index = 0; index < _slices.length; index++)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: _slices[index].color,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(_slices[index].label, style: TPTextStyle.bodyM),
                  ),
                  Text(
                    CurrencyUtils.formatVndFromDouble(_slices[index].amount),
                    style: TPTextStyle.bodyM,
                  ),
                ],
              ),
            ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}
