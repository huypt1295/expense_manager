import 'package:flutter/material.dart';
import 'package:flutter_core/flutter_core.dart';
import 'package:flutter_resource/flutter_resource.dart';

class BudgetEmptyWidget extends BaseStatelessWidget {
  const BudgetEmptyWidget({super.key});

  @override
  Widget buildContent(BuildContext context) {
    return Center(
      child: Text(
        'No budgets configured',
        style: TPTextStyle.titleM,
      ),
    );
  }
}
