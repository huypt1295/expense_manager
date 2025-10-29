import 'package:expense_manager/features/workspace/presentation/bloc/workspace_bloc.dart';
import 'package:expense_manager/features/workspace/presentation/bloc/workspace_event.dart';
import 'package:expense_manager/features/workspace/presentation/bloc/workspace_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WorkspaceSelector extends StatelessWidget {
  const WorkspaceSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WorkspaceBloc, WorkspaceState>(
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
                          children: [
                            Icon(
                              workspace.isPersonal
                                  ? Icons.person_outline
                                  : Icons.group_outlined,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                workspace.name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
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
                        if (value != null && value != state.selectedWorkspaceId) {
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
    );
  }
}
