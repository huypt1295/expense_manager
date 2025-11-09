import 'package:expense_manager/features/workspace/domain/entities/household_entity.dart';
import 'package:expense_manager/features/workspace/domain/repositories/household_repository.dart';
import 'package:flutter_core/flutter_core.dart';

class CreateHouseholdParams {
  const CreateHouseholdParams({
    required this.name,
    required this.currencyCode,
    required this.inviteEmails,
  });

  final String name;
  final String currencyCode;
  final List<String> inviteEmails;
}

@injectable
class CreateHouseholdUseCase {
  const CreateHouseholdUseCase(this._repository);

  final HouseholdRepository _repository;

  Future<HouseholdEntity> call(CreateHouseholdParams params) {
    return _repository.createHousehold(
      name: params.name,
      currencyCode: params.currencyCode,
      inviteEmails: params.inviteEmails,
    );
  }
}

