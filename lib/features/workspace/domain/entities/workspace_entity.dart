import 'package:expense_manager/core/workspace/workspace_context.dart';
import 'package:flutter_core/flutter_core.dart';

class WorkspaceEntity with EquatableMixin {
  const WorkspaceEntity({
    required this.id,
    required this.name,
    required this.type,
    required this.role,
    this.isDefault = false,
  });

  const WorkspaceEntity.personal({
    required String id,
    required String name,
  }) : this(
          id: id,
          name: name,
          type: WorkspaceType.personal,
          role: 'owner',
          isDefault: true,
        );

  final String id;
  final String name;
  final WorkspaceType type;
  final String role;
  final bool isDefault;

  bool get isPersonal => type == WorkspaceType.personal;

  WorkspaceEntity copyWith({
    String? id,
    String? name,
    WorkspaceType? type,
    String? role,
    bool? isDefault,
  }) {
    return WorkspaceEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      role: role ?? this.role,
      isDefault: isDefault ?? this.isDefault,
    );
  }

  @override
  List<Object?> get props => <Object?>[id, name, type, role, isDefault];
}
