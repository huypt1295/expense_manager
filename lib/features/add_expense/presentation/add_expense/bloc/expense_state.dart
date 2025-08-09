import 'package:flutter_core/flutter_core.dart';

// States
abstract class ExpenseState extends BaseBlocState with EquatableMixin {
  const ExpenseState();

  @override
  List<Object?> get props => [];
}

class ExpenseInitial extends ExpenseState {
  const ExpenseInitial();
}

class ExpenseFormLoading extends ExpenseState {
  const ExpenseFormLoading();
}

class ExpenseFormSuccess extends ExpenseState {
  const ExpenseFormSuccess();
}

class ExpenseFormError extends ExpenseState {
  final String message;

  const ExpenseFormError(this.message);

  @override
  List<Object?> get props => [message];
}

class ExpenseFormData extends ExpenseState {
  final String title;
  final double amount;
  final String category;
  final String description;
  final DateTime date;

  const ExpenseFormData({
    this.title = '',
    this.amount = 0.0,
    this.category = '',
    this.description = '',
    required this.date,
  });

  @override
  List<Object?> get props => [title, amount, category, description, date];

  ExpenseFormData copyWith({
    String? title,
    double? amount,
    String? category,
    String? description,
    DateTime? date,
  }) {
    return ExpenseFormData(
      title: title ?? this.title,
      amount: amount ?? this.amount,
      category: category ?? this.category,
      description: description ?? this.description,
      date: date ?? this.date,
    );
  }
}
