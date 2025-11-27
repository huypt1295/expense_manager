import 'package:expense_manager/features/workspace/domain/entities/workspace_entity.dart';

abstract interface class WorkspaceRepository {
  Stream<List<WorkspaceEntity>> watchAll();
}
