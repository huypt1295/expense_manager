import 'package:flutter/material.dart';
import 'package:flutter_core/flutter_core.dart';

class AddBudgetSubmitButton extends BaseStatelessWidget {
  const AddBudgetSubmitButton({
    super.key,
    required this.onSubmit,
    this.isInitial = false,
  });

  final VoidCallback onSubmit;
  final bool isInitial;

  @override
  Widget buildContent(BuildContext context) {
    return ElevatedButton(
      onPressed: onSubmit,
      child: Text(isInitial ? 'Create' : 'Save'),
    );
  }
}
