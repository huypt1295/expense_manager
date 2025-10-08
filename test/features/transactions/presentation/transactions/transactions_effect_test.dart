import 'package:expense_manager/features/transactions/presentation/transactions/bloc/transactions_effect.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('TransactionsShowErrorEffect exposes message', () {
    const effect = TransactionsShowErrorEffect('error');
    expect(effect.message, 'error');
  });

  test('TransactionsShowSuccessEffect holds optional description', () {
    const effect = TransactionsShowSuccessEffect('success');
    expect(effect.message, 'success');
  });

  test('TransactionsShowUndoDeleteEffect exposes configuration', () {
    const effect = TransactionsShowUndoDeleteEffect(
      message: 'deleted',
      actionLabel: 'Undo',
      duration: Duration(seconds: 3),
    );
    expect(effect.message, 'deleted');
    expect(effect.actionLabel, 'Undo');
    expect(effect.duration, const Duration(seconds: 3));
  });
}
