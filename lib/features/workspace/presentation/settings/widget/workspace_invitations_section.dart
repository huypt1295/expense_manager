import 'package:expense_manager/features/workspace/domain/entities/workspace_invitation_entity.dart';
import 'package:expense_manager/features/workspace/presentation/settings/bloc/workspace_members_bloc.dart';
import 'package:expense_manager/features/workspace/presentation/settings/bloc/workspace_members_event.dart';
import 'package:expense_manager/features/workspace/presentation/settings/bloc/workspace_members_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_core/flutter_core.dart';

class WorkspaceInvitationsSection extends StatelessWidget {
  const WorkspaceInvitationsSection({super.key, required this.state});

  final WorkspaceMembersState state;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Lời mời', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 12),
        Column(
          children: state.invitations
              .map(
                (invitation) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _InvitationTile(
                    invitation: invitation,
                    canCancel: state.isOwner || state.isEditor,
                  ),
                ),
              )
              .toList(growable: false),
        ),
      ],
    );
  }
}

class _InvitationTile extends StatelessWidget {
  const _InvitationTile({required this.invitation, required this.canCancel});

  final WorkspaceInvitationEntity invitation;
  final bool canCancel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final statusLabel = switch (invitation.status) {
      WorkspaceInvitationStatus.pending => 'Dang cho',
      WorkspaceInvitationStatus.accepted => 'Da chap nhan',
      WorkspaceInvitationStatus.revoked => 'Da thu hoi',
      WorkspaceInvitationStatus.expired => 'Het han',
    };

    return Material(
      color: theme.colorScheme.surfaceVariant.withValues(alpha: 0.6),
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            const Icon(Icons.mark_email_read_outlined),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(invitation.email, style: theme.textTheme.titleSmall),
                  const SizedBox(height: 4),
                  Text(
                    'Vai trò: ${_roleDisplay(invitation.role)}',
                    style: theme.textTheme.bodySmall,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Trạng thái: $statusLabel',
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            if (canCancel &&
                invitation.status == WorkspaceInvitationStatus.pending)
              TextButton(
                onPressed: () {
                  context.read<WorkspaceMembersBloc>().add(
                    WorkspaceMembersInvitationCancelled(invitation.id),
                  );
                },
                child: const Text('Hủy'),
              ),
          ],
        ),
      ),
    );
  }

  String _roleDisplay(String raw) {
    switch (raw.toLowerCase()) {
      case 'owner':
        return 'Owner';
      case 'editor':
        return 'Editable';
      default:
        return 'View only';
    }
  }

}
