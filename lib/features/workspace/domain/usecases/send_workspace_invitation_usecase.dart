import 'package:expense_manager/features/workspace/domain/repositories/workspace_detail_repository.dart';
import 'package:flutter_core/flutter_core.dart';

class SendWorkspaceInvitationParams {
  const SendWorkspaceInvitationParams({
    required this.workspaceId,
    required this.email,
    required this.role,
  });

  final String workspaceId;
  final String email;
  final String role;
}

@injectable
class SendWorkspaceInvitationUseCase {
  const SendWorkspaceInvitationUseCase(this._repository);

  final WorkspaceDetailRepository _repository;

  Future<void> call(SendWorkspaceInvitationParams params) {
    return _repository.sendInvitation(
      workspaceId: params.workspaceId,
      email: params.email,
      role: params.role,
    );
  }
}

