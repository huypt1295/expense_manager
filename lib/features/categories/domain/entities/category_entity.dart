import 'package:flutter_core/flutter_core.dart';

class CategoryEntity extends BaseEntity with EquatableMixin {
  CategoryEntity({
    required this.id,
    required this.icon,
    required this.isActive,
    required Map<String, String> names,
    this.sortOrder,
  }) : names = Map.unmodifiable(
          names.map((key, value) => MapEntry(key.toLowerCase(), value)),
        );

  final String id;
  final String icon;
  final bool isActive;
  final Map<String, String> names;
  final int? sortOrder;

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

  @override
  List<Object?> get props => <Object?>[
        id,
        icon,
        isActive,
        names,
        sortOrder,
      ];

  @override
  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'icon': icon,
        'isActive': isActive,
        'names': names,
        if (sortOrder != null) 'sortOrder': sortOrder,
      };
}
