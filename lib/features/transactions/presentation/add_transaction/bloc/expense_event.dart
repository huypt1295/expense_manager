import 'package:expense_manager/core/enums/transaction_type.dart';
import 'package:flutter_core/flutter_core.dart';

// Events
abstract class ExpenseEvent extends BaseBlocEvent with EquatableMixin {
  const ExpenseEvent();

  @override
  List<Object?> get props => [];
}

class ExpenseFormSubmitted extends ExpenseEvent {
  final String title;
  final double amount;
  final String category;
  final String description;
  final DateTime date;
  final TransactionType type;
  final String categoryIcon;

  const ExpenseFormSubmitted({
    required this.title,
    required this.amount,
    required this.category,
    required this.description,
    required this.date,
    required this.type,
    required this.categoryIcon,
  });

  @override
  List<Object?> get props => [
    title,
    amount,
    category,
    description,
    date,
    type,
    categoryIcon,
  ];
}

class ExpenseFormReset extends ExpenseEvent {
  const ExpenseFormReset();
}

class ExpenseFormClosed extends ExpenseEvent {
  const ExpenseFormClosed();
}

class ExpenseCategoriesRequested extends ExpenseEvent {
  const ExpenseCategoriesRequested({this.forceRefresh = false});

  final bool forceRefresh;

  @override
  List<Object?> get props => [forceRefresh];
}
