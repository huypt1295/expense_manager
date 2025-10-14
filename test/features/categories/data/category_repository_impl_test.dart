import 'dart:async';

import 'package:expense_manager/features/categories/data/datasources/category_remote_data_source.dart';
import 'package:expense_manager/features/categories/data/models/category_model.dart';
import 'package:expense_manager/features/categories/data/repositories/category_repository_impl.dart';
import 'package:expense_manager/features/categories/domain/entities/category_entity.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeCategoryRemoteDataSource implements CategoryRemoteDataSource {
  _FakeCategoryRemoteDataSource();

  List<CategoryModel> models = const <CategoryModel>[];
  StreamController<List<CategoryModel>>? controller;

  @override
  Stream<List<CategoryModel>> watchAll() {
    controller ??= StreamController<List<CategoryModel>>.broadcast(sync: true);
    return controller!.stream;
  }

  @override
  Future<List<CategoryModel>> fetchAll() async => models;

  void emit(List<CategoryModel> next) {
    controller ??=
        StreamController<List<CategoryModel>>.broadcast(sync: true);
    controller!.add(next);
  }

  Future<void> close() async {
    await controller?.close();
  }
}

CategoryModel _model(
  String id, {
  bool isActive = true,
  int? sortOrder,
}) {
  return CategoryModel(
    id: id,
    icon: 'icon-$id',
    isActive: isActive,
    name: {'en': 'Category $id'},
    sortOrder: sortOrder,
  );
}

void main() {
  group('CategoryRepositoryImpl', () {
    late _FakeCategoryRemoteDataSource remote;
    late CategoryRepositoryImpl repository;

    setUp(() {
      remote = _FakeCategoryRemoteDataSource();
      repository = CategoryRepositoryImpl(remote);
    });

    tearDown(() async {
      await remote.close();
    });

    test('filters inactive categories and sorts by order/id', () async {
      remote.models = <CategoryModel>[
        _model('c', sortOrder: null),
        _model('b', sortOrder: 2),
        _model('a', sortOrder: 1),
        _model('inactive', isActive: false),
        _model('d', sortOrder: null),
      ];

      final result = await repository.fetchAll();

      expect(result.map((e) => e.id).toList(), ['a', 'b', 'c', 'd']);
      expect(result, everyElement(isA<CategoryEntity>()));
      expect(
        result.any((entity) => entity.id == 'inactive'),
        isFalse,
      );
    });

    test('watchAll maps models to entities', () async {
      final expectStream = expectLater(
        repository.watchAll(),
        emits(
          orderedEquals(<CategoryEntity>[
            _model('x').toEntity(),
            _model('y').toEntity(),
          ]),
        ),
      );

      remote.emit(<CategoryModel>[
        _model('x'),
        _model('y'),
      ]);

      await expectStream;
    });
  });
}
