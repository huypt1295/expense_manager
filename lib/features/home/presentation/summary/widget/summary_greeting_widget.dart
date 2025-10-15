import 'package:flutter/material.dart';
import 'package:flutter_core/flutter_core.dart';
import 'package:flutter_resource/flutter_resource.dart';

class SummaryGreetingWidget extends BaseStatelessWidget {
  const SummaryGreetingWidget({super.key, required this.username});

  final String username;

  @override
  Widget buildContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(S.current.greeting(username), style: TPTextStyle.titleM),
        const SizedBox(height: 4),
        Text(DateFormat.yMMMM().format(DateTime.now()), style: TPTextStyle.bodyS,),
      ],
    );
  }
}
