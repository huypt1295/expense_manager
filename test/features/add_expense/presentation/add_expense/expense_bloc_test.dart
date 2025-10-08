import 'dart:async';

import 'package:expense_manager/features/add_expense/presentation/add_expense/bloc/expense_bloc.dart';
import 'package:expense_manager/features/add_expense/presentation/add_expense/bloc/expense_event.dart';
import 'package:expense_manager/features/add_expense/presentation/add_expense/bloc/expense_state.dart';
import 'package:expense_manager/features/transactions/domain/entities/transaction_entity.dart';
import 'package:expense_manager/features/transactions/domain/repositories/transactions_repository.dart';
import 'package:expense_manager/features/transactions/domain/usecases/add_transaction_usecase.dart';
import 'package:flutter_core/flutter_core.dart' hide test;
import 'package:flutter_test/flutter_test.dart';

class _FakeTransactionsRepository implements TransactionsRepository {
  _FakeTransactionsRepository({this.addImpl});

  Future<void> Function(TransactionEntity entity)? addImpl;

  TransactionEntity? lastAdded;

  @override
  Future<void> add(TransactionEntity entity) async {
    lastAdded = entity;
    if (addImpl != null) {
      await addImpl!(entity);
    }
  }

  @override
  Stream<List<TransactionEntity>> watchAll() => const Stream.empty();

  @override
  Future<List<TransactionEntity>> getAllOnce() async => const [];

  @override
  Future<void> update(TransactionEntity entity) async {}

  @override
  Future<void> deleteById(String id) async {}
}

void main() {
  late _FakeTransactionsRepository repository;
  late ExpenseBloc bloc;

  setUp(() {
    repository = _FakeTransactionsRepository();
    bloc = ExpenseBloc(AddTransactionUseCase(repository));
  });

  tearDown(() async {
    await bloc.close();
  });

  group('ExpenseBloc validation', () {
    test('emits error when title is empty', () async {
      final expectation = expectLater(
        bloc.stream,
        emitsInOrder([
          isA<ExpenseFormError>().having(
            (state) => state.message,
            'message',
            'Title is required',
          ),
        ]),
      );

      bloc.add(
        ExpenseFormSubmitted(
          title: '   ',
          amount: 100,
          category: 'Food',
          description: '',
          date: DateTime(2024, 1, 1),
        ),
      );

      await expectation;
    });

    test('emits error when amount <= 0', () async {
      final expectation = expectLater(
        bloc.stream,
        emitsInOrder([
          isA<ExpenseFormError>().having(
            (state) => state.message,
            'message',
            'Amount must be greater than 0',
          ),
        ]),
      );

      bloc.add(
        ExpenseFormSubmitted(
          title: 'Lunch',
          amount: 0,
          category: 'Food',
          description: '',
          date: DateTime(2024, 1, 1),
        ),
      );

      await expectation;
    });

    test('emits error when category is empty', () async {
      final expectation = expectLater(
        bloc.stream,
        emitsInOrder([
          isA<ExpenseFormError>().having(
            (state) => state.message,
            'message',
            'Category is required',
          ),
        ]),
      );

      bloc.add(
        ExpenseFormSubmitted(
          title: 'Lunch',
          amount: 100,
          category: '   ',
          description: '',
          date: DateTime(2024, 1, 1),
        ),
      );

      await expectation;
    });
  });

  group('ExpenseBloc submission', () {
    test('emits loading then success on valid submission', () async {
      final expectation = expectLater(
        bloc.stream,
        emitsInOrder([
          isA<ExpenseFormLoading>(),
          isA<ExpenseFormSuccess>(),
        ]),
      );

      bloc.add(
        ExpenseFormSubmitted(
          title: 'Dinner',
          amount: 50,
          category: 'Food',
          description: 'Nice meal',
          date: DateTime(2024, 1, 2),
        ),
      );

      await expectation;

      final added = repository.lastAdded;
      expect(added, isNotNull);
      expect(added!.title, 'Dinner');
      expect(added.amount, 50);
      expect(added.category, 'Food');
      expect(added.note, 'Nice meal');
      expect(added.date, DateTime(2024, 1, 2));
    });

    test('emits error when repository throws', () async {
      repository.addImpl = (_) async {
        throw AuthException('auth.failed');
      };

      final expectation = expectLater(
        bloc.stream,
        emitsInOrder([
          isA<ExpenseFormLoading>(),
          isA<ExpenseFormError>().having(
            (state) => state.message,
            'message',
            'auth.failed',
          ),
        ]),
      );

      bloc.add(
        ExpenseFormSubmitted(
          title: 'Dinner',
          amount: 50,
          category: 'Food',
          description: '',
          date: DateTime(2024, 1, 2),
        ),
      );

      await expectation;
    });
  });

  group('ExpenseBloc utilities', () {
    test('reset emits new form data state', () async {
      final expectation = expectLater(
        bloc.stream,
        emits(isA<ExpenseFormData>()),
      );

      bloc.add(const ExpenseFormReset());
      await expectation;
    });

    test('close emits initial state', () async {
      final expectation = expectLater(
        bloc.stream,
        emits(isA<ExpenseInitial>()),
      );

      bloc.add(const ExpenseFormClosed());
      await expectation;
    });
  });
}
