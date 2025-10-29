import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_manager/core/workspace/workspace_context.dart';
import 'package:expense_manager/features/workspace/domain/entities/workspace_entity.dart';

class WorkspaceModel {
  const WorkspaceModel({
    required this.id,
    required this.name,
    required this.type,
    required this.role,
  });

  final String id;
  final String name;
  final WorkspaceType type;
  final String role;

  factory WorkspaceModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
  ) {
    final data = snapshot.data() ?? const <String, dynamic>{};
    final typeValue = (data['type'] as String?) ?? 'household';
    final role = (data['role'] as String?) ?? 'viewer';
    final name = (data['name'] as String?) ?? 'Household';
    return WorkspaceModel(
      id: snapshot.id,
      name: name,
      type: _parseType(typeValue),
      role: role,
    );
  }

  Map<String, dynamic> toFirestore() {
    return <String, dynamic>{
      'name': name,
      'type': type.name,
      'role': role,
    };
  }

  WorkspaceEntity toEntity() {
    return WorkspaceEntity(
      id: id,
      name: name,
      type: type,
      role: role,
    );
  }

  static WorkspaceType _parseType(String raw) {
    switch (raw) {
      case 'personal':
        return WorkspaceType.personal;
      case 'household':
      default:
        return WorkspaceType.household;
    }
  }
}
