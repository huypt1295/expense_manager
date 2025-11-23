import 'package:expense_manager/features/workspace/domain/repositories/workspace_detail_repository.dart';
import 'package:flutter_core/flutter_core.dart';

@singleton
class EnsurePersonalWorkspaceUseCase {
  const EnsurePersonalWorkspaceUseCase(this._repository);

  final WorkspaceDetailRepository _repository;

  Future<void> call() {
    return _repository.ensurePersonalWorkspace();
  }

  Future<bool> verifyMemberExists({
    required String workspaceId,
    required String userId,
  }) {
    return _repository.verifyMemberExists(
      workspaceId: workspaceId,
      userId: userId,
    );
  }
}
