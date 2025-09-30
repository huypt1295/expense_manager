import 'package:expense_manager/core/auth/current_user.dart';
import 'package:expense_manager/features/budget/data/datasources/budget_remote_data_source.dart';
import 'package:expense_manager/features/budget/data/models/budget_model.dart';
import 'package:expense_manager/features/budget/domain/entities/budget_entity.dart';
import 'package:expense_manager/features/budget/domain/repositories/budget_repository.dart';
import 'package:flutter_core/flutter_core.dart';

@LazySingleton(as: BudgetRepository)
class BudgetRepositoryImpl implements BudgetRepository {
  BudgetRepositoryImpl(
    this._remoteDataSource,
    this._currentUser,
  );

  final BudgetRemoteDataSource _remoteDataSource;
  final CurrentUser _currentUser;

  @override
  Stream<List<BudgetEntity>> watchAll() {
    final uid = _requireUid();
    return _remoteDataSource.watchBudgets(uid).map(
          (models) => models
              .map((model) => model.toEntity())
              .toList(growable: false),
        );
  }

  @override
  Future<void> add(BudgetEntity entity) {
    final uid = _requireUid();
    final id = entity.id.isEmpty
        ? _remoteDataSource.allocateId(uid)
        : entity.id;
    final model = BudgetModel.fromEntity(entity.copyWith(id: id));
    return _remoteDataSource.upsert(uid, model);
  }

  @override
  Future<void> update(BudgetEntity entity) {
    final uid = _requireUid();
    final model = BudgetModel.fromEntity(entity);
    return _remoteDataSource.update(uid, model);
  }

  @override
  Future<void> deleteById(String id) {
    final uid = _requireUid();
    return _remoteDataSource.delete(uid, id);
  }

  String _requireUid() {
    final snapshot = _currentUser.now();
    final uid = snapshot?.uid;
    if (uid == null || uid.isEmpty) {
      throw AuthException('auth.required', tokenExpired: true);
    }
    return uid;
  }

}
