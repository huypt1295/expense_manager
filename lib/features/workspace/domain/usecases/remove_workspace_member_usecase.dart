import 'package:expense_manager/features/workspace/domain/repositories/workspace_detail_repository.dart';
import 'package:flutter_core/flutter_core.dart';

class RemoveWorkspaceMemberParams {
  const RemoveWorkspaceMemberParams({
    required this.workspaceId,
    required this.memberId,
  });

  final String workspaceId;
  final String memberId;
}

@injectable
class RemoveWorkspaceMemberUseCase {
  const RemoveWorkspaceMemberUseCase(this._repository);

  final WorkspaceDetailRepository _repository;

  Future<void> call(RemoveWorkspaceMemberParams params) {
    return _repository.removeMember(
      workspaceId: params.workspaceId,
      memberId: params.memberId,
    );
  }
}

