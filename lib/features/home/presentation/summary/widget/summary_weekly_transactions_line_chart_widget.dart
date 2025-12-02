import 'dart:math' as math;

import 'package:expense_manager/features/home/presentation/summary/bloc/summary_state.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_common/flutter_common.dart';
import 'package:flutter_core/flutter_core.dart';
import 'package:flutter_resource/flutter_resource.dart';

class SummaryWeeklyTransactionsLineChartWidget extends BaseStatelessWidget {
  const SummaryWeeklyTransactionsLineChartWidget({
    super.key,
    required this.weeklyExpenses,
  });

  final List<SummaryDailySpending> weeklyExpenses;

  @override
  Widget buildContent(BuildContext context) {
    final hasSpending = weeklyExpenses.any((spending) => spending.amount > 0.0);
    if (!hasSpending) {
      return _buildPlaceholder(context);
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: context.tpColors.surfaceMain,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            S.current.weekly_spending_chart_title,
            style: TPTextStyle.titleM.copyWith(
              color: context.tpColors.textMain,
            ),
          ),
          const SizedBox(height: 24),
          AspectRatio(
            aspectRatio: 1.6,
            child: LineChart(_buildChartData(context)),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceholder(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 32),
      decoration: BoxDecoration(
        color: context.tpColors.surfaceNeutralComponent,
        borderRadius: BorderRadius.circular(16),
      ),
      alignment: Alignment.center,
      child: Text(
        S.current.weekly_spending_chart_empty,
        textAlign: TextAlign.center,
        style: TPTextStyle.bodyM.copyWith(color: context.tpColors.textMain),
      ),
    );
  }

  LineChartData _buildChartData(BuildContext context) {
    final maxAmount = weeklyExpenses.fold<double>(
      0,
      (maxValue, spending) => math.max(maxValue, spending.amount),
    );
    final maxY = _calculateMaxY(maxAmount);
    final gradientBase = context.tpColors.surfaceNeutralComponent;

    return LineChartData(
      minX: 0,
      maxX: (weeklyExpenses.length - 1).toDouble(),
      minY: 0,
      maxY: maxY.toDouble(),
      lineTouchData: LineTouchData(
        handleBuiltInTouches: true,
        touchTooltipData: LineTouchTooltipData(
          getTooltipColor: (groupData) =>
              context.tpColors.surfaceNeutralComponent,
          tooltipBorderRadius: BorderRadius.circular(16),
          tooltipMargin: 12,
          fitInsideHorizontally: true,
          showOnTopOfTheChartBoxArea: true,
          getTooltipItems: (touchedSpots) {
            return touchedSpots
                .map((spot) {
                  final index = spot.x.round().clamp(
                    0,
                    weeklyExpenses.length - 1,
                  );
                  final point = weeklyExpenses[index];
                  final dateLabel = DateFormat.MMMd().format(point.date);
                  final amountLabel = CurrencyUtils.formatVndFromDouble(
                    point.amount,
                  );
                  return LineTooltipItem(
                    '$dateLabel\n$amountLabel',
                    TPTextStyle.bodyS.copyWith(
                      color: context.tpColors.textReverse,
                    ),
                  );
                })
                .toList(growable: false);
          },
        ),
      ),
      gridData: FlGridData(
        show: true,
        horizontalInterval: maxY == 0 ? 1 : maxY / 5,
        verticalInterval: 1,
        getDrawingHorizontalLine: (_) => FlLine(
          color: context.tpColors.borderDefault,
          strokeWidth: 1,
          dashArray: const [6, 4],
        ),
        getDrawingVerticalLine: (_) => FlLine(
          color: context.tpColors.borderDefault,
          strokeWidth: 1,
          dashArray: const [6, 4],
        ),
      ),
      borderData: FlBorderData(show: false),
      titlesData: FlTitlesData(
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 48,
            interval: maxY == 0 ? 1 : maxY / 5,
            getTitlesWidget: (value, meta) =>
                _buildLeftTitle(context, value, meta),
          ),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 40,
            interval: 1,
            getTitlesWidget: (value, meta) =>
                _buildBottomTitle(context, value, meta),
          ),
        ),
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
      ),
      lineBarsData: [
        LineChartBarData(
          spots: List<FlSpot>.generate(
            weeklyExpenses.length,
            (index) => FlSpot(index.toDouble(), weeklyExpenses[index].amount),
          ),
          isCurved: true,
          curveSmoothness: 0.2,
          preventCurveOverShooting: true,
          color: context.tpColors.iconNeutral,
          barWidth: 2,
          dotData: FlDotData(
            show: true,
            getDotPainter: (spot, percent, bar, index) => FlDotCirclePainter(
              color: context.tpColors.surfaceNeutralComponent,
              radius: 3,
              strokeWidth: 1,
              strokeColor: context.tpColors.iconNeutral,
            ),
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                gradientBase.withValues(alpha: 0.4),
                gradientBase.withValues(alpha: 0.1),
                gradientBase.withValues(alpha: 0.0),
              ],
              stops: const [0.0, 0.5, 1.0],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLeftTitle(BuildContext context, double value, TitleMeta meta) {
    if (value < meta.min || value > meta.max) {
      return const SizedBox.shrink();
    }
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: Text(
        _formatYAxisValue(value),
        style: TPTextStyle.captionM.copyWith(color: context.tpColors.textSub),
      ),
    );
  }

  Widget _buildBottomTitle(BuildContext context, double value, TitleMeta meta) {
    if (value < meta.min || value > meta.max) {
      return const SizedBox.shrink();
    }
    final index = value.round();
    if (index < 0 || index >= weeklyExpenses.length) {
      return const SizedBox.shrink();
    }
    final date = weeklyExpenses[index].date;
    final label = DateFormat.E().format(date);
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Text(
        label,
        style: TPTextStyle.captionM.copyWith(color: context.tpColors.textSub),
      ),
    );
  }

  int _calculateMaxY(double maxAmount) {
    if (maxAmount <= 0) {
      return 5 * 1000;
    }
    final normalized = (maxAmount / 1000).ceil();
    final step = math.max(1, (normalized / 5).ceil());
    return step * 5 * 1000;
  }

  String _formatYAxisValue(double value) {
    if (value <= 0) {
      return '0';
    }
    if (value >= 1000000000) {
      final billions = (value / 1000000000).round();
      return '${billions}b';
    }
    if (value >= 1000000) {
      final millions = (value / 1000000).round();
      return '${millions}tr';
    }
    final thousands = (value / 1000).round();
    return '${thousands}k';
  }
}
