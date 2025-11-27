import 'package:expense_manager/features/workspace/domain/entities/workspace_member_entity.dart';
import 'package:expense_manager/features/workspace/domain/repositories/workspace_detail_repository.dart';
import 'package:flutter_core/flutter_core.dart';

class WatchWorkspaceMembersParams {
  const WatchWorkspaceMembersParams(this.workspaceId);

  final String workspaceId;
}

@singleton
class WatchWorkspaceMembersUseCase {
  const WatchWorkspaceMembersUseCase(this._repository);

  final WorkspaceDetailRepository _repository;

  Stream<List<WorkspaceMemberEntity>> call(WatchWorkspaceMembersParams params) {
    return _repository.watchMembers(params.workspaceId);
  }
}

