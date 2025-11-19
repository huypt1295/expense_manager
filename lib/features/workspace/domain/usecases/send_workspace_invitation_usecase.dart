import 'package:expense_manager/features/workspace/domain/repositories/workspace_detail_repository.dart';
import 'package:flutter_core/flutter_core.dart';

class SendHouseholdInvitationParams {
  const SendHouseholdInvitationParams({
    required this.householdId,
    required this.email,
    required this.role,
  });

  final String householdId;
  final String email;
  final String role;
}

@injectable
class SendWorkspaceInvitationUseCase {
  const SendWorkspaceInvitationUseCase(this._repository);

  final WorkspaceDetailRepository _repository;

  Future<void> call(SendHouseholdInvitationParams params) {
    return _repository.sendInvitation(
      householdId: params.householdId,
      email: params.email,
      role: params.role,
    );
  }
}

