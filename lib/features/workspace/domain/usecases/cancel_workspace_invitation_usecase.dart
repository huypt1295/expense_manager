import 'package:expense_manager/features/workspace/domain/repositories/workspace_detail_repository.dart';
import 'package:flutter_core/flutter_core.dart';

class CancelWorkspaceInvitationParams {
  const CancelWorkspaceInvitationParams({
    required this.workspaceId,
    required this.invitationId,
  });

  final String workspaceId;
  final String invitationId;
}

@injectable
class CancelWorkspaceInvitationUseCase {
  const CancelWorkspaceInvitationUseCase(this._repository);

  final WorkspaceDetailRepository _repository;

  Future<void> call(CancelWorkspaceInvitationParams params) {
    return _repository.cancelInvitation(
      workspaceId: params.workspaceId,
      invitationId: params.invitationId,
    );
  }
}

