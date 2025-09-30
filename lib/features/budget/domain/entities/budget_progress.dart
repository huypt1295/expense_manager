import 'package:flutter_core/flutter_core.dart';

class BudgetProgress extends BaseEntity with EquatableMixin {
  BudgetProgress({
    required this.budgetId,
    required this.spentAmount,
    required this.remainingAmount,
    required this.percentage,
  });

  final String budgetId;
  final double spentAmount;
  final double remainingAmount;
  final double percentage;

  @override
  List<Object?> get props => <Object?>[
        budgetId,
        spentAmount,
        remainingAmount,
        percentage,
      ];

  @override
  Map<String, dynamic> toJson() => <String, dynamic>{
        'budgetId': budgetId,
        'spentAmount': spentAmount,
        'remainingAmount': remainingAmount,
        'percentage': percentage,
      };
}
