import 'package:flutter/material.dart';
import 'package:flutter_core/flutter_core.dart';
import 'package:flutter_resource/flutter_resource.dart';

class SummaryEmptyWidget extends BaseStatelessWidget {
  const SummaryEmptyWidget({super.key});

  @override
  Widget buildContent(BuildContext context) {
    return Text(
      'No activity recorded yet. Add your first transaction!',
      style: TPTextStyle.bodyInfoM,
    );
  }
}
