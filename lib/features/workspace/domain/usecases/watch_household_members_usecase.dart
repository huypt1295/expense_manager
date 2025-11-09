import 'package:expense_manager/features/workspace/domain/entities/household_member_entity.dart';
import 'package:expense_manager/features/workspace/domain/repositories/household_repository.dart';
import 'package:flutter_core/flutter_core.dart';

class WatchHouseholdMembersParams {
  const WatchHouseholdMembersParams(this.householdId);

  final String householdId;
}

@singleton
class WatchHouseholdMembersUseCase {
  const WatchHouseholdMembersUseCase(this._repository);

  final HouseholdRepository _repository;

  Stream<List<WorkspaceMemberEntity>> call(WatchHouseholdMembersParams params) {
    return _repository.watchMembers(params.householdId);
  }
}

