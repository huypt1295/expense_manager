import 'package:expense_manager/core/enums/transaction_type.dart';
import 'package:expense_manager/features/categories/application/categories_service.dart';
import 'package:expense_manager/features/categories/domain/entities/category_entity.dart';
import 'package:expense_manager/features/transactions/domain/entities/transaction_entity.dart';
import 'package:expense_manager/features/transactions/domain/usecases/add_transaction_usecase.dart';
import 'package:flutter_core/flutter_core.dart';

import 'expense_event.dart';
import 'expense_state.dart';

@injectable
class ExpenseBloc extends BaseBloc<ExpenseEvent, ExpenseState, NoopEffect> {
  ExpenseBloc(this._addTransactionUseCase, this._categoriesService)
    : super(ExpenseFormData(date: DateTime.now())) {
    on<ExpenseFormSubmitted>(_onFormSubmitted);
    on<ExpenseFormReset>(_onFormReset);
    on<ExpenseFormClosed>(_onFormClosed);
    on<ExpenseCategoriesRequested>(_onCategoriesRequested);
  }

  final AddTransactionUseCase _addTransactionUseCase;
  final CategoriesService _categoriesService;

  Future<void> _onFormSubmitted(
    ExpenseFormSubmitted event,
    Emitter<ExpenseState> emit,
  ) async {
    if (event.title.trim().isEmpty) {
      emit(
        ExpenseFormError(
          'Title is required',
          categories: state.categories,
          areCategoriesLoading: state.areCategoriesLoading,
          categoriesError: state.categoriesError,
        ),
      );
      return;
    }

    if (event.amount <= 0) {
      emit(
        ExpenseFormError(
          'Amount must be greater than 0',
          categories: state.categories,
          areCategoriesLoading: state.areCategoriesLoading,
          categoriesError: state.categoriesError,
        ),
      );
      return;
    }

    if (event.category.trim().isEmpty) {
      emit(
        ExpenseFormError(
          'Category is required',
          categories: state.categories,
          areCategoriesLoading: state.areCategoriesLoading,
          categoriesError: state.categoriesError,
        ),
      );
      return;
    }

    final entity = TransactionEntity(
      id: '',
      title: event.title.trim(),
      amount: event.amount,
      type: event.type,
      category: event.category.trim(),
      note: event.description.trim().isEmpty ? null : event.description.trim(),
      date: event.date,
      categoryIcon: event.categoryIcon.trim().isEmpty
          ? null
          : event.categoryIcon.trim(),
    );

    await runResult<void>(
      emit: emit,
      task: () => _addTransactionUseCase(AddTransactionParams(entity)),
      onStart: (current) => ExpenseFormLoading(
        categories: current.categories,
        areCategoriesLoading: current.areCategoriesLoading,
        categoriesError: current.categoriesError,
      ),
      onOk: (current, _) => ExpenseFormSuccess(
        categories: current.categories,
        areCategoriesLoading: current.areCategoriesLoading,
        categoriesError: current.categoriesError,
      ),
      onErr: (currentState, failure) {
        final message = failure.message ?? failure.code;
        emit(
          ExpenseFormError(
            message,
            categories: currentState.categories,
            areCategoriesLoading: currentState.areCategoriesLoading,
            categoriesError: currentState.categoriesError,
          ),
        );
      },
      trackKey: 'expense.submit',
      spanName: 'transactions.add',
    );
  }

  void _onFormReset(ExpenseFormReset event, Emitter<ExpenseState> emit) {
    emit(
      ExpenseFormData(
        date: DateTime.now(),
        categories: state.categories,
        areCategoriesLoading: state.areCategoriesLoading,
        categoriesError: state.categoriesError,
      ),
    );
  }

  void _onFormClosed(ExpenseFormClosed event, Emitter<ExpenseState> emit) {
    emit(
      ExpenseInitial(
        categories: state.categories,
        areCategoriesLoading: state.areCategoriesLoading,
        categoriesError: state.categoriesError,
      ),
    );
  }

  Future<void> _onCategoriesRequested(
    ExpenseCategoriesRequested event,
    Emitter<ExpenseState> emit,
  ) async {
    if (state.areCategoriesLoading) {
      return;
    }
    if (!event.forceRefresh && state.categories.isNotEmpty) {
      return;
    }

    _updateStateWithCategories(
      emit,
      areCategoriesLoading: true,
      clearCategoriesError: true,
    );

    try {
      final categories = await _categoriesService.getCategories(
        forceRefresh: event.forceRefresh,
      );
      _updateStateWithCategories(
        emit,
        categories: List<CategoryEntity>.unmodifiable(categories),
        areCategoriesLoading: false,
        clearCategoriesError: true,
      );
    } catch (error) {
      final message = error is Failure
          ? (error.message ?? error.code)
          : 'Failed to load categories';
      _updateStateWithCategories(
        emit,
        areCategoriesLoading: false,
        categoriesError: message,
      );
    }
  }

  void _updateStateWithCategories(
    Emitter<ExpenseState> emit, {
    List<CategoryEntity>? categories,
    bool? areCategoriesLoading,
    bool clearCategoriesError = false,
    String? categoriesError,
  }) {
    final current = state;
    final updatedCategories = categories ?? current.categories;
    final updatedLoading = areCategoriesLoading ?? current.areCategoriesLoading;
    final updatedError = clearCategoriesError
        ? null
        : (categoriesError ?? current.categoriesError);

    if (current is ExpenseFormData) {
      emit(
        current.copyWith(
          categories: updatedCategories,
          areCategoriesLoading: updatedLoading,
          clearCategoriesError: clearCategoriesError,
          categoriesError: categoriesError,
        ),
      );
    } else if (current is ExpenseFormLoading) {
      emit(
        ExpenseFormLoading(
          categories: updatedCategories,
          areCategoriesLoading: updatedLoading,
          categoriesError: updatedError,
        ),
      );
    } else if (current is ExpenseFormSuccess) {
      emit(
        ExpenseFormSuccess(
          categories: updatedCategories,
          areCategoriesLoading: updatedLoading,
          categoriesError: updatedError,
        ),
      );
    } else if (current is ExpenseFormError) {
      emit(
        ExpenseFormError(
          current.message,
          categories: updatedCategories,
          areCategoriesLoading: updatedLoading,
          categoriesError: updatedError,
        ),
      );
    } else {
      emit(
        ExpenseInitial(
          categories: updatedCategories,
          areCategoriesLoading: updatedLoading,
          categoriesError: updatedError,
        ),
      );
    }
  }
}
