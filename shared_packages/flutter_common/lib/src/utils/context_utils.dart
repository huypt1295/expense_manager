import 'package:flutter/material.dart';
import 'package:flutter_common/src/utils/color_utils.dart';
import 'package:flutter_resource/flutter_resource.dart';

/// Convenience extension for exposing theme colors on a [BuildContext].
extension ContextX on BuildContext {
  /// Returns the strongly typed app color scheme from the current theme.
  AppColorSchemeExtension get tpColors => Theme.of(this).appColors!;
}
