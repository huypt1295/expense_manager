import 'package:flutter/material.dart';
import 'package:flutter_common/flutter_common.dart';
import 'package:flutter_core/flutter_core.dart' show BaseStatelessWidget;
import 'package:flutter_resource/flutter_resource.dart' show DateFormat;

class MonthSelectorBar extends BaseStatelessWidget {
  const MonthSelectorBar({
    super.key,
    required this.selectedMonth,
    required this.onNext,
    required this.onPrevious,
  });

  final DateTime selectedMonth;
  final VoidCallback onNext;
  final VoidCallback onPrevious;

  @override
  Widget buildContent(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      backgroundColor: context.tpColors.surfaceMain,
      surfaceTintColor: context.tpColors.surfaceMain,
      title: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left),
            onPressed: onPrevious,
          ),
          Expanded(
            child: Center(
              child: Text(
                DateFormat.yMMMM().format(selectedMonth),
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
          ),
          IconButton(icon: const Icon(Icons.chevron_right), onPressed: onNext),
        ],
      ),
      titleSpacing: 0,
    );
  }
}
