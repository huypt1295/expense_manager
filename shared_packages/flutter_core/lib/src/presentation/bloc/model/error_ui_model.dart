import 'package:flutter_core/src/foundation/foundation.dart';

/// Base contract for describing how failures should be rendered in the UI.
abstract class ErrorUiModel {
  /// Localization key used to display the error message.
  final String i10nKey;

  /// Arguments passed to the localization layer.
  final Map<String, String> args;

  /// Indicates whether the associated action can be retried by the user.
  final bool retryAble;

  const ErrorUiModel(
    this.i10nKey, {
    this.args = const {},
    this.retryAble = false,
  });

  /// Converts a [Failure] into a UI-friendly error representation.
  ErrorUiModel failureToUi(Failure f);
}
