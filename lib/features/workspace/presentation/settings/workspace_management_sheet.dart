import 'package:expense_manager/core/auth/current_user.dart';
import 'package:expense_manager/features/workspace/presentation/settings/bloc/workspace_members_bloc.dart';
import 'package:expense_manager/features/workspace/presentation/settings/bloc/workspace_members_event.dart';
import 'package:expense_manager/features/workspace/presentation/settings/bloc/workspace_members_state.dart';
import 'package:expense_manager/features/workspace/presentation/settings/delete_workspace_bottom_sheet.dart';
import 'package:expense_manager/features/workspace/presentation/settings/leave_workspace_bottom_sheet.dart';
import 'package:expense_manager/features/workspace/presentation/settings/widget/workspace_info_card.dart';
import 'package:expense_manager/features/workspace/presentation/settings/widget/workspace_invitations_section.dart';
import 'package:expense_manager/features/workspace/presentation/settings/widget/workspace_invite_form.dart';
import 'package:expense_manager/features/workspace/presentation/settings/widget/workspace_management_action_button.dart';
import 'package:expense_manager/features/workspace/presentation/settings/widget/workspace_members_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_common/flutter_common.dart';
import 'package:flutter_core/flutter_core.dart';
import 'package:flutter_resource/l10n/gen/l10n.dart';

class WorkspaceManagementSheet extends StatefulWidget {
  const WorkspaceManagementSheet({
    super.key,
    required this.workspaceId,
    required this.workspaceName,
    required this.currentRole,
  });

  final String workspaceId;
  final String workspaceName;
  final String currentRole;

  static Future<void> show(
    BuildContext context, {
    required String workspaceId,
    required String workspaceName,
    required String currentRole,
  }) async {
    final currentUser = tpGetIt.get<CurrentUser>().now();
    final currentUserId = currentUser?.uid ?? '';

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BlocProvider(
        create: (_) => tpGetIt.get<WorkspaceMembersBloc>()
          ..add(
            WorkspaceMembersStarted(
              workspaceId: workspaceId,
              workspaceName: workspaceName,
              currentUserId: currentUserId,
              currentUserRole: currentRole,
            ),
          ),
        child: WorkspaceManagementSheet(
          workspaceId: workspaceId,
          workspaceName: workspaceName,
          currentRole: currentRole,
        ),
      ),
    );
  }

  @override
  State<WorkspaceManagementSheet> createState() =>
      _WorkspaceManagementSheetState();
}

class _WorkspaceManagementSheetState extends State<WorkspaceManagementSheet> {
  final TextEditingController _inviteController = TextEditingController();
  String _selectedRole = 'editor';

  @override
  void dispose() {
    _inviteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<WorkspaceMembersBloc, WorkspaceMembersState>(
      listenWhen: (previous, current) =>
          previous.errorMessage != current.errorMessage,
      listener: (context, state) {
        final message = state.errorMessage;
        if (message != null && message.isNotEmpty) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(message)));
        }
      },
      child: CommonBottomSheet(
        title: S.current.workspace,
        heightFactor: 0.7,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            const SizedBox(height: 8),
            Expanded(
              child: BlocBuilder<WorkspaceMembersBloc, WorkspaceMembersState>(
                builder: (context, state) {
                  if (state.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  return SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildWorkspaceInfo(state),
                        const SizedBox(height: 24),
                        _buildWorkspaceMembersInfo(state),
                        if (state.invitations.isNotEmpty) ...[
                          const SizedBox(height: 24),
                          _buildInvitationSection(state),
                        ],
                        if (state.isOwner) ...[
                          const SizedBox(height: 24),
                          _buildInviteForm(context),
                        ],
                        const SizedBox(height: 32),
                        _buildActionButton(state, context),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWorkspaceInfo(WorkspaceMembersState state) {
    return WorkspaceInfoCard(name: state.workspaceName, onEditNameTap: () {});
  }

  Widget _buildWorkspaceMembersInfo(WorkspaceMembersState state) =>
      WorkspaceMembersInfo(state: state);

  Widget _buildInvitationSection(WorkspaceMembersState state) =>
      WorkspaceInvitationsSection(state: state);

  Widget _buildInviteForm(BuildContext context) {
    return WorkspaceInviteForm(
      controller: _inviteController,
      selectedRole: _selectedRole,
      onRoleChanged: (role) => setState(() => _selectedRole = role),
      onSend: () => _sendInvite(context, _selectedRole),
    );
  }

  Widget _buildActionButton(WorkspaceMembersState state, BuildContext context) {
    return WorkspaceManagementActionButton(
      isOwner: state.isOwner,
      onLeave: () => _showLeaveSheet(context),
      onDelete: state.isOwner
          ? () => _showDeleteSheet(context, state.workspaceName)
          : null,
    );
  }

  void _sendInvite(BuildContext context, String role) {
    final email = _inviteController.text.trim();
    if (email.isEmpty) {
      return;
    }
    context.read<WorkspaceMembersBloc>().add(
      WorkspaceMembersInvitationSent(email, role: role),
    );
    _inviteController.clear();
  }

  Future<void> _showLeaveSheet(BuildContext context) async {
    final confirmed = await showModalBottomSheet<bool>(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const LeaveWorkspaceSheet(),
    );
    if (confirmed == true && context.mounted) {
      context.pop();
    }
  }

  Future<void> _showDeleteSheet(
    BuildContext context,
    String workspaceName,
  ) async {
    final confirmed = await showModalBottomSheet<bool>(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => DeleteWorkspaceSheet(
        workspaceName: workspaceName,
        onDelete: () {
          context.pop();
          context.read<WorkspaceMembersBloc>().add(DeleteWorkspaceEvent());
        },
      ),
    );
    if (confirmed == true && context.mounted) {
      context.pop();
    }
  }
}
