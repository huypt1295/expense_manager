import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_manager/features/workspace/domain/entities/household_entity.dart';

class HouseholdModel {
  const HouseholdModel({
    required this.id,
    required this.name,
    required this.currencyCode,
    required this.ownerId,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final String name;
  final String currencyCode;
  final String ownerId;
  final DateTime createdAt;
  final DateTime updatedAt;

  Map<String, dynamic> toFirestore() {
    return <String, dynamic>{
      'name': name,
      'currencyCode': currencyCode,
      'ownerId': ownerId,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  HouseholdEntity toEntity() {
    return HouseholdEntity(
      id: id,
      name: name,
      currencyCode: currencyCode,
      ownerId: ownerId,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  static HouseholdModel fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
  ) {
    final data = snapshot.data() ?? const <String, dynamic>{};
    return HouseholdModel(
      id: snapshot.id,
      name: (data['name'] as String?) ?? 'Household',
      currencyCode: (data['currencyCode'] as String?) ?? 'VND',
      ownerId: (data['ownerId'] as String?) ?? '',
      createdAt: _parseTimestamp(data['createdAt']),
      updatedAt: _parseTimestamp(data['updatedAt']),
    );
  }

  static DateTime _parseTimestamp(dynamic value) {
    if (value is Timestamp) {
      return value.toDate();
    }
    if (value is DateTime) {
      return value;
    }
    return DateTime.now();
  }
}
