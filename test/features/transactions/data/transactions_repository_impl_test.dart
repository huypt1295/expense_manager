import 'dart:async';

import 'package:expense_manager/core/enums/transaction_type.dart';
import 'package:expense_manager/core/auth/current_user.dart';
import 'package:expense_manager/features/transactions/data/datasources/transactions_remote_data_source.dart';
import 'package:expense_manager/features/transactions/data/models/transaction_model.dart';
import 'package:expense_manager/features/transactions/data/repositories/transactions_repository_impl.dart';
import 'package:expense_manager/features/transactions/domain/entities/transaction_entity.dart';
import 'package:flutter_core/flutter_core.dart' hide test;
import 'package:flutter_test/flutter_test.dart';

class _FakeCurrentUser implements CurrentUser {
  _FakeCurrentUser(this.snapshot);

  CurrentUserSnapshot? snapshot;

  @override
  CurrentUserSnapshot? now() => snapshot;

  @override
  Stream<CurrentUserSnapshot?> watch() => Stream.value(snapshot);
}

class _FakeTransactionsRemoteDataSource
    implements TransactionsRemoteDataSource {
  _FakeTransactionsRemoteDataSource();

  String? lastAllocateUid;
  String allocatedId = 'generated-id';

  String? lastUpsertUid;
  TransactionModel? lastUpsertModel;

  String? lastUpdateUid;
  TransactionModel? lastUpdateModel;

  String? lastDeleteUid;
  String? lastDeletedId;

  List<TransactionModel> onceModels = const <TransactionModel>[];

  final StreamController<List<TransactionModel>> controller =
      StreamController<List<TransactionModel>>.broadcast(sync: true);

  @override
  String allocateId(String uid) {
    lastAllocateUid = uid;
    return allocatedId;
  }

  @override
  Stream<List<TransactionModel>> watchTransactions(String uid) {
    return controller.stream;
  }

  @override
  Future<List<TransactionModel>> fetchTransactionsOnce(String uid) async {
    return onceModels;
  }

  @override
  Future<void> upsert(String uid, TransactionModel model) async {
    lastUpsertUid = uid;
    lastUpsertModel = model;
  }

  @override
  Future<void> update(String uid, TransactionModel model) async {
    lastUpdateUid = uid;
    lastUpdateModel = model;
  }

  @override
  Future<void> softDelete(String uid, String id) async {
    lastDeleteUid = uid;
    lastDeletedId = id;
  }

  void emit(List<TransactionModel> models) {
    controller.add(models);
  }

  Future<void> close() async {
    await controller.close();
  }
}

TransactionEntity _transaction(String id) => TransactionEntity(
      id: id,
      title: 'Tx $id',
      amount: 10,
      date: DateTime(2024, 1, 1),
      type: TransactionType.expense,
      category: 'Food',
    );

TransactionModel _model(String id) => TransactionModel(
      id: id,
      title: 'Tx $id',
      amount: 10,
      date: DateTime(2024, 1, 1),
      type: TransactionType.expense,
      category: 'Food',
      note: null,
    );

void main() {
  group('TransactionsRepositoryImpl', () {
    late _FakeCurrentUser currentUser;
    late _FakeTransactionsRemoteDataSource remote;
    late TransactionsRepositoryImpl repository;

    setUp(() {
      currentUser = _FakeCurrentUser(const CurrentUserSnapshot(uid: 'uid-123'));
      remote = _FakeTransactionsRemoteDataSource();
      repository = TransactionsRepositoryImpl(remote, currentUser);
    });

    tearDown(() async {
      await remote.close();
    });

    test('add allocates id when entity id is empty', () async {
      final entity = _transaction('').copyWith(id: '');

      await repository.add(entity);

      expect(remote.lastAllocateUid, 'uid-123');
      expect(remote.lastUpsertUid, 'uid-123');
      expect(remote.lastUpsertModel, isNotNull);
      expect(remote.lastUpsertModel!.id, remote.allocatedId);
    });

    test('update delegates to remote data source with same id', () async {
      final entity = _transaction('existing');

      await repository.update(entity);

      expect(remote.lastUpdateUid, 'uid-123');
      expect(remote.lastUpdateModel!.id, 'existing');
    });

    test('deleteById calls softDelete with user id', () async {
      await repository.deleteById('delete-me');

      expect(remote.lastDeleteUid, 'uid-123');
      expect(remote.lastDeletedId, 'delete-me');
    });

    test('watchAll maps models to entities', () async {
      final expectation = expectLater(
        repository.watchAll(),
        emits(
          predicate<List<TransactionEntity>>((items) =>
              items.length == 1 && items.first.id == 'a'),
        ),
      );

      remote.emit([
        _model('a'),
      ]);

      await expectation;
    });

    test('throws AuthException when user is missing', () async {
      currentUser.snapshot = const CurrentUserSnapshot(uid: null);

      expect(
        () => repository.deleteById('x'),
        throwsA(isA<AuthException>()),
      );
    });
  });
}
