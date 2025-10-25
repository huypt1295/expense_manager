import 'package:expense_manager/core/enums/transaction_type.dart';
import 'package:flutter_core/flutter_core.dart';

class CategoryEntity extends BaseEntity with EquatableMixin {
  CategoryEntity({
    required this.id,
    required this.icon,
    required this.isActive,
    required this.type,
    required Map<String, String> names,
    this.sortOrder,
    this.isCustom = false,
    this.ownerId,
    this.createdAt,
    this.updatedAt,
    this.isArchived = false,
  }) : names = Map.unmodifiable(
         names.map((key, value) => MapEntry(key.toLowerCase(), value)),
       );

  final String id;
  final String icon;
  final bool isActive;
  final TransactionType type;
  final Map<String, String> names;
  final int? sortOrder;
  final bool isCustom;
  final String? ownerId;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final bool isArchived;

  String nameForLocale(String localeCode, {String fallbackLocale = 'en'}) {
    final normalized = localeCode.toLowerCase();
    if (names[normalized]?.isNotEmpty ?? false) {
      return names[normalized]!;
    }
    if (names[fallbackLocale]?.isNotEmpty ?? false) {
      return names[fallbackLocale]!;
    }
    if (names.isNotEmpty) {
      final firstNonEmpty = names.values.firstWhere(
        (value) => value.isNotEmpty,
        orElse: () => id,
      );
      if (firstNonEmpty.isNotEmpty) {
        return firstNonEmpty;
      }
    }
    return id;
  }

  CategoryEntity copyWith({
    String? id,
    String? icon,
    bool? isActive,
    TransactionType? type,
    Map<String, String>? names,
    int? sortOrder,
    bool? isCustom,
    String? ownerId,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isArchived,
  }) {
    return CategoryEntity(
      id: id ?? this.id,
      icon: icon ?? this.icon,
      isActive: isActive ?? this.isActive,
      type: type ?? this.type,
      names: names ?? this.names,
      sortOrder: sortOrder ?? this.sortOrder,
      isCustom: isCustom ?? this.isCustom,
      ownerId: ownerId ?? this.ownerId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isArchived: isArchived ?? this.isArchived,
    );
  }

  @override
  List<Object?> get props => <Object?>[
    id,
    icon,
    isActive,
    type,
    names,
    sortOrder,
    isCustom,
    ownerId,
    createdAt,
    updatedAt,
    isArchived,
  ];

  @override
  Map<String, dynamic> toJson() => <String, dynamic>{
    'id': id,
    'icon': icon,
    'isActive': isActive,
    'type': transactionTypeToJson(type),
    'names': names,
    if (sortOrder != null) 'sortOrder': sortOrder,
    'isCustom': isCustom,
    if (ownerId != null) 'ownerId': ownerId,
    if (createdAt != null) 'createdAt': createdAt!.toIso8601String(),
    if (updatedAt != null) 'updatedAt': updatedAt!.toIso8601String(),
    'isArchived': isArchived,
  };
}
