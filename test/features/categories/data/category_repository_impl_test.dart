import 'dart:async';

import 'package:expense_manager/core/auth/current_user.dart';
import 'package:expense_manager/core/enums/transaction_type.dart';
import 'package:expense_manager/features/categories/data/datasources/category_remote_data_source.dart';
import 'package:expense_manager/features/categories/data/models/category_model.dart';
import 'package:expense_manager/features/categories/data/repositories/category_repository_impl.dart';
import 'package:expense_manager/features/categories/domain/entities/category_entity.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeCurrentUser implements CurrentUser {
  _FakeCurrentUser({String? uid}) : snapshot = CurrentUserSnapshot(uid: uid);

  CurrentUserSnapshot? snapshot;

  @override
  CurrentUserSnapshot? now() => snapshot;

  @override
  Stream<CurrentUserSnapshot?> watch() =>
      Stream<CurrentUserSnapshot?>.value(snapshot);
}

class _FakeCategoryRemoteDataSource implements CategoryRemoteDataSource {
  final StreamController<List<CategoryModel>> _defaultController =
      StreamController<List<CategoryModel>>.broadcast(sync: true);
  final StreamController<List<CategoryModel>> _userController =
      StreamController<List<CategoryModel>>.broadcast(sync: true);

  List<CategoryModel> defaultFetchModels = const <CategoryModel>[];
  List<CategoryModel> userFetchModels = const <CategoryModel>[];

  String? createdUid;
  CategoryModel? createdModel;
  String? updatedUid;
  CategoryModel? updatedModel;
  String? deletedUid;
  String? deletedCategoryId;

  @override
  Stream<List<CategoryModel>> watchDefault() => _defaultController.stream;

  @override
  Stream<List<CategoryModel>> watchForUser(String uid) =>
      _userController.stream;

  @override
  Future<List<CategoryModel>> fetchDefault() async => defaultFetchModels;

  @override
  Future<List<CategoryModel>> fetchForUser(String uid) async => userFetchModels;

  @override
  Future<CategoryModel> createForUser(String uid, CategoryModel model) async {
    createdUid = uid;
    createdModel = model;
    final next = CategoryModel(
      id: model.id.isEmpty
          ? 'generated-${userFetchModels.length + 1}'
          : model.id,
      icon: model.icon,
      isActive: model.isActive,
      type: model.type,
      name: model.name,
      sortOrder: model.sortOrder,
      isUserDefined: true,
      ownerId: uid,
      createdAt: DateTime.utc(2024, 1, 1),
      updatedAt: DateTime.utc(2024, 1, 1),
      isArchived: model.isArchived,
    );
    userFetchModels = <CategoryModel>[...userFetchModels, next];
    return next;
  }

  @override
  Future<void> updateForUser(String uid, CategoryModel model) async {
    updatedUid = uid;
    updatedModel = model;
  }

  @override
  Future<void> deleteForUser(String uid, String categoryId) async {
    deletedUid = uid;
    deletedCategoryId = categoryId;
  }

  void emitDefault(List<CategoryModel> models) {
    _defaultController.add(models);
  }

  void emitUser(List<CategoryModel> models) {
    _userController.add(models);
  }

  Future<void> dispose() async {
    await _defaultController.close();
    await _userController.close();
  }
}

CategoryModel _defaultModel(String id, {bool isActive = true, int? sortOrder}) {
  return CategoryModel(
    id: id,
    icon: 'icon-$id',
    isActive: isActive,
    type: TransactionType.expense,
    name: {'en': 'Default $id'},
    isUserDefined: false,
    sortOrder: sortOrder,
  );
}

CategoryModel _userModel(
  String id, {
  bool isActive = true,
  DateTime? createdAt,
  bool isArchived = false,
}) {
  return CategoryModel(
    id: id,
    icon: 'icon-$id',
    isActive: isActive,
    type: TransactionType.expense,
    name: {'en': 'User $id'},
    isUserDefined: true,
    createdAt: createdAt,
    updatedAt: createdAt,
    isArchived: isArchived,
  );
}

void main() {
  group('CategoryRepositoryImpl', () {
    late _FakeCategoryRemoteDataSource remote;
    late _FakeCurrentUser currentUser;
    late CategoryRepositoryImpl repository;

    setUp(() {
      remote = _FakeCategoryRemoteDataSource();
      currentUser = _FakeCurrentUser(uid: 'u-1');
      repository = CategoryRepositoryImpl(remote, currentUser);
    });

    tearDown(() async {
      await remote.dispose();
    });

    test(
      'fetchCombined merges default and user categories with sorting',
      () async {
        remote.defaultFetchModels = <CategoryModel>[
          _defaultModel('c'),
          _defaultModel('b', sortOrder: 2),
          _defaultModel('a', sortOrder: 1),
          _defaultModel('inactive', isActive: false),
        ];
        remote.userFetchModels = <CategoryModel>[
          _userModel('user-2', createdAt: DateTime.utc(2024, 1, 10)),
          _userModel('user-1', createdAt: DateTime.utc(2024, 1, 5)),
          _userModel('archived', isArchived: true),
        ];

        final result = await repository.fetchCombined();

        expect(result.map((e) => e.id).toList(), <String>[
          'a',
          'b',
          'c',
          'user-1',
          'user-2',
        ]);
        expect(result.every((entity) => entity.isArchived == false), isTrue);
        expect(
          result.every(
            (entity) => entity.isCustom == (entity.id.startsWith('user')),
          ),
          isTrue,
        );
      },
    );

    test('watchCombined emits merged lists', () async {
      final expectation = expectLater(
        repository.watchCombined(),
        emitsInOrder(<Matcher>[
          predicate<List<CategoryEntity>>((items) {
            return items.map((e) => e.id).toList().join(',') == 'd1,user-1';
          }),
          predicate<List<CategoryEntity>>((items) {
            return items.map((e) => e.id).toList().join(',') == 'd1,d2,user-1';
          }),
          predicate<List<CategoryEntity>>((items) {
            return items.map((e) => e.id).toList().join(',') ==
                'd1,d2,user-1,user-2';
          }),
        ]),
      );

      remote.emitDefault(<CategoryModel>[_defaultModel('d1', sortOrder: 1)]);
      remote.emitUser(<CategoryModel>[
        _userModel('user-1', createdAt: DateTime.utc(2024, 1, 1)),
      ]);

      remote.emitDefault(<CategoryModel>[
        _defaultModel('d1', sortOrder: 1),
        _defaultModel('d2', sortOrder: 2),
      ]);
      remote.emitUser(<CategoryModel>[
        _userModel('user-1', createdAt: DateTime.utc(2024, 1, 1)),
        _userModel('user-2', createdAt: DateTime.utc(2024, 1, 2)),
      ]);

      await expectation;
    });

    test('createUserCategory forwards to remote with user id', () async {
      final entity = CategoryEntity(
        id: '',
        icon: 'icon',
        isActive: true,
        type: TransactionType.expense,
        names: const {'en': 'Coffee'},
        isCustom: true,
      );

      final created = await repository.createUserCategory(entity);

      expect(created.id, isNotEmpty);
      expect(created.ownerId, 'u-1');
      expect(remote.createdUid, 'u-1');
      expect(remote.createdModel, isNotNull);
    });

    test('createUserCategory throws when entity is not custom', () async {
      final entity = CategoryEntity(
        id: '',
        icon: 'icon',
        isActive: true,
        type: TransactionType.expense,
        names: const {'en': 'System'},
        isCustom: false,
      );

      expect(() => repository.createUserCategory(entity), throwsArgumentError);
    });
  });
}
