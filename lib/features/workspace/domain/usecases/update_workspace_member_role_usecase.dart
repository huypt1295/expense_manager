import 'package:expense_manager/features/workspace/domain/repositories/workspace_detail_repository.dart';
import 'package:flutter_core/flutter_core.dart';

class UpdateWorkspaceMemberRoleParams {
  const UpdateWorkspaceMemberRoleParams({
    required this.workspaceId,
    required this.memberId,
    required this.role,
  });

  final String workspaceId;
  final String memberId;
  final String role;
}

@injectable
class UpdateWorkspaceMemberRoleUseCase {
  const UpdateWorkspaceMemberRoleUseCase(this._repository);

  final WorkspaceDetailRepository _repository;

  Future<void> call(UpdateWorkspaceMemberRoleParams params) {
    return _repository.updateMemberRole(
      workspaceId: params.workspaceId,
      memberId: params.memberId,
      role: params.role,
    );
  }
}

