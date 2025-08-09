import 'package:flutter/material.dart';
import 'package:flutter_common/src/utils/color_utils.dart';
import 'package:flutter_resource/flutter_resource.dart';

extension ContextX on BuildContext {
  AppColorSchemeExtension get tpColors => Theme.of(this).appColors!;
}
