import 'package:expense_manager/features/categories/domain/entities/category_entity.dart';
import 'package:flutter_core/flutter_core.dart';

abstract class IncomeState extends BaseBlocState with EquatableMixin {
  const IncomeState({
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

class IncomeInitial extends IncomeState {
  const IncomeInitial({
    super.categories,
    super.areCategoriesLoading,
    super.categoriesError,
  });
}

class IncomeFormLoading extends IncomeState {
  const IncomeFormLoading({
    super.categories,
    super.areCategoriesLoading,
    super.categoriesError,
  });
}

class IncomeFormSuccess extends IncomeState {
  const IncomeFormSuccess({
    super.categories,
    super.areCategoriesLoading,
    super.categoriesError,
  });
}

class IncomeFormError extends IncomeState {
  final String message;

  const IncomeFormError(
    this.message, {
    super.categories,
    super.areCategoriesLoading,
    super.categoriesError,
  });

  @override
  List<Object?> get props => <Object?>[...super.props, message];
}

class IncomeFormData extends IncomeState {
  final String title;
  final double amount;
  final String category;
  final String description;
  final DateTime date;

  const IncomeFormData({
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

  IncomeFormData copyWith({
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
    return IncomeFormData(
      title: title ?? this.title,
      amount: amount ?? this.amount,
      category: category ?? this.category,
      description: description ?? this.description,
      date: date ?? this.date,
      categories: categories ?? this.categories,
      areCategoriesLoading: areCategoriesLoading ?? this.areCategoriesLoading,
      categoriesError:
          clearCategoriesError ? null : (categoriesError ?? this.categoriesError),
    );
  }
}
