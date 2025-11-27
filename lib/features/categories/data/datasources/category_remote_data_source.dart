import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_manager/core/workspace/workspace_context.dart';
import 'package:expense_manager/features/categories/data/models/category_model.dart';
import 'package:flutter_core/flutter_core.dart';

@lazySingleton
class CategoryRemoteDataSource {
  CategoryRemoteDataSource(this._firestore);

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _defaultCollection {
    return _firestore.collection('categories');
  }

  CollectionReference<Map<String, dynamic>> _workspaceCollection(
    WorkspaceContext context,
  ) {
    return _firestore
        .collection('workspaces')
        .doc(context.workspaceId)
        .collection('customCategories');
  }

  // ========== Global/Default Categories ==========

  Stream<List<CategoryModel>> watchDefault() {
    return _defaultCollection.snapshots().map(
      (snapshot) => snapshot.docs
          .map(CategoryModel.fromDefaultDoc)
          .toList(growable: false),
    );
  }

  Future<List<CategoryModel>> fetchDefault() async {
    final snapshot = await _defaultCollection.get();
    return snapshot.docs
        .map(CategoryModel.fromDefaultDoc)
        .toList(growable: false);
  }

  // ========== Workspace Categories ==========

  Stream<List<CategoryModel>> watchForWorkspace(WorkspaceContext context) {
    return _workspaceCollection(context).snapshots().map(
      (snapshot) =>
          snapshot.docs.map(CategoryModel.fromUserDoc).toList(growable: false),
    );
  }

  Future<List<CategoryModel>> fetchForWorkspace(
    WorkspaceContext context,
  ) async {
    final snapshot = await _workspaceCollection(context).get();
    return snapshot.docs.map(CategoryModel.fromUserDoc).toList(growable: false);
  }

  Future<CategoryModel> createForWorkspace(
    WorkspaceContext context,
    CategoryModel model,
  ) async {
    final collection = _workspaceCollection(context);
    final docRef = collection.doc();
    final withId = model.copyWith(id: docRef.id);
    await docRef.set(withId.toFirestoreBase());
    return withId;
  }

  Future<void> updateForWorkspace(
    WorkspaceContext context,
    CategoryModel model,
  ) {
    final docRef = _workspaceCollection(context).doc(model.id);
    return docRef.update(model.toFirestoreBase());
  }

  Future<void> deleteForWorkspace(WorkspaceContext context, String categoryId) {
    return _workspaceCollection(context).doc(categoryId).delete();
  }
}
