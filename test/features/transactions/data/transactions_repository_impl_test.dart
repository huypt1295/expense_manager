import 'dart:async';

import 'package:expense_manager/core/enums/transaction_type.dart';
import 'package:expense_manager/core/auth/current_user.dart';
import 'package:expense_manager/core/workspace/current_workspace.dart';
import 'package:expense_manager/core/workspace/workspace_context.dart';
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

  WorkspaceContext? lastAllocateContext;
  String allocatedId = 'generated-id';

  WorkspaceContext? lastUpsertContext;
  TransactionModel? lastUpsertModel;

  WorkspaceContext? lastUpdateContext;
  TransactionModel? lastUpdateModel;

  WorkspaceContext? lastDeleteContext;
  String? lastDeletedId;

  List<TransactionModel> onceModels = const <TransactionModel>[];

  final StreamController<List<TransactionModel>> controller =
      StreamController<List<TransactionModel>>.broadcast(sync: true);

  @override
  String allocateId(WorkspaceContext context) {
    lastAllocateContext = context;
    return allocatedId;
  }

  @override
  Stream<List<TransactionModel>> watchTransactions(WorkspaceContext context) {
    return controller.stream;
  }

  @override
  Future<List<TransactionModel>> fetchTransactionsOnce(
    WorkspaceContext context,
  ) async {
    return onceModels;
  }

  @override
  Future<void> upsert(WorkspaceContext context, TransactionModel model) async {
    lastUpsertContext = context;
    lastUpsertModel = model;
  }

  @override
  Future<void> update(WorkspaceContext context, TransactionModel model) async {
    lastUpdateContext = context;
    lastUpdateModel = model;
  }

  @override
  Future<void> softDelete(WorkspaceContext context, String id) async {
    lastDeleteContext = context;
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

class _FakeCurrentWorkspace implements CurrentWorkspace {
  _FakeCurrentWorkspace(this.snapshot);

  CurrentWorkspaceSnapshot? snapshot;

  @override
  CurrentWorkspaceSnapshot? now() => snapshot;

  @override
  Future<void> select(CurrentWorkspaceSnapshot? snapshot) async {
    this.snapshot = snapshot;
  }

  @override
  Stream<CurrentWorkspaceSnapshot?> watch() => Stream.value(snapshot);
}

void main() {
  group('TransactionsRepositoryImpl', () {
    late _FakeCurrentUser currentUser;
    late _FakeTransactionsRemoteDataSource remote;
    late _FakeCurrentWorkspace currentWorkspace;
    late TransactionsRepositoryImpl repository;

    setUp(() {
      currentUser = _FakeCurrentUser(const CurrentUserSnapshot(uid: 'uid-123'));
      remote = _FakeTransactionsRemoteDataSource();
      currentWorkspace =
          _FakeCurrentWorkspace(CurrentWorkspaceSnapshot.personal(id: 'uid-123'));
      repository =
          TransactionsRepositoryImpl(remote, currentUser, currentWorkspace);
    });

    tearDown(() async {
      await remote.close();
    });

    test('add allocates id when entity id is empty', () async {
      final entity = _transaction('').copyWith(id: '');

      await repository.add(entity);

      expect(remote.lastAllocateContext, isNotNull);
      expect(remote.lastAllocateContext!.workspaceId, 'uid-123');
      expect(remote.lastUpsertContext, isNotNull);
      expect(remote.lastUpsertContext!.workspaceId, 'uid-123');
      expect(remote.lastUpsertModel, isNotNull);
      expect(remote.lastUpsertModel!.id, remote.allocatedId);
    });

    test('update delegates to remote data source with same id', () async {
      final entity = _transaction('existing');

      await repository.update(entity);

      expect(remote.lastUpdateContext, isNotNull);
      expect(remote.lastUpdateContext!.workspaceId, 'uid-123');
      expect(remote.lastUpdateModel!.id, 'existing');
    });

    test('deleteById calls softDelete with user id', () async {
      await repository.deleteById('delete-me');

      expect(remote.lastDeleteContext, isNotNull);
      expect(remote.lastDeleteContext!.workspaceId, 'uid-123');
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

    test('shareToWorkspace copies transaction with metadata', () async {
      final entity = _transaction('origin');

      await repository.shareToWorkspace(
        entity: entity,
        workspaceId: 'household-1',
      );

      expect(remote.lastAllocateContext, isNotNull);
      expect(remote.lastAllocateContext!.workspaceId, 'household-1');
      expect(remote.lastAllocateContext!.type, WorkspaceType.household);

      expect(remote.lastUpsertContext, isNotNull);
      expect(remote.lastUpsertContext!.workspaceId, 'household-1');
      final model = remote.lastUpsertModel;
      expect(model, isNotNull);
      expect(model!.id, remote.allocatedId);
      expect(model.sharedFromWorkspaceId, 'uid-123');
      expect(model.sharedFromTransactionId, 'origin');
      expect(model.sharedByUserId, 'uid-123');
    });

    test('throws AuthException when user is missing', () async {
      currentUser.snapshot = const CurrentUserSnapshot(uid: null);
      currentWorkspace.snapshot = null;

      expect(
        () => repository.deleteById('x'),
        throwsA(isA<AuthException>()),
      );
    });

    test('uses workspace snapshot when provided', () async {
      currentWorkspace.snapshot = const CurrentWorkspaceSnapshot(
        id: 'household-1',
        type: WorkspaceType.household,
        name: 'Family',
        role: 'owner',
      );

      await repository.deleteById('delete-me');

      expect(remote.lastDeleteContext, isNotNull);
      expect(remote.lastDeleteContext!.workspaceId, 'household-1');
      expect(remote.lastDeleteContext!.type, WorkspaceType.household);
    });
  });
}
