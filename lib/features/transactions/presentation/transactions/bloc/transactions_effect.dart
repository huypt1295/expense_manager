import 'package:flutter_core/flutter_core.dart';

sealed class TransactionsEffect extends Effect {
  const TransactionsEffect();
}

class TransactionsShowErrorEffect extends TransactionsEffect {
  const TransactionsShowErrorEffect(this.message);

  final String message;
}

class TransactionsShowSuccessEffect extends TransactionsEffect {
  const TransactionsShowSuccessEffect(this.message);

  final String message;
}

class TransactionsShowUndoDeleteEffect extends TransactionsEffect {
  const TransactionsShowUndoDeleteEffect({
    required this.message,
    required this.actionLabel,
    required this.duration,
  });

  final String message;
  final String actionLabel;
  final Duration duration;
}
