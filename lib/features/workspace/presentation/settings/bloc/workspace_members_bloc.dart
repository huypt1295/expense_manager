import 'dart:async';

import 'package:expense_manager/features/workspace/domain/entities/household_invitation_entity.dart';
import 'package:expense_manager/features/workspace/domain/entities/household_member_entity.dart';
import 'package:expense_manager/features/workspace/domain/usecases/cancel_household_invitation_usecase.dart';
import 'package:expense_manager/features/workspace/domain/usecases/remove_household_member_usecase.dart';
import 'package:expense_manager/features/workspace/domain/usecases/send_household_invitation_usecase.dart';
import 'package:expense_manager/features/workspace/domain/usecases/update_household_member_role_usecase.dart';
import 'package:expense_manager/features/workspace/domain/usecases/watch_household_invitations_usecase.dart';
import 'package:expense_manager/features/workspace/domain/usecases/watch_household_members_usecase.dart';
import 'package:expense_manager/features/workspace/presentation/settings/bloc/workspace_members_event.dart';
import 'package:expense_manager/features/workspace/presentation/settings/bloc/workspace_members_state.dart';
import 'package:flutter_core/flutter_core.dart';

@injectable
class WorkspaceMembersBloc
    extends Bloc<WorkspaceMembersEvent, WorkspaceMembersState> {
  WorkspaceMembersBloc(
    this._watchMembersUseCase,
    this._watchInvitationsUseCase,
    this._updateMemberRoleUseCase,
    this._removeMemberUseCase,
    this._sendInvitationUseCase,
    this._cancelInvitationUseCase,
  ) : super(const WorkspaceMembersState()) {
    on<WorkspaceMembersStarted>(_onStarted);
    on<WorkspaceMembersDataUpdated>(_onDataUpdated);
    on<WorkspaceMembersErrorOccurred>(_onErrorOccurred);
    on<WorkspaceMembersRoleChanged>(_onRoleChanged);
    on<WorkspaceMembersRemoved>(_onRemoved);
    on<WorkspaceMembersInvitationSent>(_onInvitationSent);
    on<WorkspaceMembersInvitationCancelled>(_onInvitationCancelled);
  }

  final WatchHouseholdMembersUseCase _watchMembersUseCase;
  final WatchHouseholdInvitationsUseCase _watchInvitationsUseCase;
  final UpdateHouseholdMemberRoleUseCase _updateMemberRoleUseCase;
  final RemoveHouseholdMemberUseCase _removeMemberUseCase;
  final SendHouseholdInvitationUseCase _sendInvitationUseCase;
  final CancelHouseholdInvitationUseCase _cancelInvitationUseCase;

  StreamSubscription<List<WorkspaceMemberEntity>>? _membersSubscription;
  StreamSubscription<List<HouseholdInvitationEntity>>? _invitationsSubscription;

  Future<void> _onStarted(
    WorkspaceMembersStarted event,
    Emitter<WorkspaceMembersState> emit,
  ) async {
    emit(
      state.copyWith(
        householdId: event.householdId,
        householdName: event.householdName,
        currentUserId: event.currentUserId,
        currentUserRole: event.currentUserRole,
        isLoading: true,
        clearError: true,
      ),
    );

    await _membersSubscription?.cancel();
    await _invitationsSubscription?.cancel();

    _membersSubscription =
        _watchMembersUseCase(
          WatchHouseholdMembersParams(event.householdId),
        ).listen(
          (members) {
            add(
              WorkspaceMembersDataUpdated(
                members: members,
                invitations: state.invitations,
              ),
            );
          },
          onError: (error, stackTrace) {
            add(WorkspaceMembersErrorOccurred(error.toString()));
          },
        );

    _invitationsSubscription =
        _watchInvitationsUseCase(
          WatchHouseholdInvitationsParams(event.householdId),
        ).listen(
          (invitations) {
            add(
              WorkspaceMembersDataUpdated(
                members: state.members,
                invitations: invitations,
              ),
            );
          },
          onError: (error, stackTrace) {
            add(WorkspaceMembersErrorOccurred(error.toString()));
          },
        );
  }

  void _onDataUpdated(
    WorkspaceMembersDataUpdated event,
    Emitter<WorkspaceMembersState> emit,
  ) {
    emit(
      state.copyWith(
        members: event.members,
        invitations: event.invitations,
        isLoading: false,
      ),
    );
  }

  void _onErrorOccurred(
    WorkspaceMembersErrorOccurred event,
    Emitter<WorkspaceMembersState> emit,
  ) {
    emit(state.copyWith(isLoading: false, errorMessage: event.message));
  }

  Future<void> _onRoleChanged(
    WorkspaceMembersRoleChanged event,
    Emitter<WorkspaceMembersState> emit,
  ) async {
    if (!state.isOwner) {
      return;
    }
    await _updateMemberRoleUseCase(
      UpdateHouseholdMemberRoleParams(
        householdId: state.householdId,
        memberId: event.memberId,
        role: event.role,
      ),
    );
  }

  Future<void> _onRemoved(
    WorkspaceMembersRemoved event,
    Emitter<WorkspaceMembersState> emit,
  ) async {
    if (!state.isOwner) {
      return;
    }
    await _removeMemberUseCase(
      RemoveHouseholdMemberParams(
        householdId: state.householdId,
        memberId: event.memberId,
      ),
    );
  }

  Future<void> _onInvitationSent(
    WorkspaceMembersInvitationSent event,
    Emitter<WorkspaceMembersState> emit,
  ) async {
    final email = event.email.trim();
    if (email.isEmpty || !state.isOwner) {
      return;
    }
    await _sendInvitationUseCase(
      SendHouseholdInvitationParams(
        householdId: state.householdId,
        email: email,
        role: event.role,
      ),
    );
  }

  Future<void> _onInvitationCancelled(
    WorkspaceMembersInvitationCancelled event,
    Emitter<WorkspaceMembersState> emit,
  ) async {
    if (!state.isOwner && !state.isEditor) {
      return;
    }
    await _cancelInvitationUseCase(
      CancelHouseholdInvitationParams(
        householdId: state.householdId,
        invitationId: event.invitationId,
      ),
    );
  }

  @override
  Future<void> close() async {
    await _membersSubscription?.cancel();
    await _invitationsSubscription?.cancel();
    return super.close();
  }
}
