import 'package:flutter_core/flutter_core.dart';

class BudgetEntity extends BaseEntity with EquatableMixin {
  BudgetEntity({
    required this.id,
    required this.category,
    required this.limitAmount,
    required this.startDate,
    required this.endDate,
  });

  final String id;
  final String category;
  final double limitAmount;
  final DateTime startDate;
  final DateTime endDate;

  @override
  List<Object?> get props => <Object?>[
        id,
        category,
        limitAmount,
        startDate,
        endDate,
      ];

  @override
  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'category': category,
        'limitAmount': limitAmount,
        'startDate': startDate.toIso8601String(),
        'endDate': endDate.toIso8601String(),
      };

  BudgetEntity copyWith({
    String? id,
    String? category,
    double? limitAmount,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    return BudgetEntity(
      id: id ?? this.id,
      category: category ?? this.category,
      limitAmount: limitAmount ?? this.limitAmount,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
    );
  }
}
