import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_common/flutter_common.dart';
import 'package:flutter_resource/l10n/gen/l10n.dart';

class WorkspaceManagementActionButton extends StatelessWidget {
  const WorkspaceManagementActionButton({
    super.key,
    required this.isOwner,
    required this.onLeave,
    required this.onDelete,
  });

  final bool isOwner;
  final VoidCallback onLeave;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: FilledButton.icon(
            onPressed: onLeave,
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              backgroundColor: context.tpColors.surfaceWarning,
              foregroundColor: context.tpColors.textNegative,
            ),
            label: Text(S.current.leave_workspace),
            icon: Icon(CupertinoIcons.square_arrow_right),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: FilledButton.icon(
            onPressed: isOwner ? onDelete : null,
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              backgroundColor: context.tpColors.surfaceNegative,
              foregroundColor: context.tpColors.textNegative,
            ),
            label: Text(S.current.remove_workspace),
            icon: Icon(CupertinoIcons.trash),
          ),
        ),
      ],
    );
  }
}
