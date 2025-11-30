import 'package:expense_manager/features/workspace/domain/entities/workspace_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_core/flutter_core.dart';
import 'package:flutter_resource/flutter_resource.dart';

class SummaryGreetingWidget extends BaseStatelessWidget {
  const SummaryGreetingWidget({
    super.key,
    required this.username,
    this.workspace,
    this.onWorkspaceTap,
  });

  final String username;
  final WorkspaceEntity? workspace;
  final VoidCallback? onWorkspaceTap;

  @override
  Widget buildContent(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(S.current.greeting(username), style: TPTextStyle.titleM),
              const SizedBox(height: 4),
              Text(
                DateFormat.yMMMM().format(DateTime.now()),
                style: TPTextStyle.bodyS,
              ),
            ],
          ),
        ),
        if (workspace != null) ...[
          const SizedBox(width: 16),
          _WorkspaceIndicator(workspace: workspace!, onTap: onWorkspaceTap),
        ],
      ],
    );
  }
}

class _WorkspaceIndicator extends StatelessWidget {
  const _WorkspaceIndicator({required this.workspace, this.onTap});

  final WorkspaceEntity workspace;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final icon = workspace.isPersonal
        ? Icons.person_outline
        : Icons.group_outlined;
    final colorScheme = Theme.of(context).colorScheme;
    final textStyle = Theme.of(context).textTheme.bodyMedium;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: workspace.isPersonal ? null : onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
          ),
          constraints: const BoxConstraints(maxWidth: 180),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 20, color: colorScheme.onSurfaceVariant),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  workspace.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.right,
                  style: textStyle?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
