import 'package:expense_manager/features/workspace/domain/repositories/workspace_detail_repository.dart';
import 'package:flutter_core/flutter_core.dart';

class DeleteHouseholdParams {
  const DeleteHouseholdParams({
    required this.userId,
    required this.workspaceId,
  });

  final String userId;
  final String workspaceId;
}

@injectable
class DeleteWorkspaceUseCase {
  const DeleteWorkspaceUseCase(this._repository);

  final WorkspaceDetailRepository _repository;

  Future<void> call(DeleteHouseholdParams params) {
    return _repository.deleteWorkspace(
      userId: params.userId,
      workspaceId: params.workspaceId,
    );
  }
}
