import 'package:expense_manager/features/categories/domain/entities/category_entity.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  CategoryEntity entity() => CategoryEntity(
        id: 'cat',
        icon: 'icon',
        isActive: true,
        names: {'en': 'Category', 'vi': 'Danh mục'},
        sortOrder: 1,
      );

  test('nameForLocale returns localized name when available', () {
    final cat = entity();
    expect(cat.nameForLocale('vi'), 'Danh mục');
  });

  test('nameForLocale falls back to provided fallback locale', () {
    final cat = entity();
    expect(cat.nameForLocale('fr'), 'Category');
  });

  test('nameForLocale returns id when no names populated', () {
    final cat = CategoryEntity(
      id: 'cat',
      icon: 'icon',
      isActive: true,
      names: const {},
    );
    expect(cat.nameForLocale('fr'), 'cat');
  });

  test('toJson includes optional sortOrder when present', () {
    final json = entity().toJson();
    expect(json['sortOrder'], 1);
  });
}
