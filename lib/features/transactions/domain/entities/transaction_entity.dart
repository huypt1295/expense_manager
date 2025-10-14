import 'package:expense_manager/core/enums/transaction_type.dart';
import 'package:flutter_core/flutter_core.dart';

class TransactionEntity extends BaseEntity with EquatableMixin {
  TransactionEntity({
    required this.id,
    required this.title,
    required this.amount,
    required this.date,
    required this.type,
    this.category,
    this.note,
    this.categoryIcon,
  });

  final String id;
  final String title;
  final double amount;
  final DateTime date;
  final TransactionType type;
  final String? category;
  final String? note;
  final String? categoryIcon;

  @override
  List<Object?> get props => <Object?>[
    id,
    title,
    amount,
    date,
    type,
    category,
    note,
    categoryIcon,
  ];

  @override
  Map<String, dynamic> toJson() => <String, dynamic>{
    'id': id,
    'title': title,
    'amount': amount,
    'date': date.toIso8601String(),
    'type': transactionTypeToJson(type),
    'category': category,
    'note': note,
    'categoryIcon': categoryIcon,
  };

  TransactionEntity copyWith({
    String? id,
    String? title,
    double? amount,
    DateTime? date,
    TransactionType? type,
    String? category,
    String? note,
    String? categoryIcon,
  }) {
    return TransactionEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      amount: amount ?? this.amount,
      date: date ?? this.date,
      type: type ?? this.type,
      category: category ?? this.category,
      note: note ?? this.note,
      categoryIcon: categoryIcon ?? this.categoryIcon,
    );
  }
}
