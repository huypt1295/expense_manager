import 'package:flutter/material.dart';
import 'package:flutter_core/flutter_core.dart';
import 'package:flutter_common/flutter_common.dart';
import 'package:flutter_resource/flutter_resource.dart' show DateFormat;

class AddBudgetStartDateField extends BaseStatelessWidget {
  const AddBudgetStartDateField({
    super.key,
    required this.onPressed,
    required this.startDate,
  });

  final VoidCallback onPressed;
  final DateTime startDate;

  @override
  Widget buildContent(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Start date'),
            Text(startDate.toStringWithFormat(DateFormat.yMMMd())),
          ],
        ),
        TextButton(onPressed: onPressed, child: const Text('Change')),
      ],
    );
  }
}
