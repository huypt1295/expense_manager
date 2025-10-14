import 'dart:async';

import 'package:expense_manager/core/enums/transaction_type.dart';
import 'package:expense_manager/features/transactions/domain/entities/transaction_entity.dart';
import 'package:expense_manager/features/transactions/domain/repositories/transactions_repository.dart';
import 'package:expense_manager/features/transactions/domain/usecases/add_transaction_usecase.dart';
import 'package:expense_manager/features/transactions/domain/usecases/delete_transaction_usecase.dart';
import 'package:expense_manager/features/transactions/domain/usecases/update_transaction_usecase.dart';
import 'package:expense_manager/features/transactions/domain/usecases/watch_transactions_usecase.dart';
import 'package:flutter_core/flutter_core.dart' hide test;
import 'package:flutter_test/flutter_test.dart';

class _FakeTransactionsRepository implements TransactionsRepository {
  final _controller = StreamController<List<TransactionEntity>>.broadcast();

  TransactionEntity? added;
  TransactionEntity? updated;
  String? deletedId;
  Object? error;

  @override
  Stream<List<TransactionEntity>> watchAll() => _controller.stream;

  void emit(List<TransactionEntity> items) => _controller.add(items);

  Future<void> close() => _controller.close();

  @override
  Future<List<TransactionEntity>> getAllOnce() async => const [];

  @override
  Future<void> add(TransactionEntity entity) async {
    if (error != null) throw error!;
    added = entity;
  }

  @override
  Future<void> update(TransactionEntity entity) async {
    if (error != null) throw error!;
    updated = entity;
  }

  @override
  Future<void> deleteById(String id) async {
    if (error != null) throw error!;
    deletedId = id;
  }
}

TransactionEntity _transaction(String id) => TransactionEntity(
      id: id,
      title: 'Tx',
      amount: 10,
      date: DateTime(2024, 1, 1),
      type: TransactionType.expense,
      category: 'Food',
    );

void main() {
  group('Transaction usecases', () {
    late _FakeTransactionsRepository repository;

    setUp(() {
      repository = _FakeTransactionsRepository();
    });

    tearDown(() async {
      await repository.close();
    });

    test('AddTransactionUseCase returns success when repository succeeds', () async {
      final usecase = AddTransactionUseCase(repository);

      final result = await usecase(AddTransactionParams(_transaction('add')));

      expect(result.isSuccess, isTrue);
      expect(repository.added?.id, 'add');
    });

    test('AddTransactionUseCase maps errors', () async {
      repository.error = AuthException('auth');
      final usecase = AddTransactionUseCase(repository);

      final result = await usecase(AddTransactionParams(_transaction('add')));

      expect(result.isFailure, isTrue);
      expect(result.failureOrNull, isA<AuthFailure>());
    });

    test('UpdateTransactionUseCase delegates to repository', () async {
      final usecase = UpdateTransactionUseCase(repository);

      final result = await usecase(UpdateTransactionParams(_transaction('update')));

      expect(result.isSuccess, isTrue);
      expect(repository.updated?.id, 'update');
    });

    test('DeleteTransactionUseCase delegates to repository', () async {
      final usecase = DeleteTransactionUseCase(repository);

      final result = await usecase(DeleteTransactionParams('delete'));

      expect(result.isSuccess, isTrue);
      expect(repository.deletedId, 'delete');
    });

    test('WatchTransactionsUseCase proxies repository stream', () async {
      final usecase = WatchTransactionsUseCase(repository);

      final future = usecase(NoParam()).first;
      repository.emit([_transaction('stream')]);

      final items = await future;
      expect(items.first.id, 'stream');
    });
  });
}
