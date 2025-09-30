import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_core/flutter_core.dart';

import '../models/transaction_model.dart';

@lazySingleton
class TransactionsRemoteDataSource {
  TransactionsRemoteDataSource(this._firestore);

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> _collection(String uid) {
    return _firestore.collection('users').doc(uid).collection('transactions');
  }

  String allocateId(String uid) {
    return _collection(uid).doc().id;
  }

  Stream<List<TransactionModel>> watchTransactions(String uid) {
    return _collection(uid)
        .orderBy('date', descending: true)
        .snapshots()
        .map(
      (snapshot) {
        return snapshot.docs
            .map(TransactionModel.fromFirestore)
            .where((model) => !model.deleted)
            .toList(growable: false);
      },
    );
  }

  Future<List<TransactionModel>> fetchTransactionsOnce(String uid) async {
    final snapshot = await _collection(uid)
        .orderBy('date', descending: true)
        .get();
    return snapshot.docs
        .map(TransactionModel.fromFirestore)
        .where((model) => !model.deleted)
        .toList(growable: false);
  }

  Future<void> upsert(String uid, TransactionModel model) {
    return _collection(uid).doc(model.id).set(
          model.toFirestore(),
          SetOptions(merge: false),
        );
  }

  Future<void> update(String uid, TransactionModel model) {
    return _collection(uid)
        .doc(model.id)
        .set(model.toFirestore(merge: true), SetOptions(merge: true));
  }

  Future<void> softDelete(String uid, String id) {
    return _collection(uid).doc(id).set(
      <String, dynamic>{
        'deleted': true,
        'updatedAt': FieldValue.serverTimestamp(),
      },
      SetOptions(merge: true),
    );
  }
}
