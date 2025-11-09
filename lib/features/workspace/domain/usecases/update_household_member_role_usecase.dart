import 'package:expense_manager/features/workspace/domain/repositories/household_repository.dart';
import 'package:flutter_core/flutter_core.dart';

class UpdateHouseholdMemberRoleParams {
  const UpdateHouseholdMemberRoleParams({
    required this.householdId,
    required this.memberId,
    required this.role,
  });

  final String householdId;
  final String memberId;
  final String role;
}

@injectable
class UpdateHouseholdMemberRoleUseCase {
  const UpdateHouseholdMemberRoleUseCase(this._repository);

  final HouseholdRepository _repository;

  Future<void> call(UpdateHouseholdMemberRoleParams params) {
    return _repository.updateMemberRole(
      householdId: params.householdId,
      memberId: params.memberId,
      role: params.role,
    );
  }
}

