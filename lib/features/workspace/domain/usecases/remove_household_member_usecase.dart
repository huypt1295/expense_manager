import 'package:expense_manager/features/workspace/domain/repositories/household_repository.dart';
import 'package:flutter_core/flutter_core.dart';

class RemoveHouseholdMemberParams {
  const RemoveHouseholdMemberParams({
    required this.householdId,
    required this.memberId,
  });

  final String householdId;
  final String memberId;
}

@injectable
class RemoveHouseholdMemberUseCase {
  const RemoveHouseholdMemberUseCase(this._repository);

  final HouseholdRepository _repository;

  Future<void> call(RemoveHouseholdMemberParams params) {
    return _repository.removeMember(
      householdId: params.householdId,
      memberId: params.memberId,
    );
  }
}

