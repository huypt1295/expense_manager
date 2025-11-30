import 'package:expense_manager/core/enums/transaction_type.dart';
import 'package:expense_manager/features/transactions/domain/entities/transaction_entity.dart';
import 'package:expense_manager/features/transactions/domain/usecases/add_transaction_usecase.dart';
import 'package:flutter_core/flutter_core.dart';

import 'expense_event.dart';
import 'expense_state.dart';

@injectable
class ExpenseBloc extends BaseBloc<ExpenseEvent, ExpenseState, NoopEffect> {
  ExpenseBloc(this._addTransactionUseCase)
    : super(ExpenseFormData(date: DateTime.now())) {
    on<ExpenseFormSubmitted>(_onFormSubmitted);
    on<ExpenseFormReset>(_onFormReset);
    on<ExpenseFormClosed>(_onFormClosed);
  }

  final AddTransactionUseCase _addTransactionUseCase;

  Future<void> _onFormSubmitted(
    ExpenseFormSubmitted event,
    Emitter<ExpenseState> emit,
  ) async {
    if (event.title.trim().isEmpty) {
      emit(const ExpenseFormError('Title is required'));
      return;
    }

    if (event.amount <= 0) {
      emit(const ExpenseFormError('Amount must be greater than 0'));
      return;
    }

    if (event.category.trim().isEmpty) {
      emit(const ExpenseFormError('Category is required'));
      return;
    }

    final entity = TransactionEntity(
      id: '',
      title: event.title.trim(),
      amount: event.amount,
      type: TransactionType.expense,
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
      onStart: (_) => const ExpenseFormLoading(),
      onOk: (_, _) => const ExpenseFormSuccess(),
      onErr: (_, failure) {
        final message = failure.message ?? failure.code;
        emit(ExpenseFormError(message));
      },
      trackKey: 'expense.submit',
      spanName: 'transactions.add',
    );
  }

  void _onFormReset(ExpenseFormReset event, Emitter<ExpenseState> emit) {
    emit(ExpenseFormData(date: DateTime.now()));
  }

  void _onFormClosed(ExpenseFormClosed event, Emitter<ExpenseState> emit) {
    emit(const ExpenseInitial());
  }
}
