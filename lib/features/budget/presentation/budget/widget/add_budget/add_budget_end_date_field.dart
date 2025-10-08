import 'package:flutter/material.dart';
import 'package:flutter_core/flutter_core.dart';
import 'package:flutter_common/flutter_common.dart';
import 'package:flutter_resource/flutter_resource.dart' show DateFormat;

class AddBudgetEndDateField extends BaseStatelessWidget {
  const AddBudgetEndDateField({
    super.key,
    required this.onPressed,
    required this.endDate,
  });

  final VoidCallback onPressed;
  final DateTime endDate;

  @override
  Widget buildContent(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('End date'),
            Text(endDate.toStringWithFormat(DateFormat.yMMMd())),
          ],
        ),
        TextButton(onPressed: onPressed, child: const Text('Change')),
      ],
    );
  }
}
