import 'package:flutter/material.dart';
import 'package:flutter_core/flutter_core.dart';
import 'package:flutter_resource/l10n/gen/l10n.dart';

class AddExpenseDivider extends BaseStatelessWidget {
  const AddExpenseDivider({super.key});

  @override
  Widget buildContent(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          Expanded(child: Container(height: 1, color: Colors.grey[300])),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              S.current.manual_input,
              style: TextStyle(
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(child: Container(height: 1, color: Colors.grey[300])),
        ],
      ),
    );
  }
}
