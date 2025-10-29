import 'workspace_context.dart';

class CurrentWorkspaceSnapshot {
  const CurrentWorkspaceSnapshot({
    required this.id,
    required this.type,
    required this.name,
    this.role,
  });

  const CurrentWorkspaceSnapshot.personal({
    required String id,
    String? name,
  }) : this(
          id: id,
          type: WorkspaceType.personal,
          name: name ?? 'Personal',
          role: 'owner',
        );

  final String id;
  final WorkspaceType type;
  final String name;
  final String? role;

  bool get isPersonal => type == WorkspaceType.personal;

  WorkspaceContext toContext({required String userId}) {
    return WorkspaceContext(
      userId: userId,
      workspaceId: id,
      type: type,
    );
  }

  CurrentWorkspaceSnapshot copyWith({
    String? id,
    WorkspaceType? type,
    String? name,
    String? role,
  }) {
    return CurrentWorkspaceSnapshot(
      id: id ?? this.id,
      type: type ?? this.type,
      name: name ?? this.name,
      role: role ?? this.role,
    );
  }
}

abstract interface class CurrentWorkspace {
  CurrentWorkspaceSnapshot? now();

  Stream<CurrentWorkspaceSnapshot?> watch();

  Future<void> select(CurrentWorkspaceSnapshot? snapshot);
}
