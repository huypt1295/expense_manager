import 'package:equatable/equatable.dart';
import 'package:expense_manager/core/workspace/workspace_context.dart';

class WorkspaceDetailEntity extends Equatable {
  const WorkspaceDetailEntity({
    required this.id,
    required this.name,
    required this.currencyCode,
    required this.ownerId,
    required this.createdAt,
    required this.updatedAt,
    this.type = WorkspaceType.household,
  });

  final String id;
  final String name;
  final String currencyCode;
  final String ownerId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final WorkspaceType type;

  WorkspaceDetailEntity copyWith({
    String? id,
    String? name,
    String? currencyCode,
    String? ownerId,
    DateTime? createdAt,
    DateTime? updatedAt,
    WorkspaceType? type,
  }) {
    return WorkspaceDetailEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      currencyCode: currencyCode ?? this.currencyCode,
      ownerId: ownerId ?? this.ownerId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      type: type ?? this.type,
    );
  }

  @override
  List<Object?> get props => <Object?>[
        id,
        name,
        currencyCode,
        ownerId,
        createdAt,
        updatedAt,
        type,
      ];
}
