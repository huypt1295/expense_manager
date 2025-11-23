import 'package:expense_manager/features/workspace/presentation/onboarding/cubit/workspace_onboarding_cubit.dart';
import 'package:expense_manager/features/workspace/presentation/onboarding/widget/workspace_onboarding_wizard_create_bottom_sheet.dart';
import 'package:expense_manager/features/workspace/presentation/onboarding/widget/workspace_onboarding_wizard_empty_bottom_sheet.dart';
import 'package:expense_manager/features/workspace/presentation/settings/workspace_management_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_core/flutter_core.dart';

class WorkspaceOnboardingWizard {
  const WorkspaceOnboardingWizard._();

  static Future<void> show(BuildContext context) async {
    final shouldCreate = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const WorkspaceOnboardingWizardEmptyBottomSheet(),
    );

    if (shouldCreate != true) {
      return;
    }

    if (context.mounted) {
      final creationResult =
          await showModalBottomSheet<WorkspaceCreationResult>(
            context: context,
            isScrollControlled: true,
            useSafeArea: true,
            backgroundColor: Colors.transparent,
            builder: (_) => BlocProvider(
              create: (_) => tpGetIt.get<WorkspaceOnboardingCubit>(),
              child: const WorkspaceOnboardingWizardCreateBottomSheet(),
            ),
          );

      if (creationResult == null) {
        return;
      }

      if (context.mounted) {
        await WorkspaceManagementSheet.show(
          context,
          workspaceId: creationResult.workspaceId,
          workspaceName: creationResult.workspaceName,
          currentRole: 'owner',
        );
      }
    }
  }
}
