import 'package:flutter_core/flutter_core.dart';

abstract class IncomeEvent extends BaseBlocEvent with EquatableMixin {
  const IncomeEvent();

  @override
  List<Object?> get props => [];
}

class IncomeFormSubmitted extends IncomeEvent {
  final String title;
  final double amount;
  final String category;
  final String description;
  final DateTime date;
  final String categoryIcon;

  const IncomeFormSubmitted({
    required this.title,
    required this.amount,
    required this.category,
    required this.description,
    required this.date,
    required this.categoryIcon,
  });

  @override
  List<Object?> get props => [
    title,
    amount,
    category,
    description,
    date,
    categoryIcon,
  ];
}

class IncomeFormReset extends IncomeEvent {
  const IncomeFormReset();
}

class IncomeFormClosed extends IncomeEvent {
  const IncomeFormClosed();
}

class IncomeCategoriesRequested extends IncomeEvent {
  const IncomeCategoriesRequested({this.forceRefresh = false});

  final bool forceRefresh;

  @override
  List<Object?> get props => [forceRefresh];
}
