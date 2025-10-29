import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_core/flutter_core.dart';

import '../../../../core/workspace/workspace_context.dart';
import '../models/transaction_model.dart';

@lazySingleton
class TransactionsRemoteDataSource {
  TransactionsRemoteDataSource(this._firestore);

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> _collection(WorkspaceContext context) {
    if (context.isPersonal) {
      return _firestore
          .collection('users')
          .doc(context.userId)
          .collection('transactions');
    }
    return _firestore
        .collection('households')
        .doc(context.workspaceId)
        .collection('transactions');
  }

  String allocateId(WorkspaceContext context) {
    return _collection(context).doc().id;
  }

  Stream<List<TransactionModel>> watchTransactions(WorkspaceContext context) {
    return _collection(context)
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

  Future<List<TransactionModel>> fetchTransactionsOnce(
    WorkspaceContext context,
  ) async {
    final snapshot = await _collection(context)
        .orderBy('date', descending: true)
        .get();
    return snapshot.docs
        .map(TransactionModel.fromFirestore)
        .where((model) => !model.deleted)
        .toList(growable: false);
  }

  Future<void> upsert(WorkspaceContext context, TransactionModel model) {
    return _collection(context).doc(model.id).set(
          model.toFirestore(),
          SetOptions(merge: false),
        );
  }

  Future<void> update(WorkspaceContext context, TransactionModel model) {
    return _collection(context)
        .doc(model.id)
        .set(model.toFirestore(merge: true), SetOptions(merge: true));
  }

  Future<void> softDelete(WorkspaceContext context, String id) {
    return _collection(context).doc(id).set(
      <String, dynamic>{
        'deleted': true,
        'updatedAt': FieldValue.serverTimestamp(),
      },
      SetOptions(merge: true),
    );
  }
}
