import 'package:flutter/material.dart';
import 'package:flutter_core/flutter_core.dart';
import 'package:flutter_resource/flutter_resource.dart';

class TransactionEmptyWidget extends BaseStatelessWidget {
  const TransactionEmptyWidget({super.key});

  @override
  Widget buildContent(BuildContext context) {
    return Center(child: Text('No transactions yet', style: TPTextStyle.bodyL));
  }
}
