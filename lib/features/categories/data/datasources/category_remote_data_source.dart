import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_manager/core/workspace/workspace_context.dart';
import 'package:expense_manager/features/categories/data/models/category_model.dart';
import 'package:flutter_core/flutter_core.dart';

@lazySingleton
class CategoryRemoteDataSource {
  CategoryRemoteDataSource(this._firestore);

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _defaultCollection {
    return _firestore.collection('globalCategories');
  }

  CollectionReference<Map<String, dynamic>> _userCollection(String uid) {
    return _firestore.collection('users').doc(uid).collection('categories');
  }

  CollectionReference<Map<String, dynamic>> _workspaceCollection(
    WorkspaceContext context,
  ) {
    if (context.isPersonal) {
      return _firestore
          .collection('workspaces')
          .doc(context.workspaceId)
          .collection('customCategories');
    }
    return _firestore
        .collection('workspaces')
        .doc(context.workspaceId)
        .collection('customCategories');
  }

  Stream<List<CategoryModel>> watchDefault() {
    return _defaultCollection.snapshots().map(
      (snapshot) => snapshot.docs
          .map(CategoryModel.fromDefaultDoc)
          .toList(growable: false),
    );
  }

  Stream<List<CategoryModel>> watchForUser(String uid) {
    return _userCollection(uid).snapshots().map(
      (snapshot) =>
          snapshot.docs.map(CategoryModel.fromUserDoc).toList(growable: false),
    );
  }

  Future<List<CategoryModel>> fetchDefault() async {
    final snapshot = await _defaultCollection.get();
    return snapshot.docs
        .map(CategoryModel.fromDefaultDoc)
        .toList(growable: false);
  }

  Future<List<CategoryModel>> fetchForUser(String uid) async {
    final snapshot = await _userCollection(uid).get();
    return snapshot.docs.map(CategoryModel.fromUserDoc).toList(growable: false);
  }

  Future<CategoryModel> createForUser(String uid, CategoryModel model) async {
    final collection = _userCollection(uid);
    final docRef = model.id.isEmpty
        ? collection.doc()
        : collection.doc(model.id);
    final payload = model.toFirestoreBase()
      ..['ownerId'] = uid
      ..['createdAt'] = FieldValue.serverTimestamp()
      ..['updatedAt'] = FieldValue.serverTimestamp();
    await docRef.set(payload);
    final snapshot = await docRef.get();
    return CategoryModel.fromUserDoc(snapshot);
  }

  Future<void> updateForUser(String uid, CategoryModel model) {
    final docRef = _userCollection(uid).doc(model.id);
    final payload = model.toFirestoreBase()
      ..['ownerId'] = uid
      ..['updatedAt'] = FieldValue.serverTimestamp();
    return docRef.update(payload);
  }

  Future<void> deleteForUser(String uid, String categoryId) {
    return _userCollection(uid).doc(categoryId).delete();
  }

  // ========== Workspace-aware methods ==========

  Stream<List<CategoryModel>> watchForWorkspace(WorkspaceContext context) {
    return _workspaceCollection(context).snapshots().map(
      (snapshot) =>
          snapshot.docs.map(CategoryModel.fromUserDoc).toList(growable: false),
    );
  }

  Future<List<CategoryModel>> fetchForWorkspace(WorkspaceContext context) async {
    final snapshot = await _workspaceCollection(context).get();
    return snapshot.docs.map(CategoryModel.fromUserDoc).toList(growable: false);
  }

  Future<CategoryModel> createForWorkspace(
    WorkspaceContext context,
    CategoryModel model,
  ) async {
    final collection = _workspaceCollection(context);
    final docRef = model.id.isEmpty ? collection.doc() : collection.doc(model.id);
    final payload = model.toFirestoreBase()
      ..['ownerId'] = context.userId
      ..['createdBy'] = context.userId
      ..['createdAt'] = FieldValue.serverTimestamp()
      ..['updatedAt'] = FieldValue.serverTimestamp();
    await docRef.set(payload);
    final snapshot = await docRef.get();
    return CategoryModel.fromUserDoc(snapshot);
  }

  Future<void> updateForWorkspace(
    WorkspaceContext context,
    CategoryModel model,
  ) {
    final docRef = _workspaceCollection(context).doc(model.id);
    final payload = model.toFirestoreBase()
      ..['updatedAt'] = FieldValue.serverTimestamp();
    return docRef.update(payload);
  }

  Future<void> deleteForWorkspace(WorkspaceContext context, String categoryId) {
    return _workspaceCollection(context).doc(categoryId).delete();
  }
}
