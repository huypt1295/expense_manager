import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_manager/features/transactions/domain/entities/transaction_entity.dart';

class TransactionModel {
  const TransactionModel({
    required this.id,
    required this.title,
    required this.amount,
    required this.date,
    this.category,
    this.note,
    this.deleted = false,
  });

  final String id;
  final String title;
  final double amount;
  final DateTime date;
  final String? category;
  final String? note;
  final bool deleted;

  TransactionEntity toEntity() {
    return TransactionEntity(
      id: id,
      title: title,
      amount: amount,
      date: date,
      category: category,
      note: note,
    );
  }

  TransactionModel copyWith({
    String? id,
    String? title,
    double? amount,
    DateTime? date,
    String? category,
    String? note,
    bool? deleted,
  }) {
    return TransactionModel(
      id: id ?? this.id,
      title: title ?? this.title,
      amount: amount ?? this.amount,
      date: date ?? this.date,
      category: category ?? this.category,
      note: note ?? this.note,
      deleted: deleted ?? this.deleted,
    );
  }

  Map<String, dynamic> toFirestore({bool merge = false}) {
    final map = <String, dynamic>{
      'title': title,
      'amount': amount,
      'date': Timestamp.fromDate(date),
      'category': category,
      'note': note,
      'deleted': deleted,
      'updatedAt': FieldValue.serverTimestamp(),
    };

    if (!merge) {
      map['createdAt'] = FieldValue.serverTimestamp();
    }
    return map;
  }

  static TransactionModel fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
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
      category: data['category'] as String?,
      note: data['note'] as String?,
      deleted: (data['deleted'] as bool?) ?? false,
    );
  }

  static TransactionModel fromEntity(TransactionEntity entity) {
    return TransactionModel(
      id: entity.id,
      title: entity.title,
      amount: entity.amount,
      date: entity.date,
      category: entity.category,
      note: entity.note,
    );
  }
}
