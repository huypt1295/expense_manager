import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_common/flutter_common.dart';
import 'package:flutter_resource/flutter_resource.dart';

class WorkspaceInviteForm extends StatelessWidget {
  const WorkspaceInviteForm({
    super.key,
    required this.controller,
    required this.selectedRole,
    required this.onRoleChanged,
    required this.onSend,
  });

  final TextEditingController controller;
  final String selectedRole;
  final ValueChanged<String> onRoleChanged;
  final VoidCallback onSend;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTitle(context),
        const SizedBox(height: 8),
        _buildInviteMail(),
        const SizedBox(height: 12),
        _buildRoleSelector(context),
      ],
    );
  }

  Widget _buildTitle(BuildContext context) {
    return Text(
      S.current.invite_members,
      style: TPTextStyle.titleS.copyWith(color: context.tpColors.textMain),
    );
  }

  Widget _buildInviteMail() {
    return CommonTextFormField(
      controller: controller,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.send,
      hintText: S.current.invite_members_hint,
      onFieldSubmitted: (_) => onSend(),
    );
  }

  Widget _buildRoleSelector(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        PopupMenuButton<int>(
          tooltip: '',
          color: context.tpColors.surfaceMain,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: context.tpColors.borderDefault, width: 1),
          ),
          itemBuilder: (context) => [
            PopupMenuItem<int>(
              value: 0,
              child: Row(
                children: [
                  Icon(
                    Icons.edit_outlined,
                    color: context.tpColors.iconNeutral,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "editor",
                    style: TPTextStyle.bodyM.copyWith(
                      color: context.tpColors.textSub,
                    ),
                  ),
                ],
              ),
            ),
            PopupMenuDivider(color: context.tpColors.borderDefault),
            PopupMenuItem<int>(
              value: 1,
              child: Row(
                children: [
                  Icon(
                    Icons.remove_red_eye,
                    color: context.tpColors.iconNeutral,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "viewer",
                    style: TPTextStyle.bodyM.copyWith(
                      color: context.tpColors.textSub,
                    ),
                  ),
                ],
              ),
            ),
          ],
          onSelected: (item) => {
            onRoleChanged(item == 0 ? 'editor' : 'viewer'),
          },
          child: Container(
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: context.tpColors.surfaceNeutralComponent2,
            ),
            child: Row(
              children: [
                Text(selectedRole),
                const SizedBox(width: 8),
                Icon(
                  CupertinoIcons.chevron_down,
                  color: context.tpColors.iconMain,
                  size: 14,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),
        FilledButton.icon(
          onPressed: onSend,
          icon: const Icon(CupertinoIcons.person_add_solid),
          label: Text(S.current.send_invite),
        ),
      ],
    );
  }
}
