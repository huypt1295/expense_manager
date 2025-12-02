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
    required this.isUserDefined,
    this.sortOrder,
    this.ownerId,
    this.createdAt,
    this.updatedAt,
    this.isArchived,
  });

  final String id;
  final String icon;
  final bool isActive;
  final TransactionType type;
  final Map<String, String> name;
  final bool isUserDefined;
  final int? sortOrder;
  final String? ownerId;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final bool? isArchived;

  CategoryEntity toEntity() {
    return CategoryEntity(
      id: id,
      icon: icon,
      isActive: isActive,
      type: type,
      names: name,
      sortOrder: sortOrder,
      isCustom: isUserDefined,
      ownerId: ownerId,
      createdAt: createdAt,
      updatedAt: updatedAt,
      isArchived: isArchived ?? false,
    );
  }

  static CategoryModel fromDefaultDoc(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data() ?? <String, dynamic>{};
    return _fromDocData(doc.id, data, isUserDefined: false);
  }

  static CategoryModel fromUserDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? <String, dynamic>{};
    return _fromDocData(doc.id, data, isUserDefined: true);
  }

  static CategoryModel fromEntity(CategoryEntity entity) {
    return CategoryModel(
      id: entity.id,
      icon: entity.icon,
      isActive: entity.isActive,
      type: entity.type,
      name: entity.names,
      sortOrder: entity.sortOrder,
      isUserDefined: entity.isCustom,
      ownerId: entity.ownerId,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      isArchived: entity.isArchived,
    );
  }

  Map<String, dynamic> toFirestoreBase() {
    return <String, dynamic>{
      'icon': icon,
      'isActive': isActive,
      'type': transactionTypeToJson(type),
      'name': name,
      if (sortOrder != null) 'sortOrder': sortOrder,
      if (isArchived != null) 'isArchived': isArchived,
      if (createdAt != null) 'createdAt': Timestamp.fromDate(createdAt!),
      if (updatedAt != null) 'updatedAt': Timestamp.fromDate(updatedAt!),
    };
  }

  static CategoryModel _fromDocData(
    String id,
    Map<String, dynamic> data, {
    required bool isUserDefined,
  }) {
    return CategoryModel(
      id: id,
      icon: (data['icon'] as String?) ?? '',
      isActive: (data['isActive'] as bool?) ?? true,
      type: parseTransactionType(data['type']),
      name: _parseNameMap(data['name'] ?? data['names']),
      sortOrder: (data['sortOrder'] as num?)?.toInt(),
      isUserDefined: isUserDefined,
      ownerId: data['ownerId'] as String?,
      createdAt: _parseTimestamp(data['createdAt']),
      updatedAt: _parseTimestamp(data['updatedAt']),
      isArchived: data['isArchived'] as bool?,
    );
  }

  static Map<String, String> _parseNameMap(dynamic raw) {
    if (raw is Map) {
      return raw.map((key, value) {
        return MapEntry(key.toString(), value?.toString() ?? '');
      });
    }
    return <String, String>{};
  }

  static DateTime? _parseTimestamp(dynamic value) {
    if (value is Timestamp) {
      return value.toDate();
    }
    if (value is DateTime) {
      return value;
    }
    return null;
  }

  CategoryModel copyWith({
    String? id,
    String? icon,
    bool? isActive,
    TransactionType? type,
    Map<String, String>? name,
    bool? isUserDefined,
    int? sortOrder,
    String? ownerId,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isArchived,
  }) {
    return CategoryModel(
      id: id ?? this.id,
      icon: icon ?? this.icon,
      isActive: isActive ?? this.isActive,
      type: type ?? this.type,
      name: name ?? this.name,
      isUserDefined: isUserDefined ?? this.isUserDefined,
      sortOrder: sortOrder ?? this.sortOrder,
      ownerId: ownerId ?? this.ownerId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isArchived: isArchived ?? this.isArchived,
    );
  }
}
