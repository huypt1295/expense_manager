import 'package:expense_manager/features/workspace/domain/entities/workspace_entity.dart';
import 'package:expense_manager/features/workspace/presentation/bloc/workspace_bloc.dart';
import 'package:expense_manager/features/workspace/presentation/bloc/workspace_effect.dart';
import 'package:expense_manager/features/workspace/presentation/bloc/workspace_event.dart';
import 'package:expense_manager/features/workspace/presentation/bloc/workspace_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_core/flutter_core.dart';

class WorkspaceSelector extends StatelessWidget {
  const WorkspaceSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return EffectBlocListener<WorkspaceState, WorkspaceEffect, WorkspaceBloc>(
      listener: (effect, ui) {
        if (effect is WorkspaceShowLostAccessEffect) {
          ui.showSnackBar(
            SnackBar(
              content: Text(
                'Ban khong con quyen truy cap ${effect.workspaceName}.',
              ),
            ),
          );
        } else if (effect is WorkspaceShowErrorEffect) {
          ui.showSnackBar(SnackBar(content: Text(effect.message)));
        }
      },
      child: BlocBuilder<WorkspaceBloc, WorkspaceState>(
        buildWhen: (previous, current) =>
            previous.workspaces != current.workspaces ||
            previous.selectedWorkspaceId != current.selectedWorkspaceId ||
            previous.isLoading != current.isLoading,
        builder: (context, state) {
          if (state.workspaces.isEmpty) {
            return const SizedBox.shrink();
          }

          final selectedId = state.selectedWorkspaceId ??
              (state.workspaces.isNotEmpty ? state.workspaces.first.id : null);

          return DecoratedBox(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: selectedId,
                  isExpanded: true,
                  borderRadius: BorderRadius.circular(16),
                  items: state.workspaces
                      .map(
                        (workspace) => DropdownMenuItem<String>(
                          value: workspace.id,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                workspace.isPersonal
                                    ? Icons.person_outline
                                    : Icons.group_outlined,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      workspace.name,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      _roleLabel(context, workspace),
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.copyWith(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSurfaceVariant,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                      .toList(growable: false),
                  onChanged: state.isLoading
                      ? null
                      : (value) {
                          if (value != null &&
                              value != state.selectedWorkspaceId) {
                            context
                                .read<WorkspaceBloc>()
                                .add(WorkspaceSelectionRequested(value));
                          }
                        },
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  String _roleLabel(BuildContext context, WorkspaceEntity workspace) {
    if (workspace.isPersonal) {
      return 'Chi minh ban';
    }
    switch (workspace.role.toLowerCase()) {
      case 'owner':
        return 'Vai tro: Chu so huu';
      case 'editor':
        return 'Vai tro: Co the chinh sua';
      case 'viewer':
        return 'Vai tro: Chi xem';
      default:
        final role = workspace.role.trim();
        if (role.isEmpty) {
          return 'Vai tro: Thanh vien';
        }
        return 'Vai tro: ${role[0].toUpperCase()}${role.substring(1)}';
    }
  }
}
