import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_manager/core/enums/transaction_type.dart';
import 'package:expense_manager/features/categories/domain/entities/category_entity.dart';

class CategoryModel {
  const CategoryModel({
    required this.id,
    required this.icon,
    required this.isActive,
    required this.type,
    required this.name,
    this.sortOrder,
  });

  final String id;
  final String icon;
  final bool isActive;
  final TransactionType type;
  final Map<String, String> name;
  final int? sortOrder;

  CategoryEntity toEntity() {
    return CategoryEntity(
      id: id,
      icon: icon,
      isActive: isActive,
      type: type,
      names: name,
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
      type: parseTransactionType(data['type']),
      name: parsedNames,
      sortOrder: (data['sortOrder'] as num?)?.toInt(),
    );
  }
}
