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
    this.categoryId,
    this.categoryIcon,
    this.sharedFromWorkspaceId,
    this.sharedFromTransactionId,
    this.sharedByUserId,
  });

  final String id;
  final String title;
  final double amount;
  final DateTime date;
  final TransactionType type;
  final String? category;
  final String? note;
  final String? categoryId;
  final String? categoryIcon;
  final String? sharedFromWorkspaceId;
  final String? sharedFromTransactionId;
  final String? sharedByUserId;

  @override
  List<Object?> get props => <Object?>[
    id,
    title,
    amount,
    date,
    type,
    category,
    note,
    categoryId,
    categoryIcon,
    sharedFromWorkspaceId,
    sharedFromTransactionId,
    sharedByUserId,
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
    'categoryId': categoryId,
    'categoryIcon': categoryIcon,
    'sharedFromWorkspaceId': sharedFromWorkspaceId,
    'sharedFromTransactionId': sharedFromTransactionId,
    'sharedByUserId': sharedByUserId,
  };

  TransactionEntity copyWith({
    String? id,
    String? title,
    double? amount,
    DateTime? date,
    TransactionType? type,
    String? category,
    String? note,
    String? categoryId,
    String? categoryIcon,
    String? sharedFromWorkspaceId,
    String? sharedFromTransactionId,
    String? sharedByUserId,
  }) {
    return TransactionEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      amount: amount ?? this.amount,
      date: date ?? this.date,
      type: type ?? this.type,
      category: category ?? this.category,
      note: note ?? this.note,
      categoryId: categoryId ?? this.categoryId,
      categoryIcon: categoryIcon ?? this.categoryIcon,
      sharedFromWorkspaceId:
          sharedFromWorkspaceId ?? this.sharedFromWorkspaceId,
      sharedFromTransactionId:
          sharedFromTransactionId ?? this.sharedFromTransactionId,
      sharedByUserId: sharedByUserId ?? this.sharedByUserId,
    );
  }
}
