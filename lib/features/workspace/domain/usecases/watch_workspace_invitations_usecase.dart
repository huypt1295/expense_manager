import 'package:expense_manager/features/workspace/domain/entities/workspace_invitation_entity.dart';
import 'package:expense_manager/features/workspace/domain/repositories/workspace_detail_repository.dart';
import 'package:flutter_core/flutter_core.dart';

class WatchHouseholdInvitationsParams {
  const WatchHouseholdInvitationsParams(this.householdId);

  final String householdId;
}

@singleton
class WatchWorkspaceInvitationsUseCase {
  const WatchWorkspaceInvitationsUseCase(this._repository);

  final WorkspaceDetailRepository _repository;

  Stream<List<WorkspaceInvitationEntity>> call(
    WatchHouseholdInvitationsParams params,
  ) {
    return _repository.watchInvitations(params.householdId);
  }
}

