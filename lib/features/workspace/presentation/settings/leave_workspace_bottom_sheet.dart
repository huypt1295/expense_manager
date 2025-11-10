import 'package:expense_manager/features/workspace/presentation/settings/widget/workspace_confirmation_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_resource/l10n/gen/l10n.dart';

class LeaveWorkspaceSheet extends StatelessWidget {
  const LeaveWorkspaceSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return WorkspaceConfirmationSheet(
      icon: Icons.logout_rounded,
      title: S.current.leave_workspace,
      message: S.current.leave_workspace_warning,
      confirmLabel: S.current.leave_workspace,
      onConfirm: () => Navigator.of(context).maybePop(true),
    );
  }
}
