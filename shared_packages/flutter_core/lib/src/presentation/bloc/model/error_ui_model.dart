import 'package:flutter_core/src/foundation/foundation.dart';

/// Base representation of an error message ready to be surfaced on the UI.
abstract class ErrorUiModel {
  /// Localization key identifying the error message.
  final String i10nKey;

  /// Optional interpolation parameters used when rendering the message.
  final Map<String, String> args;

  /// Indicates whether the user can retry the failed action.
  final bool retryable;

  const ErrorUiModel(
    this.i10nKey, {
    this.args = const {},
    this.retryable = false,
  });

  /// Maps a domain [Failure] into a UI-ready error model.
  ErrorUiModel failureToUi(Failure f);
}
