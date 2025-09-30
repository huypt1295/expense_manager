import 'dart:async';

import 'package:expense_manager/core/auth/current_user.dart';
import 'package:expense_manager/features/transactions/data/datasources/transactions_remote_data_source.dart';
import 'package:expense_manager/features/transactions/data/models/transaction_model.dart';
import 'package:expense_manager/features/transactions/domain/entities/transaction_entity.dart';
import 'package:expense_manager/features/transactions/domain/repositories/transactions_repository.dart';
import 'package:flutter_core/flutter_core.dart';

@LazySingleton(as: TransactionsRepository)
class TransactionsRepositoryImpl implements TransactionsRepository {
  TransactionsRepositoryImpl(
    this._remoteDataSource,
    this._currentUser,
  );

  final TransactionsRemoteDataSource _remoteDataSource;
  final CurrentUser _currentUser;

  @override
  Stream<List<TransactionEntity>> watchAll() {
    final uid = _requireUid();
    return _remoteDataSource.watchTransactions(uid).map(_mapModels);
  }

  @override
  Future<List<TransactionEntity>> getAllOnce() async {
    final uid = _requireUid();
    final models = await _remoteDataSource.fetchTransactionsOnce(uid);
    return _mapModels(models);
  }

  @override
  Future<void> add(TransactionEntity entity) {
    final uid = _requireUid();
    final id = entity.id.isEmpty
        ? _remoteDataSource.allocateId(uid)
        : entity.id;
    final model = TransactionModel.fromEntity(
      entity.copyWith(id: id),
    );
    return _remoteDataSource.upsert(uid, model);
  }

  @override
  Future<void> update(TransactionEntity entity) {
    final uid = _requireUid();
    final model = TransactionModel.fromEntity(entity);
    return _remoteDataSource.update(uid, model);
  }

  @override
  Future<void> deleteById(String id) {
    final uid = _requireUid();
    return _remoteDataSource.softDelete(uid, id);
  }

  List<TransactionEntity> _mapModels(List<TransactionModel> models) {
    return models.map((model) => model.toEntity()).toList(growable: false);
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
