import 'package:flutter/material.dart';
import 'package:flutter_common/flutter_common.dart';
import 'package:flutter_core/flutter_core.dart';
import 'package:flutter_resource/flutter_resource.dart';

class SummarySpendingWidget extends BaseStatelessWidget {
  const SummarySpendingWidget({super.key, required this.monthTotal});

  final double monthTotal;

  @override
  Widget buildContent(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: context.tpColors.surfacePositive,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'This month spending',
            style: TPTextStyle.titleS,
          ),
          const SizedBox(height: 8),
          Text(
            CurrencyUtils.formatVndFromDouble(monthTotal),
            style: TPTextStyle.bodyInfoL,
          ),
        ],
      ),
    );
  }
}
