import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_core/flutter_core.dart';

import '../models/budget_model.dart';

@lazySingleton
class BudgetRemoteDataSource {
  BudgetRemoteDataSource(this._firestore);

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> _collection(String uid) {
    return _firestore.collection('users').doc(uid).collection('budgets');
  }

  String allocateId(String uid) {
    return _collection(uid).doc().id;
  }

  Stream<List<BudgetModel>> watchBudgets(String uid) {
    return _collection(uid)
        .orderBy('startDate', descending: false)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map(BudgetModel.fromFirestore)
            .toList(growable: false));
  }

  Future<void> upsert(String uid, BudgetModel model) {
    return _collection(uid).doc(model.id).set(
          model.toFirestore(),
          SetOptions(merge: false),
        );
  }

  Future<void> update(String uid, BudgetModel model) {
    return _collection(uid)
        .doc(model.id)
        .set(model.toFirestore(merge: true), SetOptions(merge: true));
  }

  Future<void> delete(String uid, String id) {
    return _collection(uid).doc(id).delete();
  }
}
