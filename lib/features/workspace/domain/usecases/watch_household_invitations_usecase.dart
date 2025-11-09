import 'package:expense_manager/features/workspace/domain/entities/household_invitation_entity.dart';
import 'package:expense_manager/features/workspace/domain/repositories/household_repository.dart';
import 'package:flutter_core/flutter_core.dart';

class WatchHouseholdInvitationsParams {
  const WatchHouseholdInvitationsParams(this.householdId);

  final String householdId;
}

@singleton
class WatchHouseholdInvitationsUseCase {
  const WatchHouseholdInvitationsUseCase(this._repository);

  final HouseholdRepository _repository;

  Stream<List<HouseholdInvitationEntity>> call(
    WatchHouseholdInvitationsParams params,
  ) {
    return _repository.watchInvitations(params.householdId);
  }
}

