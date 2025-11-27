import 'package:expense_manager/features/workspace/domain/entities/workspace_member_entity.dart';
import 'package:expense_manager/features/workspace/presentation/settings/bloc/workspace_members_bloc.dart';
import 'package:expense_manager/features/workspace/presentation/settings/bloc/workspace_members_event.dart';
import 'package:expense_manager/features/workspace/presentation/settings/bloc/workspace_members_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_common/flutter_common.dart';
import 'package:flutter_core/flutter_core.dart';
import 'package:flutter_resource/flutter_resource.dart';

class WorkspaceMembersInfo extends StatelessWidget {
  const WorkspaceMembersInfo({super.key, required this.state});

  final WorkspaceMembersState state;

  @override
  Widget build(BuildContext context) {
    final members = state.members;
    final memberCount = members.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "${S.current.members} ($memberCount)",
          style: TPTextStyle.titleS.copyWith(color: context.tpColors.textMain),
        ),
        const SizedBox(height: 8),
        if (members.isEmpty)
          Text(
            S.current.empty_members_message,
            style: TPTextStyle.bodyM.copyWith(color: context.tpColors.textMain),
          )
        else
          Column(
            children: members
                .map((member) => _MemberTile(member: member, state: state))
                .toList(growable: false),
          ),
      ],
    );
  }
}

class _MemberTile extends StatelessWidget {
  const _MemberTile({required this.member, required this.state});

  final WorkspaceMemberEntity member;
  final WorkspaceMembersState state;

  @override
  Widget build(BuildContext context) {
    final isCurrentUser = member.userId == state.currentUserId;
    final canManage = state.isOwner && !isCurrentUser;
    final menuSettingShowing = canManage;

    return Container(
      padding: const EdgeInsets.all(
        12,
      ).copyWith(right: menuSettingShowing ? 0 : 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: context.tpColors.surfaceSub,
      ),
      child: Row(
        children: [
          _buildAvatar(context),
          const SizedBox(width: 12),
          _buildMemberInfo(context),
          const SizedBox(width: 12),
          _buildMemberRole(context),
          if (canManage) _buildRoleMenuSetting(context),
        ],
      ),
    );
  }

  Widget _buildAvatar(BuildContext context) {
    return CircleAvatar(
      radius: 24,
      backgroundColor: context.tpColors.surfaceNeutralComponent,
      child: Text(
        _avatarInitial(member),
        style: TPTextStyle.titleL.copyWith(color: context.tpColors.textReverse),
      ),
    );
  }

  Widget _buildMemberInfo(BuildContext context) {
    final subtitle = member.email.isEmpty ? null : member.email;
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            member.displayName.isEmpty
                ? (member.email.isEmpty ? 'Người dùng' : member.email)
                : member.displayName,
            style: TPTextStyle.titleM.copyWith(
              color: context.tpColors.textMain,
            ),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: TPTextStyle.bodyS.copyWith(
                color: context.tpColors.textSub,
              ),
            ),
          ],
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildMemberRole(BuildContext context) {
    final roleLabel = _roleDisplay(member.role);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        color: context.tpColors.surfaceNeutralComponent.withValues(alpha: 0.12),
      ),
      child: Text(
        roleLabel,
        style: TPTextStyle.captionM.copyWith(
          color: context.tpColors.textNeutral,
        ),
      ),
    );
  }

  CommonPopupMenu<String> _buildRoleMenuSetting(BuildContext context) {
    return CommonPopupMenu<String>(
      onSelected: (value) {
        if (value == 'remove') {
          context.read<WorkspaceMembersBloc>().add(
            WorkspaceMembersRemoved(member.userId),
          );
        } else {
          context.read<WorkspaceMembersBloc>().add(
            WorkspaceMembersRoleChanged(memberId: member.userId, role: value),
          );
        }
      },
      itemBuilder: (context) => <PopupMenuEntry<String>>[
        if (member.role.toLowerCase() != 'editor')
          const PopupMenuItem<String>(
            value: 'editor',
            child: Text('Đặt vai trò Editable'),
          ),
        if (member.role.toLowerCase() != 'viewer')
          const PopupMenuItem<String>(
            value: 'viewer',
            child: Text('Đặt vai trò View only'),
          ),
        const PopupMenuDivider(),
        const PopupMenuItem<String>(
          value: 'remove',
          child: Text('Gỡ thành viên'),
        ),
      ],
    );
  }

  String _avatarInitial(WorkspaceMemberEntity member) {
    final source = member.displayName.isNotEmpty
        ? member.displayName
        : member.email;
    if (source.isEmpty) {
      return '?';
    }
    return source.trim()[0].toUpperCase();
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
