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

  const ExpenseFormSubmitted({
    required this.title,
    required this.amount,
    required this.category,
    required this.description,
    required this.date,
  });

  @override
  List<Object?> get props => [title, amount, category, description, date];
}

class ExpenseFormReset extends ExpenseEvent {
  const ExpenseFormReset();
}

class ExpenseFormClosed extends ExpenseEvent {
  const ExpenseFormClosed();
}
