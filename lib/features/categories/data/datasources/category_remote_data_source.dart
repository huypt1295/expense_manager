import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_manager/features/categories/data/models/category_model.dart';
import 'package:flutter_core/flutter_core.dart';

@lazySingleton
class CategoryRemoteDataSource {
  CategoryRemoteDataSource(this._firestore);

  final FirebaseFirestore _firestore;

  Stream<List<CategoryModel>> watchAll() {
    return _firestore
        .collection('categories')
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map(CategoryModel.fromFirestore)
              .toList(growable: false),
        );
  }

  Future<List<CategoryModel>> fetchAll() async {
    final snapshot = await _firestore.collection('categories').get();
    return snapshot.docs
        .map(CategoryModel.fromFirestore)
        .toList(growable: false);
  }
}
