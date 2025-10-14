import 'package:expense_manager/features/categories/domain/entities/category_entity.dart';
import 'package:flutter_core/flutter_core.dart';

// States
abstract class ExpenseState extends BaseBlocState with EquatableMixin {
  const ExpenseState({
    this.categories = const <CategoryEntity>[],
    this.areCategoriesLoading = false,
    this.categoriesError,
  });

  final List<CategoryEntity> categories;
  final bool areCategoriesLoading;
  final String? categoriesError;

  @override
  List<Object?> get props => <Object?>[
    categories,
    areCategoriesLoading,
    categoriesError,
  ];
}

class ExpenseInitial extends ExpenseState {
  const ExpenseInitial({
    super.categories,
    super.areCategoriesLoading,
    super.categoriesError,
  });
}

class ExpenseFormLoading extends ExpenseState {
  const ExpenseFormLoading({
    super.categories,
    super.areCategoriesLoading,
    super.categoriesError,
  });
}

class ExpenseFormSuccess extends ExpenseState {
  const ExpenseFormSuccess({
    super.categories,
    super.areCategoriesLoading,
    super.categoriesError,
  });
}

class ExpenseFormError extends ExpenseState {
  final String message;

  const ExpenseFormError(
    this.message, {
    super.categories,
    super.areCategoriesLoading,
    super.categoriesError,
  });

  @override
  List<Object?> get props => <Object?>[...super.props, message];
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
    super.categories,
    super.areCategoriesLoading,
    super.categoriesError,
  });

  @override
  List<Object?> get props => <Object?>[
    ...super.props,
    title,
    amount,
    category,
    description,
    date,
  ];

  ExpenseFormData copyWith({
    String? title,
    double? amount,
    String? category,
    String? description,
    DateTime? date,
    List<CategoryEntity>? categories,
    bool? areCategoriesLoading,
    bool clearCategoriesError = false,
    String? categoriesError,
  }) {
    return ExpenseFormData(
      title: title ?? this.title,
      amount: amount ?? this.amount,
      category: category ?? this.category,
      description: description ?? this.description,
      date: date ?? this.date,
      categories: categories ?? this.categories,
      areCategoriesLoading: areCategoriesLoading ?? this.areCategoriesLoading,
      categoriesError: clearCategoriesError
          ? null
          : (categoriesError ?? this.categoriesError),
    );
  }
}
