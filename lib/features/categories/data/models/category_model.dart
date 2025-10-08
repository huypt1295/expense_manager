import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_manager/features/categories/domain/entities/category_entity.dart';

class CategoryModel {
  const CategoryModel({
    required this.id,
    required this.icon,
    required this.isActive,
    required this.names,
    this.sortOrder,
  });

  final String id;
  final String icon;
  final bool isActive;
  final Map<String, String> names;
  final int? sortOrder;

  CategoryEntity toEntity() {
    return CategoryEntity(
      id: id,
      icon: icon,
      isActive: isActive,
      names: names,
      sortOrder: sortOrder,
    );
  }

  static CategoryModel fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data() ?? <String, dynamic>{};
    final rawNames = data['name'];
    Map<String, String> parsedNames;
    if (rawNames is Map) {
      parsedNames = rawNames.map((key, value) {
        return MapEntry(key.toString(), value?.toString() ?? '');
      });
    } else {
      parsedNames = <String, String>{};
    }

    return CategoryModel(
      id: doc.id,
      icon: (data['icon'] as String?) ?? '',
      isActive: (data['isActive'] as bool?) ?? true,
      names: parsedNames,
      sortOrder: (data['sortOrder'] as num?)?.toInt(),
    );
  }
}
