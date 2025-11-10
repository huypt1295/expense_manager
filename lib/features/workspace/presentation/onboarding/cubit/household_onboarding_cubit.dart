import 'package:expense_manager/core/workspace/current_workspace.dart';
import 'package:expense_manager/core/workspace/workspace_context.dart';
import 'package:expense_manager/features/workspace/domain/usecases/create_household_usecase.dart';
import 'package:expense_manager/features/workspace/domain/usecases/ensure_personal_workspace_usecase.dart';
import 'package:expense_manager/features/workspace/presentation/onboarding/cubit/household_onboarding_state.dart';
import 'package:flutter_core/flutter_core.dart';

class HouseholdOnboardingCubit extends Cubit<HouseholdOnboardingState> {
  HouseholdOnboardingCubit(
    this._createHouseholdUseCase,
    this._ensurePersonalWorkspaceUseCase,
    this._currentWorkspace,
  ) : super(const HouseholdOnboardingState());

  final CreateHouseholdUseCase _createHouseholdUseCase;
  final EnsurePersonalWorkspaceUseCase _ensurePersonalWorkspaceUseCase;
  final CurrentWorkspace _currentWorkspace;

  void updateName(String value) {
    emit(state.copyWith(name: value, clearError: true));
  }

  void selectIcon(int index) {
    emit(state.copyWith(iconIndex: index, clearError: true));
  }

  Future<void> submit() async {
    if (state.isSubmitting) {
      return;
    }

    emit(state.copyWith(isSubmitting: true, clearError: true));
    try {
      await _ensurePersonalWorkspaceUseCase();
      final household = await _createHouseholdUseCase(
        CreateHouseholdParams(
          name: state.name,
          currencyCode: 'VND',
          inviteEmails: const <String>[],
        ),
      );
      await _currentWorkspace.select(
        CurrentWorkspaceSnapshot(
          id: household.id,
          type: WorkspaceType.household,
          name: household.name,
          role: 'owner',
        ),
      );
      emit(
        state.copyWith(
          isSubmitting: false,
          completedHouseholdId: household.id,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          isSubmitting: false,
          errorMessage: error is Failure ? error.message : error.toString(),
        ),
      );
    }
  }
}

