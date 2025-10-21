import 'package:expense_manager/features/categories/domain/entities/category_entity.dart';
import 'package:flutter_core/flutter_core.dart';

// States
abstract class AddTransactionState extends BaseBlocState with EquatableMixin {
  const AddTransactionState({
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

class AddTransactionInitState extends AddTransactionState {
  final String title;
  final double amount;
  final String category;
  final String description;
  final DateTime date;

  const AddTransactionInitState({
    this.title = '',
    this.amount = 0.0,
    this.category = '',
    this.description = '',
    required this.date,
    super.categories,
    super.areCategoriesLoading,
    super.categoriesError,
  });

  AddTransactionInitState copyWith({
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
    return AddTransactionInitState(
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

class AddTransactionLoadingState extends AddTransactionState {
  const AddTransactionLoadingState({
    super.categories,
    super.areCategoriesLoading,
    super.categoriesError,
  });
}

class AddTransactionSuccessState extends AddTransactionState {
  const AddTransactionSuccessState({
    super.categories,
    super.areCategoriesLoading,
    super.categoriesError,
  });
}

class AddTransactionErrorState extends AddTransactionState {
  final String message;

  const AddTransactionErrorState(
    this.message, {
    super.categories,
    super.areCategoriesLoading,
    super.categoriesError,
  });

  @override
  List<Object?> get props => <Object?>[...super.props, message];
}
