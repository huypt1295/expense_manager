import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_manager/features/budget/domain/entities/budget_entity.dart';

class BudgetModel {
  const BudgetModel({
    required this.id,
    required this.category,
    required this.limitAmount,
    required this.startDate,
    required this.endDate,
    this.categoryId = '',
  });

  final String id;
  final String category;
  final double limitAmount;
  final DateTime startDate;
  final DateTime endDate;
  final String categoryId;

  BudgetEntity toEntity() {
    return BudgetEntity(
      id: id,
      category: category,
      limitAmount: limitAmount,
      startDate: startDate,
      endDate: endDate,
      categoryId: categoryId,
    );
  }

  BudgetModel copyWith({
    String? id,
    String? category,
    double? limitAmount,
    DateTime? startDate,
    DateTime? endDate,
    String? categoryId,
  }) {
    return BudgetModel(
      id: id ?? this.id,
      category: category ?? this.category,
      limitAmount: limitAmount ?? this.limitAmount,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      categoryId: categoryId ?? this.categoryId,
    );
  }

  Map<String, dynamic> toFirestore({bool merge = false}) {
    final map = <String, dynamic>{
      'category': category,
      'categoryName': category,
      'limitAmount': limitAmount,
      'startDate': Timestamp.fromDate(startDate),
      'endDate': Timestamp.fromDate(endDate),
      'updatedAt': FieldValue.serverTimestamp(),
    };
    if (categoryId.isNotEmpty) {
      map['categoryId'] = categoryId;
    }
    if (!merge) {
      map['createdAt'] = FieldValue.serverTimestamp();
    }
    return map;
  }

  static BudgetModel fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data() ?? <String, dynamic>{};
    DateTime parseDate(dynamic value) {
      if (value is Timestamp) {
        return value.toDate();
      }
      if (value is DateTime) {
        return value;
      }
      if (value is String) {
        return DateTime.tryParse(value) ?? DateTime.now();
      }
      return DateTime.now();
    }

    return BudgetModel(
      id: doc.id,
      category: (data['categoryName'] as String?) ??
          (data['category'] as String?) ??
          '',
      limitAmount: (data['limitAmount'] as num?)?.toDouble() ?? 0,
      startDate: parseDate(data['startDate']),
      endDate: parseDate(data['endDate']),
      categoryId: (data['categoryId'] as String?) ??
          (data['category'] as String?) ??
          '',
    );
  }

  static BudgetModel fromEntity(BudgetEntity entity) {
    return BudgetModel(
      id: entity.id,
      category: entity.category,
      limitAmount: entity.limitAmount,
      startDate: entity.startDate,
      endDate: entity.endDate,
      categoryId: entity.categoryId,
    );
  }
}
