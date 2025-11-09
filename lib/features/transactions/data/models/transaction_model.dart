import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_manager/core/enums/transaction_type.dart';
import 'package:expense_manager/features/transactions/domain/entities/transaction_entity.dart';

class TransactionModel {
  const TransactionModel({
    required this.id,
    required this.title,
    required this.amount,
    required this.date,
    required this.type,
    this.category,
    this.note,
    this.deleted = false,
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
  final bool deleted;
  final String? categoryId;
  final String? categoryIcon;
  final String? sharedFromWorkspaceId;
  final String? sharedFromTransactionId;
  final String? sharedByUserId;

  TransactionEntity toEntity() {
    return TransactionEntity(
      id: id,
      title: title,
      amount: amount,
      date: date,
      type: type,
      category: category,
      note: note,
      categoryId: categoryId,
      categoryIcon: categoryIcon,
      sharedFromWorkspaceId: sharedFromWorkspaceId,
      sharedFromTransactionId: sharedFromTransactionId,
      sharedByUserId: sharedByUserId,
    );
  }

  TransactionModel copyWith({
    String? id,
    String? title,
    double? amount,
    DateTime? date,
    TransactionType? type,
    String? category,
    String? note,
    bool? deleted,
    String? categoryId,
    String? categoryIcon,
    String? sharedFromWorkspaceId,
    String? sharedFromTransactionId,
    String? sharedByUserId,
  }) {
    return TransactionModel(
      id: id ?? this.id,
      title: title ?? this.title,
      amount: amount ?? this.amount,
      date: date ?? this.date,
      type: type ?? this.type,
      category: category ?? this.category,
      note: note ?? this.note,
      deleted: deleted ?? this.deleted,
      categoryId: categoryId ?? this.categoryId,
      categoryIcon: categoryIcon ?? this.categoryIcon,
      sharedFromWorkspaceId:
          sharedFromWorkspaceId ?? this.sharedFromWorkspaceId,
      sharedFromTransactionId:
          sharedFromTransactionId ?? this.sharedFromTransactionId,
      sharedByUserId: sharedByUserId ?? this.sharedByUserId,
    );
  }

  Map<String, dynamic> toFirestore({bool merge = false}) {
    final map = <String, dynamic>{
      'title': title,
      'amount': amount,
      'date': Timestamp.fromDate(date),
      'type': transactionTypeToJson(type),
      'category': category,
      'note': note,
      'deleted': deleted,
      'updatedAt': FieldValue.serverTimestamp(),
      'categoryId': categoryId,
      'categoryIcon': categoryIcon,
      'sharedFromWorkspaceId': sharedFromWorkspaceId,
      'sharedFromTransactionId': sharedFromTransactionId,
      'sharedByUserId': sharedByUserId,
    };

    if (!merge) {
      map['createdAt'] = FieldValue.serverTimestamp();
    }
    return map..removeWhere((key, value) => value == null);
  }

  static TransactionModel fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data() ?? <String, dynamic>{};
    final timestamp = data['date'];
    DateTime? parsedDate;
    if (timestamp is Timestamp) {
      parsedDate = timestamp.toDate();
    } else if (timestamp is DateTime) {
      parsedDate = timestamp;
    } else if (timestamp is String) {
      parsedDate = DateTime.tryParse(timestamp);
    }

    return TransactionModel(
      id: doc.id,
      title: (data['title'] as String?) ?? '',
      amount: (data['amount'] as num?)?.toDouble() ?? 0,
      date: parsedDate ?? DateTime.now(),
      type: parseTransactionType(data['type']),
      category: data['category'] as String?,
      note: data['note'] as String?,
      deleted: (data['deleted'] as bool?) ?? false,
      categoryId: data['categoryId'] as String?,
      categoryIcon: data['categoryIcon'] as String?,
      sharedFromWorkspaceId: data['sharedFromWorkspaceId'] as String?,
      sharedFromTransactionId: data['sharedFromTransactionId'] as String?,
      sharedByUserId: data['sharedByUserId'] as String?,
    );
  }

  static TransactionModel fromEntity(TransactionEntity entity) {
    return TransactionModel(
      id: entity.id,
      title: entity.title,
      amount: entity.amount,
      date: entity.date,
      type: entity.type,
      category: entity.category,
      note: entity.note,
      categoryId: entity.categoryId,
      categoryIcon: entity.categoryIcon,
      sharedFromWorkspaceId: entity.sharedFromWorkspaceId,
      sharedFromTransactionId: entity.sharedFromTransactionId,
      sharedByUserId: entity.sharedByUserId,
    );
  }
}
