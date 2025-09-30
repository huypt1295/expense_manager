import 'package:expense_manager/features/budget/domain/entities/budget_entity.dart';
import 'package:flutter_core/flutter_core.dart';

abstract class BudgetRepository extends Repository {
  Stream<List<BudgetEntity>> watchAll();

  Future<void> add(BudgetEntity entity);

  Future<void> update(BudgetEntity entity);

  Future<void> deleteById(String id);
}
