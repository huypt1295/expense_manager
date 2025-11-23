import 'package:expense_manager/features/workspace/domain/entities/workspace_detail_entity.dart';
import 'package:expense_manager/features/workspace/domain/repositories/workspace_detail_repository.dart';
import 'package:flutter_core/flutter_core.dart';

class CreateWorkspaceParams {
  const CreateWorkspaceParams({
    required this.name,
    required this.currencyCode,
    required this.inviteEmails,
  });

  final String name;
  final String currencyCode;
  final List<String> inviteEmails;
}

@injectable
class CreateWorkspaceUseCase {
  const CreateWorkspaceUseCase(this._repository);

  final WorkspaceDetailRepository _repository;

  Future<WorkspaceDetailEntity> call(CreateWorkspaceParams params) {
    return _repository.createWorkspace(
      name: params.name,
      currencyCode: params.currencyCode,
      inviteEmails: params.inviteEmails,
    );
  }
}

