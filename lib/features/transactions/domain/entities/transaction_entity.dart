import 'package:flutter_core/flutter_core.dart';

class TransactionEntity extends BaseEntity with EquatableMixin {
  TransactionEntity({
    required this.id,
    required this.title,
    required this.amount,
    required this.date,
    this.category,
    this.note,
  });

  final String id;
  final String title;
  final double amount;
  final DateTime date;
  final String? category;
  final String? note;

  @override
  List<Object?> get props => <Object?>[
        id,
        title,
        amount,
        date,
        category,
        note,
      ];

  @override
  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'title': title,
        'amount': amount,
        'date': date.toIso8601String(),
        'category': category,
        'note': note,
      };

  TransactionEntity copyWith({
    String? id,
    String? title,
    double? amount,
    DateTime? date,
    String? category,
    String? note,
  }) {
    return TransactionEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      amount: amount ?? this.amount,
      date: date ?? this.date,
      category: category ?? this.category,
      note: note ?? this.note,
    );
  }
}
