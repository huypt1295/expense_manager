import 'package:flutter_core/flutter_core.dart';

abstract class WorkspaceEffect extends BaseBlocEffect {
  const WorkspaceEffect();
}

class WorkspaceShowErrorEffect extends WorkspaceEffect {
  const WorkspaceShowErrorEffect(this.message);

  final String message;
}
