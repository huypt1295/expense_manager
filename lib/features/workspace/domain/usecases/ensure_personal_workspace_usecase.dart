import 'package:expense_manager/features/workspace/domain/repositories/workspace_detail_repository.dart';
import 'package:flutter_core/flutter_core.dart';

@singleton
class EnsurePersonalWorkspaceUseCase {
  const EnsurePersonalWorkspaceUseCase(this._repository);

  final WorkspaceDetailRepository _repository;

  Future<void> call() {
    return _repository.ensurePersonalWorkspace();
  }
}

