import 'package:expense_manager/features/workspace/domain/entities/workspace_member_entity.dart';
import 'package:expense_manager/features/workspace/domain/repositories/workspace_detail_repository.dart';
import 'package:flutter_core/flutter_core.dart';

class WatchHouseholdMembersParams {
  const WatchHouseholdMembersParams(this.householdId);

  final String householdId;
}

@singleton
class WatchWorkspaceMembersUseCase {
  const WatchWorkspaceMembersUseCase(this._repository);

  final WorkspaceDetailRepository _repository;

  Stream<List<WorkspaceMemberEntity>> call(WatchHouseholdMembersParams params) {
    return _repository.watchMembers(params.householdId);
  }
}

