import 'package:flutter_core/src/foundation/foundation.dart';

abstract class ErrorUiModel {
  final String i10nKey;
  final Map<String, String> args;
  final bool retryable;

  const ErrorUiModel(this.i10nKey,
      {this.args = const {}, this.retryable = false});

  ErrorUiModel failureToUi(Failure f);
}
