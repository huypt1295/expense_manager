import 'package:flutter_core/flutter_core.dart';

class CategoryEntity extends BaseEntity with EquatableMixin {
  CategoryEntity({
    required this.id,
    required this.icon,
    required this.isActive,
    required Map<String, String> names,
    this.sortOrder,
  }) : name = Map.unmodifiable(
          names.map((key, value) => MapEntry(key.toLowerCase(), value)),
        );

  final String id;
  final String icon;
  final bool isActive;
  final Map<String, String> name;
  final int? sortOrder;

  String nameForLocale(String localeCode, {String fallbackLocale = 'en'}) {
    final normalized = localeCode.toLowerCase();
    if (name[normalized]?.isNotEmpty ?? false) {
      return name[normalized]!;
    }
    if (name[fallbackLocale]?.isNotEmpty ?? false) {
      return name[fallbackLocale]!;
    }
    if (name.isNotEmpty) {
      final firstNonEmpty = name.values.firstWhere(
        (value) => value.isNotEmpty,
        orElse: () => id,
      );
      if (firstNonEmpty.isNotEmpty) {
        return firstNonEmpty;
      }
    }
    return id;
  }

  @override
  List<Object?> get props => <Object?>[
        id,
        icon,
        isActive,
        name,
        sortOrder,
      ];

  @override
  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'icon': icon,
        'isActive': isActive,
        'names': name,
        if (sortOrder != null) 'sortOrder': sortOrder,
      };
}
