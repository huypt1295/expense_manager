import 'package:expense_manager/features/budget/domain/entities/budget_entity.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  BudgetEntity entity() => BudgetEntity(
        id: 'id',
        category: 'Food',
        limitAmount: 100,
        startDate: DateTime(2024, 1, 1),
        endDate: DateTime(2024, 1, 31),
        categoryId: 'food',
      );

  test('BudgetEntity equality compares all fields', () {
    expect(entity(), equals(entity()));
  });

  test('BudgetEntity copyWith overrides provided values', () {
    final updated = entity().copyWith(
      category: 'Travel',
      limitAmount: 200,
      categoryId: 'travel',
    );

    expect(updated.category, 'Travel');
    expect(updated.limitAmount, 200);
    expect(updated.categoryId, 'travel');
  });

  test('BudgetEntity toJson exports expected keys', () {
    final json = entity().toJson();
    expect(json['category'], 'Food');
    expect(json['limitAmount'], 100);
    expect(json['categoryId'], 'food');
  });
}
