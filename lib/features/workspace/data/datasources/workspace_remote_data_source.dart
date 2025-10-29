import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_core/flutter_core.dart';

import '../models/workspace_model.dart';

@lazySingleton
class WorkspaceRemoteDataSource {
  WorkspaceRemoteDataSource(this._firestore);

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> _memberships(String uid) {
    return _firestore.collection('users').doc(uid).collection('workspaces');
  }

  Stream<List<WorkspaceModel>> watchMemberships(String uid) {
    return _memberships(uid).snapshots().map(
      (snapshot) {
        return snapshot.docs
            .map(WorkspaceModel.fromFirestore)
            .toList(growable: false);
      },
    );
  }

  Future<void> upsertMembership(String uid, WorkspaceModel model) {
    return _memberships(uid).doc(model.id).set(
          model.toFirestore(),
          SetOptions(merge: true),
        );
  }
}
