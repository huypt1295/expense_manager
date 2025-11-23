import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_manager/core/workspace/workspace_context.dart';
import 'package:expense_manager/features/workspace/domain/entities/workspace_detail_entity.dart';

class WorkspaceDetailModel {
  const WorkspaceDetailModel({
    required this.id,
    required this.name,
    required this.currencyCode,
    required this.ownerId,
    required this.createdAt,
    required this.updatedAt,
    this.type = WorkspaceType.workspace,
  });

  final String id;
  final String name;
  final String currencyCode;
  final String ownerId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final WorkspaceType type;

  Map<String, dynamic> toFirestore() {
    return <String, dynamic>{
      'name': name,
      'currencyCode': currencyCode,
      'ownerId': ownerId,
      'type': type.name,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  WorkspaceDetailEntity toEntity() {
    return WorkspaceDetailEntity(
      id: id,
      name: name,
      currencyCode: currencyCode,
      ownerId: ownerId,
      createdAt: createdAt,
      updatedAt: updatedAt,
      type: type,
    );
  }

  static WorkspaceDetailModel fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
  ) {
    final data = snapshot.data() ?? const <String, dynamic>{};
    return WorkspaceDetailModel(
      id: snapshot.id,
      name: (data['name'] as String?) ?? 'Workspace',
      currencyCode: (data['currencyCode'] as String?) ?? 'VND',
      ownerId: (data['ownerId'] as String?) ?? '',
      type: _parseType(data['type']),
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

  static WorkspaceType _parseType(dynamic value) {
    final typeStr = (value as String?)?.toLowerCase();
    switch (typeStr) {
      case 'personal':
        return WorkspaceType.personal;
      case 'shared':
      case 'workspace':
      default:
        return WorkspaceType.workspace;
    }
  }
}
