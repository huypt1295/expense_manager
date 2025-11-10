import 'package:expense_manager/features/workspace/domain/repositories/household_repository.dart';
import 'package:flutter_core/flutter_core.dart';

class CancelHouseholdInvitationParams {
  const CancelHouseholdInvitationParams({
    required this.householdId,
    required this.invitationId,
  });

  final String householdId;
  final String invitationId;
}

@injectable
class CancelHouseholdInvitationUseCase {
  const CancelHouseholdInvitationUseCase(this._repository);

  final HouseholdRepository _repository;

  Future<void> call(CancelHouseholdInvitationParams params) {
    return _repository.cancelInvitation(
      householdId: params.householdId,
      invitationId: params.invitationId,
    );
  }
}

