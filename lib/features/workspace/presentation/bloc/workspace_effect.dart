import 'package:flutter_core/flutter_core.dart';

abstract class WorkspaceEffect extends Effect {
  const WorkspaceEffect();
}

class WorkspaceShowErrorEffect extends WorkspaceEffect {
  const WorkspaceShowErrorEffect(this.message);

  final String message;
}

class WorkspaceShowLostAccessEffect extends WorkspaceEffect {
  const WorkspaceShowLostAccessEffect({
    required this.workspaceId,
    required this.workspaceName,
  });

  final String workspaceId;
  final String workspaceName;
}
