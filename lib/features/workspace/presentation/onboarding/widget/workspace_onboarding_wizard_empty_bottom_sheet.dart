import 'package:flutter/material.dart';
import 'package:flutter_common/flutter_common.dart'
    show CommonBottomSheet, ContextX;
import 'package:flutter_core/flutter_core.dart';
import 'package:flutter_resource/flutter_resource.dart';

class WorkspaceOnboardingWizardEmptyBottomSheet extends StatelessWidget {
  const WorkspaceOnboardingWizardEmptyBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return CommonBottomSheet(
      title: 'Workspace',
      child: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: CircleAvatar(
                radius: 36,
                backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                child: Icon(
                  Icons.group_outlined,
                  size: 36,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              S.current.workspace_wizard_title,
              style: TPTextStyle.titleM.copyWith(
                color: context.tpColors.textMain,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              S.current.workspace_wizard_description,
              style: TPTextStyle.bodyM.copyWith(
                color: context.tpColors.textSub,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: () => context.pop(true),
                icon: const Icon(Icons.add),
                label: Text(S.current.create_workspace),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
