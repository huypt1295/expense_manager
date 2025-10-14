enum TransactionType {
  expense,
  income,
}

TransactionType parseTransactionType(
  dynamic raw, {
  TransactionType fallback = TransactionType.expense,
}) {
  if (raw is TransactionType) {
    return raw;
  }
  if (raw is String) {
    final normalized = raw.trim().toLowerCase();
    switch (normalized) {
      case 'expense':
        return TransactionType.expense;
      case 'income':
        return TransactionType.income;
    }
  }
  return fallback;
}

String transactionTypeToJson(TransactionType type) {
  switch (type) {
    case TransactionType.expense:
      return 'expense';
    case TransactionType.income:
      return 'income';
  }
}

extension TransactionTypeX on TransactionType {
  bool get isExpense => this == TransactionType.expense;

  bool get isIncome => this == TransactionType.income;
}
