import 'dart:async';

import 'package:expense_manager/core/auth/current_user.dart';
import 'package:expense_manager/features/budget/data/datasources/budget_remote_data_source.dart';
import 'package:expense_manager/features/budget/data/models/budget_model.dart';
import 'package:expense_manager/features/budget/data/repositories/budget_repository_impl.dart';
import 'package:expense_manager/features/budget/domain/entities/budget_entity.dart';
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

class _FakeBudgetRemoteDataSource implements BudgetRemoteDataSource {
  _FakeBudgetRemoteDataSource();

  String? lastAllocateUid;
  String allocatedId = 'budget-id';

  String? lastUpsertUid;
  BudgetModel? lastUpsertModel;

  String? lastUpdateUid;
  BudgetModel? lastUpdateModel;

  String? lastDeleteUid;
  String? lastDeletedId;

  List<BudgetModel> onceModels = const <BudgetModel>[];

  final StreamController<List<BudgetModel>> controller =
      StreamController<List<BudgetModel>>.broadcast(sync: true);

  @override
  String allocateId(String uid) {
    lastAllocateUid = uid;
    return allocatedId;
  }

  @override
  Stream<List<BudgetModel>> watchBudgets(String uid) => controller.stream;

  @override
  Future<void> upsert(String uid, BudgetModel model) async {
    lastUpsertUid = uid;
    lastUpsertModel = model;
  }

  @override
  Future<void> update(String uid, BudgetModel model) async {
    lastUpdateUid = uid;
    lastUpdateModel = model;
  }

  @override
  Future<void> delete(String uid, String id) async {
    lastDeleteUid = uid;
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
    late BudgetRepositoryImpl repository;

    setUp(() {
      currentUser = _FakeCurrentUser(const CurrentUserSnapshot(uid: 'uid'));
      remote = _FakeBudgetRemoteDataSource();
      repository = BudgetRepositoryImpl(remote, currentUser);
    });

    tearDown(() async {
      await remote.close();
    });

    test('add allocates id and upserts model', () async {
      await repository.add(_budget(''));

      expect(remote.lastAllocateUid, 'uid');
      expect(remote.lastUpsertUid, 'uid');
      expect(remote.lastUpsertModel?.id, remote.allocatedId);
    });

    test('update delegates to remote data source', () async {
      await repository.update(_budget('existing'));

      expect(remote.lastUpdateUid, 'uid');
      expect(remote.lastUpdateModel?.id, 'existing');
    });

    test('deleteById delegates to remote data source', () async {
      await repository.deleteById('delete-me');

      expect(remote.lastDeleteUid, 'uid');
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

      remote.emit([
        _model('budget-1'),
      ]);

      await expectation;
    });

    test('throws AuthException when user missing', () {
      currentUser.snapshot = const CurrentUserSnapshot(uid: null);

      expect(() => repository.deleteById('x'), throwsA(isA<AuthException>()));
    });
  });
}
