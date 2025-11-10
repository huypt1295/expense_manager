import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_manager/core/workspace/workspace_context.dart';
import 'package:flutter_core/flutter_core.dart';

import '../models/budget_model.dart';

@lazySingleton
class BudgetRemoteDataSource {
  BudgetRemoteDataSource(this._firestore);

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> _collection(
    WorkspaceContext context,
  ) {
    if (context.isPersonal) {
      return _firestore
          .collection('users')
          .doc(context.userId)
          .collection('budgets');
    }
    return _firestore
        .collection('households')
        .doc(context.workspaceId)
        .collection('budgets');
  }

  String allocateId(WorkspaceContext context) {
    return _collection(context).doc().id;
  }

  Stream<List<BudgetModel>> watchBudgets(WorkspaceContext context) {
    return _collection(context)
        .orderBy('startDate', descending: false)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map(BudgetModel.fromFirestore)
              .toList(growable: false),
        );
  }

  Future<void> upsert(WorkspaceContext context, BudgetModel model) {
    return _collection(context).doc(model.id).set(
          model.toFirestore(),
          SetOptions(merge: false),
        );
  }

  Future<void> update(WorkspaceContext context, BudgetModel model) {
    return _collection(context)
        .doc(model.id)
        .set(model.toFirestore(merge: true), SetOptions(merge: true));
  }

  Future<void> delete(WorkspaceContext context, String id) {
    return _collection(context).doc(id).delete();
  }
}
