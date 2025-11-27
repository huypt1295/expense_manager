enum WorkspaceType {
  personal,
  workspace,
}

class WorkspaceContext {
  const WorkspaceContext({
    required this.userId,
    required this.workspaceId,
    required this.type,
  });

  final String userId;
  final String workspaceId;
  final WorkspaceType type;

  bool get isPersonal => type == WorkspaceType.personal;

  WorkspaceContext copyWith({
    String? userId,
    String? workspaceId,
    WorkspaceType? type,
  }) {
    return WorkspaceContext(
      userId: userId ?? this.userId,
      workspaceId: workspaceId ?? this.workspaceId,
      type: type ?? this.type,
    );
  }
}
