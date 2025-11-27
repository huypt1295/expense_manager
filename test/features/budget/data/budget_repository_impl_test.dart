import 'dart:async';

import 'package:expense_manager/core/auth/current_user.dart';
import 'package:expense_manager/core/workspace/current_workspace.dart';
import 'package:expense_manager/core/workspace/workspace_context.dart';
import 'package:expense_manager/features/budget/data/datasources/budget_remote_data_source.dart';
import 'package:expense_manager/features/budget/data/models/budget_model.dart';
import 'package:expense_manager/features/budget/data/repositories/budget_repository_impl.dart';
import 'package:expense_manager/features/budget/domain/entities/budget_entity.dart';
import 'package:flutter_core/flutter_core.dart' hide test;
import 'package:flutter_test/flutter_test.dart';

class _FakeCurrentWorkspace implements CurrentWorkspace {
  _FakeCurrentWorkspace(this._snapshot);

  CurrentWorkspaceSnapshot? _snapshot;
  final StreamController<CurrentWorkspaceSnapshot?> _controller =
      StreamController<CurrentWorkspaceSnapshot?>.broadcast(sync: true);

  @override
  CurrentWorkspaceSnapshot? now() => _snapshot;

  @override
  Stream<CurrentWorkspaceSnapshot?> watch() => _controller.stream;

  @override
  Future<void> select(CurrentWorkspaceSnapshot? snapshot) async {
    _snapshot = snapshot;
    _controller.add(snapshot);
  }

  Future<void> close() async {
    await _controller.close();
  }
}

class _FakeCurrentUser implements CurrentUser {
  _FakeCurrentUser(this.snapshot);

  CurrentUserSnapshot? snapshot;

  @override
  CurrentUserSnapshot? now() => snapshot;

  @override
  Stream<CurrentUserSnapshot?> watch() => Stream.value(snapshot);
}

class _FakeBudgetRemoteDataSource implements BudgetRemoteDataSource {
  _FakeBudgetRemoteDataSource();

  WorkspaceContext? lastAllocateContext;
  String allocatedId = 'budget-id';

  WorkspaceContext? lastUpsertContext;
  BudgetModel? lastUpsertModel;

  WorkspaceContext? lastUpdateContext;
  BudgetModel? lastUpdateModel;

  WorkspaceContext? lastDeleteContext;
  String? lastDeletedId;

  final StreamController<List<BudgetModel>> controller =
      StreamController<List<BudgetModel>>.broadcast(sync: true);

  @override
  String allocateId(WorkspaceContext context) {
    lastAllocateContext = context;
    return allocatedId;
  }

  @override
  Stream<List<BudgetModel>> watchBudgets(WorkspaceContext context) =>
      controller.stream;

  @override
  Future<void> upsert(WorkspaceContext context, BudgetModel model) async {
    lastUpsertContext = context;
    lastUpsertModel = model;
  }

  @override
  Future<void> update(WorkspaceContext context, BudgetModel model) async {
    lastUpdateContext = context;
    lastUpdateModel = model;
  }

  @override
  Future<void> delete(WorkspaceContext context, String id) async {
    lastDeleteContext = context;
    lastDeletedId = id;
  }

  void emit(List<BudgetModel> models) {
    controller.add(models);
  }

  Future<void> close() async {
    await controller.close();
  }
}

BudgetEntity _budget(String id) => BudgetEntity(
  id: id,
  category: 'Food',
  limitAmount: 1000,
  startDate: DateTime(2024, 1, 1),
  endDate: DateTime(2024, 1, 31),
  categoryId: 'food',
);

BudgetModel _model(String id) => BudgetModel(
  id: id,
  category: 'Food',
  limitAmount: 1000,
  startDate: DateTime(2024, 1, 1),
  endDate: DateTime(2024, 1, 31),
  categoryId: 'food',
);

void main() {
  group('BudgetRepositoryImpl', () {
    late _FakeCurrentUser currentUser;
    late _FakeBudgetRemoteDataSource remote;
    late _FakeCurrentWorkspace currentWorkspace;
    late BudgetRepositoryImpl repository;

    setUp(() {
      currentUser = _FakeCurrentUser(const CurrentUserSnapshot(uid: 'uid'));
      remote = _FakeBudgetRemoteDataSource();
      currentWorkspace = _FakeCurrentWorkspace(
        const CurrentWorkspaceSnapshot.personal(id: 'uid'),
      );
      repository = BudgetRepositoryImpl(remote, currentUser, currentWorkspace);
    });

    tearDown(() async {
      await remote.close();
      await currentWorkspace.close();
    });

    test('add allocates id and upserts model', () async {
      await repository.add(_budget(''));

      expect(remote.lastAllocateContext?.workspaceId, 'uid');
      expect(remote.lastUpsertContext?.workspaceId, 'uid');
      expect(remote.lastUpsertModel?.id, remote.allocatedId);
    });

    test('update delegates to remote data source', () async {
      await repository.update(_budget('existing'));

      expect(remote.lastUpdateContext?.workspaceId, 'uid');
      expect(remote.lastUpdateModel?.id, 'existing');
    });

    test('deleteById delegates to remote data source', () async {
      await repository.deleteById('delete-me');

      expect(remote.lastDeleteContext?.workspaceId, 'uid');
      expect(remote.lastDeletedId, 'delete-me');
    });

    test('watchAll maps models to entities', () async {
      final expectation = expectLater(
        repository.watchAll(),
        emits(
          predicate<List<BudgetEntity>>(
            (items) => items.length == 1 && items.first.id == 'budget-1',
          ),
        ),
      );

      remote.emit([_model('budget-1')]);

      await expectation;
    });

    test('throws AuthException when user missing', () {
      currentUser.snapshot = const CurrentUserSnapshot(uid: null);

      expect(() => repository.deleteById('x'), throwsA(isA<AuthException>()));
    });

    test('throws AuthException when workspace role is viewer', () async {
      await currentWorkspace.select(
        const CurrentWorkspaceSnapshot(
          id: 'household-id',
          type: WorkspaceType.workspace,
          name: 'Household',
          role: 'viewer',
        ),
      );

      expect(
        () => repository.add(_budget('')),
        throwsA(
          isA<AuthException>().having(
            (error) => error.message,
            'message',
            'workspace.permission.denied',
          ),
        ),
      );
    });
  });
}
