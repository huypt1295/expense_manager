import 'package:expense_manager/features/workspace/presentation/settings/widget/workspace_confirmation_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_common/flutter_common.dart';
import 'package:flutter_resource/l10n/gen/l10n.dart';

class DeleteWorkspaceSheet extends StatefulWidget {
  const DeleteWorkspaceSheet({super.key, required this.workspaceName, required this.onDelete});

  final String workspaceName;
  final VoidCallback onDelete;

  @override
  State<DeleteWorkspaceSheet> createState() => _DeleteWorkspaceSheetState();
}

class _DeleteWorkspaceSheetState extends State<DeleteWorkspaceSheet> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final expected = widget.workspaceName.trim();
    final input = _controller.text.trim();
    final canConfirm = input.isNotEmpty && input == expected;

    return WorkspaceConfirmationSheet(
      icon: Icons.delete_forever_rounded,
      title: S.current.remove_workspace,
      message: S.current.this_action_cannot_be_undone,
      confirmLabel: S.current.delete,
      extra: Padding(
        padding: const EdgeInsets.only(top: 16),
        child: CommonTextFormField(
          controller: _controller,
          hintText: S.current.enter_workspace_name,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return S.current.name_not_matching;
            }
            return null;
          },
          onChanged: (_) => setState(() {}),
        ),
      ),
      onConfirm: true ? widget.onDelete : null,
    );
  }
}
