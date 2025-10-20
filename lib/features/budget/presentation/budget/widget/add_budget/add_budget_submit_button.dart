import 'package:flutter/material.dart';
import 'package:flutter_common/flutter_common.dart' show CommonPrimaryButton;
import 'package:flutter_core/flutter_core.dart';
import 'package:flutter_resource/l10n/gen/l10n.dart';

class AddBudgetSubmitButton extends BaseStatelessWidget {
  const AddBudgetSubmitButton({
    super.key,
    required this.onSubmit,
  });

  final VoidCallback onSubmit;

  @override
  Widget buildContent(BuildContext context) {
    return CommonPrimaryButton(
      onPressed: onSubmit,
      child: Text(S.current.save),
    );
  }
}
