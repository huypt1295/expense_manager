import 'package:flutter/material.dart';
import 'package:flutter_core/flutter_core.dart';
import 'package:flutter_resource/flutter_resource.dart';

class SummaryGreetingWidget extends BaseStatelessWidget {
  const SummaryGreetingWidget({super.key, required this.greeting});

  final String greeting;

  @override
  Widget buildContent(BuildContext context) {
    return Text(
      'Hello, $greeting! 👋',
      style: TPTextStyle.titleM,
    );
  }
}
