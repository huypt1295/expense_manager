import 'package:expense_manager/core/enums/transaction_type.dart';
import 'package:expense_manager/features/categories/application/categories_service.dart';
import 'package:expense_manager/features/categories/domain/entities/category_entity.dart';
import 'package:expense_manager/features/transactions/domain/entities/transaction_entity.dart';
import 'package:expense_manager/features/transactions/domain/usecases/add_transaction_usecase.dart';
import 'package:flutter_core/flutter_core.dart';

import 'income_event.dart';
import 'income_state.dart';

@injectable
class IncomeBloc extends BaseBloc<IncomeEvent, IncomeState, NoopEffect> {
  IncomeBloc(this._addTransactionUseCase, this._categoriesService)
    : super(IncomeFormData(date: DateTime.now())) {
    on<IncomeFormSubmitted>(_onFormSubmitted);
    on<IncomeFormReset>(_onFormReset);
    on<IncomeFormClosed>(_onFormClosed);
    on<IncomeCategoriesRequested>(_onCategoriesRequested);
  }

  final AddTransactionUseCase _addTransactionUseCase;
  final CategoriesService _categoriesService;

  Future<void> _onFormSubmitted(
    IncomeFormSubmitted event,
    Emitter<IncomeState> emit,
  ) async {
    if (event.title.trim().isEmpty) {
      emit(
        IncomeFormError(
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
        IncomeFormError(
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
        IncomeFormError(
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
      type: TransactionType.income,
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
      onStart: (current) => IncomeFormLoading(
        categories: current.categories,
        areCategoriesLoading: current.areCategoriesLoading,
        categoriesError: current.categoriesError,
      ),
      onOk: (current, _) => IncomeFormSuccess(
        categories: current.categories,
        areCategoriesLoading: current.areCategoriesLoading,
        categoriesError: current.categoriesError,
      ),
      onErr: (currentState, failure) {
        final message = failure.message ?? failure.code;
        emit(
          IncomeFormError(
            message,
            categories: currentState.categories,
            areCategoriesLoading: currentState.areCategoriesLoading,
            categoriesError: currentState.categoriesError,
          ),
        );
      },
      trackKey: 'income.submit',
      spanName: 'transactions.add',
    );
  }

  void _onFormReset(IncomeFormReset event, Emitter<IncomeState> emit) {
    emit(
      IncomeFormData(
        date: DateTime.now(),
        categories: state.categories,
        areCategoriesLoading: state.areCategoriesLoading,
        categoriesError: state.categoriesError,
      ),
    );
  }

  void _onFormClosed(IncomeFormClosed event, Emitter<IncomeState> emit) {
    emit(
      IncomeInitial(
        categories: state.categories,
        areCategoriesLoading: state.areCategoriesLoading,
        categoriesError: state.categoriesError,
      ),
    );
  }

  Future<void> _onCategoriesRequested(
    IncomeCategoriesRequested event,
    Emitter<IncomeState> emit,
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
        type: TransactionType.income,
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
    Emitter<IncomeState> emit, {
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

    if (current is IncomeFormData) {
      emit(
        current.copyWith(
          categories: updatedCategories,
          areCategoriesLoading: updatedLoading,
          clearCategoriesError: clearCategoriesError,
          categoriesError: categoriesError,
        ),
      );
    } else if (current is IncomeFormLoading) {
      emit(
        IncomeFormLoading(
          categories: updatedCategories,
          areCategoriesLoading: updatedLoading,
          categoriesError: updatedError,
        ),
      );
    } else if (current is IncomeFormSuccess) {
      emit(
        IncomeFormSuccess(
          categories: updatedCategories,
          areCategoriesLoading: updatedLoading,
          categoriesError: updatedError,
        ),
      );
    } else if (current is IncomeFormError) {
      emit(
        IncomeFormError(
          current.message,
          categories: updatedCategories,
          areCategoriesLoading: updatedLoading,
          categoriesError: updatedError,
        ),
      );
    } else {
      emit(
        IncomeInitial(
          categories: updatedCategories,
          areCategoriesLoading: updatedLoading,
          categoriesError: updatedError,
        ),
      );
    }
  }
}
