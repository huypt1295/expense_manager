import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_core/flutter_core.dart';
import 'package:flutter_common/flutter_common.dart';
import 'package:flutter_resource/flutter_resource.dart'
    show DateFormat, TPTextStyle;
import 'package:flutter_resource/l10n/gen/l10n.dart';

class AddBudgetDateTimeField extends BaseStatelessWidget {
  const AddBudgetDateTimeField({
    super.key,
    required this.initialDateTime,
    required this.onDateTimeChanged,
  });

  final DateTime initialDateTime;
  final ValueChanged<DateTime> onDateTimeChanged;

  @override
  Widget buildContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          S.current.date_time,
          style: TPTextStyle.bodyM.copyWith(color: context.tpColors.textMain),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: () {
            _showDialog(context);
          },
          child: Container(
            height: 48,
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: context.tpColors.borderDefault),
            ),
            child: Text(
              DateFormat.yMMM().format(initialDateTime),
              style: TPTextStyle.bodyS,
            ),
          ),
        ),
      ],
    );
  }

  // This function displays a CupertinoModalPopup with a reasonable fixed height
  // which hosts CupertinoDatePicker.
  void _showDialog(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (_) => Container(
        height: 300,
        color: CupertinoColors.systemBackground.resolveFrom(context),
        padding: const EdgeInsets.only(top: 0.0),
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: SafeArea(
          top: false,
          child: Column(
            children: [
              // Toolbar
              Align(
                alignment: Alignment.centerRight,
                child: CupertinoButton(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    S.current.done,
                    style: TPTextStyle.bodyM.copyWith(
                      color: context.tpColors.textMain,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.monthYear,
                  initialDateTime: DateTime.now(),
                  minimumYear: 2020,
                  maximumYear: DateTime.now().year + 5,
                  onDateTimeChanged: onDateTimeChanged,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
