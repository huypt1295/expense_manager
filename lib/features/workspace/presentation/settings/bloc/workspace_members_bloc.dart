import 'dart:async';

import 'package:expense_manager/features/workspace/domain/entities/workspace_invitation_entity.dart';
import 'package:expense_manager/features/workspace/domain/entities/workspace_member_entity.dart';
import 'package:expense_manager/features/workspace/domain/usecases/cancel_workspace_invitation_usecase.dart';
import 'package:expense_manager/features/workspace/domain/usecases/delete_workspace_usecase.dart';
import 'package:expense_manager/features/workspace/domain/usecases/remove_workspace_member_usecase.dart';
import 'package:expense_manager/features/workspace/domain/usecases/send_workspace_invitation_usecase.dart';
import 'package:expense_manager/features/workspace/domain/usecases/update_workspace_member_role_usecase.dart';
import 'package:expense_manager/features/workspace/domain/usecases/watch_workspace_invitations_usecase.dart';
import 'package:expense_manager/features/workspace/domain/usecases/watch_workspace_members_usecase.dart';
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
    this._deleteWorkspaceUseCase,
    this._sendInvitationUseCase,
    this._cancelInvitationUseCase,
  ) : super(const WorkspaceMembersState()) {
    on<WorkspaceMembersStarted>(_onStarted);
    on<WorkspaceMembersDataUpdated>(_onDataUpdated);
    on<WorkspaceMembersErrorOccurred>(_onErrorOccurred);
    on<WorkspaceMembersRoleChanged>(_onRoleChanged);
    on<WorkspaceMembersRemoved>(_onRemoved);
    on<DeleteWorkspaceEvent>(_deleteWorkspace);
    on<WorkspaceMembersInvitationSent>(_onInvitationSent);
    on<WorkspaceMembersInvitationCancelled>(_onInvitationCancelled);
  }

  final WatchWorkspaceMembersUseCase _watchMembersUseCase;
  final WatchWorkspaceInvitationsUseCase _watchInvitationsUseCase;
  final UpdateWorkspaceMemberRoleUseCase _updateMemberRoleUseCase;
  final RemoveWorkspaceMemberUseCase _removeMemberUseCase;
  final DeleteWorkspaceUseCase _deleteWorkspaceUseCase;
  final SendWorkspaceInvitationUseCase _sendInvitationUseCase;
  final CancelWorkspaceInvitationUseCase _cancelInvitationUseCase;

  StreamSubscription<List<WorkspaceMemberEntity>>? _membersSubscription;
  StreamSubscription<List<WorkspaceInvitationEntity>>? _invitationsSubscription;

  Future<void> _onStarted(
    WorkspaceMembersStarted event,
    Emitter<WorkspaceMembersState> emit,
  ) async {
    emit(
      state.copyWith(
        workspaceId: event.workspaceId,
        workspaceName: event.workspaceName,
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
          WatchWorkspaceMembersParams(event.workspaceId),
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
          WatchWorkspaceInvitationsParams(event.workspaceId),
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
      UpdateWorkspaceMemberRoleParams(
        workspaceId: state.workspaceId,
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
      RemoveWorkspaceMemberParams(
        workspaceId: state.workspaceId,
        memberId: event.memberId,
      ),
    );
  }

  Future<void> _deleteWorkspace(
    DeleteWorkspaceEvent event,
    Emitter<WorkspaceMembersState> emit,
  ) async {
    if (!state.isOwner) {
      return;
    }
    await _deleteWorkspaceUseCase(
      DeleteWorkspaceParams(
        userId: state.currentUserId,
        workspaceId: state.workspaceId,
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
      SendWorkspaceInvitationParams(
        workspaceId: state.workspaceId,
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
      CancelWorkspaceInvitationParams(
        workspaceId: state.workspaceId,
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
