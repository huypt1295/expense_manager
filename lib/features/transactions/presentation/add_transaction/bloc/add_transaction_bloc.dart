import 'dart:async';

import 'package:expense_manager/features/categories/application/categories_service.dart';
import 'package:expense_manager/features/categories/domain/entities/category_entity.dart';
import 'package:expense_manager/features/transactions/domain/usecases/add_transaction_usecase.dart';
import 'package:expense_manager/features/transactions/domain/usecases/update_transaction_usecase.dart';
import 'package:expense_manager/features/transactions/presentation/add_transaction/bloc/add_transaction_state.dart';
import 'package:flutter_core/flutter_core.dart';

import 'add_transaction_event.dart';

@injectable
class AddTransactionBloc
    extends BaseBloc<AddTransactionEvent, AddTransactionState, NoopEffect> {
  AddTransactionBloc(
    this._addTransactionUseCase,
    this._categoriesService,
    this._updateTransactionUseCase,
  ) : super(AddTransactionInitState(date: DateTime.now())) {
    on<AddTransactionInitEvent>(_onCategoriesRequested);
    on<CategoriesStreamUpdatedEvent>(_onCategoriesStreamUpdated);
    on<CategoriesStreamFailedEvent>(_onCategoriesStreamFailed);
    on<TransactionsAddedEvent>(_onAdded);
    on<TransactionsUpdatedEvent>(_onUpdated);
  }

  final AddTransactionUseCase _addTransactionUseCase;
  final UpdateTransactionUseCase _updateTransactionUseCase;
  final CategoriesService _categoriesService;
  StreamSubscription<List<CategoryEntity>>? _categoriesSubscription;

  Future<void> _onCategoriesRequested(
    AddTransactionInitEvent event,
    Emitter<AddTransactionState> emit,
  ) async {
    _ensureCategoriesSubscription();

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

  void _onCategoriesStreamUpdated(
    CategoriesStreamUpdatedEvent event,
    Emitter<AddTransactionState> emit,
  ) {
    _updateStateWithCategories(
      emit,
      categories: List<CategoryEntity>.unmodifiable(event.categories),
      areCategoriesLoading: false,
      clearCategoriesError: true,
    );
  }

  void _onCategoriesStreamFailed(
    CategoriesStreamFailedEvent event,
    Emitter<AddTransactionState> emit,
  ) {
    _updateStateWithCategories(
      emit,
      areCategoriesLoading: false,
      categoriesError: event.message,
    );
  }

  Future<void> _onAdded(
    TransactionsAddedEvent event,
    Emitter<AddTransactionState> emit,
  ) async {
    if (event.entity.title.trim().isEmpty) {
      emit(
        AddTransactionErrorState(
          'Title is required',
          categories: state.categories,
          areCategoriesLoading: state.areCategoriesLoading,
          categoriesError: state.categoriesError,
        ),
      );
      return;
    }

    if (event.entity.amount <= 0) {
      emit(
        AddTransactionErrorState(
          'Amount must be greater than 0',
          categories: state.categories,
          areCategoriesLoading: state.areCategoriesLoading,
          categoriesError: state.categoriesError,
        ),
      );
      return;
    }

    if (event.entity.category?.trim().isEmpty == true) {
      emit(
        AddTransactionErrorState(
          'Category is required',
          categories: state.categories,
          areCategoriesLoading: state.areCategoriesLoading,
          categoriesError: state.categoriesError,
        ),
      );
      return;
    }

    await runResult<void>(
      emit: emit,
      task: () => _addTransactionUseCase(AddTransactionParams(event.entity)),
      onStart: (current) => AddTransactionLoadingState(
        categories: current.categories,
        areCategoriesLoading: current.areCategoriesLoading,
        categoriesError: current.categoriesError,
      ),
      onOk: (current, _) => AddTransactionSuccessState(
        categories: current.categories,
        areCategoriesLoading: current.areCategoriesLoading,
        categoriesError: current.categoriesError,
      ),
      onErr: (currentState, failure) {
        final message = failure.message ?? failure.code;
        emit(
          AddTransactionErrorState(
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

  Future<void> _onUpdated(
    TransactionsUpdatedEvent event,
    Emitter<AddTransactionState> emit,
  ) async {
    if (event.entity.title.trim().isEmpty) {
      emit(
        AddTransactionErrorState(
          'Title is required',
          categories: state.categories,
          areCategoriesLoading: state.areCategoriesLoading,
          categoriesError: state.categoriesError,
        ),
      );
      return;
    }

    if (event.entity.amount <= 0) {
      emit(
        AddTransactionErrorState(
          'Amount must be greater than 0',
          categories: state.categories,
          areCategoriesLoading: state.areCategoriesLoading,
          categoriesError: state.categoriesError,
        ),
      );
      return;
    }

    if (event.entity.category?.trim().isEmpty == true) {
      emit(
        AddTransactionErrorState(
          'Category is required',
          categories: state.categories,
          areCategoriesLoading: state.areCategoriesLoading,
          categoriesError: state.categoriesError,
        ),
      );
      return;
    }

    await runResult<void>(
      emit: emit,
      task: () =>
          _updateTransactionUseCase(UpdateTransactionParams(event.entity)),
      onStart: (current) => AddTransactionLoadingState(
        categories: current.categories,
        areCategoriesLoading: current.areCategoriesLoading,
        categoriesError: current.categoriesError,
      ),
      onOk: (current, _) => AddTransactionSuccessState(
        categories: current.categories,
        areCategoriesLoading: current.areCategoriesLoading,
        categoriesError: current.categoriesError,
      ),
      onErr: (currentState, failure) {
        final message = failure.message ?? failure.code;
        emit(
          AddTransactionErrorState(
            message,
            categories: currentState.categories,
            areCategoriesLoading: currentState.areCategoriesLoading,
            categoriesError: currentState.categoriesError,
          ),
        );
      },
      trackKey: 'expense.submit',
      spanName: 'transactions.update',
    );
  }

  void _ensureCategoriesSubscription() {
    if (_categoriesSubscription != null) {
      return;
    }
    _categoriesSubscription = _categoriesService.watchCategories().listen(
      (categories) {
        add(CategoriesStreamUpdatedEvent(categories));
      },
      onError: (error, stackTrace) {
        final message = error is Failure
            ? (error.message ?? error.code)
            : 'Failed to load categories';
        add(CategoriesStreamFailedEvent(message));
      },
    );
  }

  void _updateStateWithCategories(
    Emitter<AddTransactionState> emit, {
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

    if (current is AddTransactionInitState) {
      emit(
        current.copyWith(
          categories: updatedCategories,
          areCategoriesLoading: updatedLoading,
          clearCategoriesError: clearCategoriesError,
          categoriesError: categoriesError,
        ),
      );
    } else if (current is AddTransactionLoadingState) {
      emit(
        AddTransactionLoadingState(
          categories: updatedCategories,
          areCategoriesLoading: updatedLoading,
          categoriesError: updatedError,
        ),
      );
    } else if (current is AddTransactionSuccessState) {
      emit(
        AddTransactionSuccessState(
          categories: updatedCategories,
          areCategoriesLoading: updatedLoading,
          categoriesError: updatedError,
        ),
      );
    } else if (current is AddTransactionErrorState) {
      emit(
        AddTransactionErrorState(
          current.message,
          categories: updatedCategories,
          areCategoriesLoading: updatedLoading,
          categoriesError: updatedError,
        ),
      );
    }
  }

  @override
  Future<void> close() async {
    await _categoriesSubscription?.cancel();
    await super.close();
  }
}
