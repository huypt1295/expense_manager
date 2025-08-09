import 'package:flutter_core/flutter_core.dart';
import 'expense_event.dart';
import 'expense_state.dart';

// Bloc
class ExpenseBloc extends BaseBloc<ExpenseEvent, ExpenseState> {
  ExpenseBloc() : super(ExpenseFormData(date: DateTime.now())) {
    on<ExpenseFormSubmitted>(_onFormSubmitted);
    on<ExpenseFormReset>(_onFormReset);
    on<ExpenseFormClosed>(_onFormClosed);
  }

  void _onFormSubmitted(
      ExpenseFormSubmitted event, Emitter<ExpenseState> emit) async {
    emit(const ExpenseFormLoading());

    try {
      // Simulate API call to save expense
      await Future.delayed(const Duration(milliseconds: 1000));

      // Validate form data
      if (event.title.isEmpty) {
        emit(const ExpenseFormError('Title is required'));
        return;
      }

      if (event.amount <= 0) {
        emit(const ExpenseFormError('Amount must be greater than 0'));
        return;
      }

      if (event.category.isEmpty) {
        emit(const ExpenseFormError('Category is required'));
        return;
      }

      // Success - expense saved
      emit(const ExpenseFormSuccess());
    } catch (e) {
      emit(ExpenseFormError(e.toString()));
    }
  }

  void _onFormReset(ExpenseFormReset event, Emitter<ExpenseState> emit) {
    emit(ExpenseFormData(date: DateTime.now()));
  }

  void _onFormClosed(ExpenseFormClosed event, Emitter<ExpenseState> emit) {
    emit(const ExpenseInitial());
  }
}
