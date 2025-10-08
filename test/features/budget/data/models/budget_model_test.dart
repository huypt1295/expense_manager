import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_manager/features/budget/data/models/budget_model.dart';
import 'package:expense_manager/features/budget/domain/entities/budget_entity.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  BudgetModel model() => BudgetModel(
        id: 'budget',
        category: 'Food',
        categoryId: 'food',
        limitAmount: 100,
        startDate: DateTime(2024, 1, 1),
        endDate: DateTime(2024, 1, 31),
      );

  test('toEntity converts to domain object', () {
    final entity = model().toEntity();
    expect(entity.category, 'Food');
    expect(entity.limitAmount, 100);
    expect(entity.categoryId, 'food');
  });

  test('fromEntity creates model with same data', () {
    final entity = BudgetEntity(
      id: 'budget',
      category: 'Travel',
      categoryId: 'travel',
      limitAmount: 200,
      startDate: DateTime(2024, 2, 1),
      endDate: DateTime(2024, 2, 28),
    );

    final model = BudgetModel.fromEntity(entity);
    expect(model.id, 'budget');
    expect(model.category, 'Travel');
    expect(model.categoryId, 'travel');
  });

  test('toFirestore outputs expected map', () {
    final map = model().toFirestore();
    expect(map['category'], 'Food');
    expect(map['categoryId'], 'food');
    expect(map['limitAmount'], 100);
    expect(map['startDate'], isA<Timestamp>());
    expect(map['endDate'], isA<Timestamp>());
  });

  test('fromFirestore reads Firestore snapshot', () async {
    final firestore = FakeFirebaseFirestore();
    await firestore
        .collection('users')
        .doc('uid')
        .collection('budgets')
        .doc('doc')
        .set({
      'category': 'Misc',
      'categoryId': 'misc',
      'limitAmount': 50,
      'startDate': Timestamp.fromDate(DateTime(2024, 3, 1)),
      'endDate': Timestamp.fromDate(DateTime(2024, 3, 31)),
    });

    final snapshot = await firestore
        .collection('users')
        .doc('uid')
        .collection('budgets')
        .doc('doc')
        .get();

    final model = BudgetModel.fromFirestore(snapshot);
    expect(model.id, 'doc');
    expect(model.categoryId, 'misc');
    expect(model.limitAmount, 50);
  });
}
