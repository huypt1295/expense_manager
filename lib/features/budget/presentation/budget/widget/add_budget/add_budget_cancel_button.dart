import 'package:flutter/material.dart';
import 'package:flutter_core/flutter_core.dart';

class AddBudgetCancelButton extends BaseStatelessWidget {
  const AddBudgetCancelButton({super.key});

  @override
  Widget buildContent(BuildContext context) {
    return TextButton(
      onPressed: () => context.pop(),
      child: const Text('Cancel'),
    );
  }
}
