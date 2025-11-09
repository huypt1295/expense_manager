import 'package:flutter/material.dart';
import 'package:flutter_resource/l10n/gen/l10n.dart';

import '../../../../workspace/presentation/onboarding/household_onboarding_wizard.dart';

class HouseholdOnboardingBanner extends StatelessWidget {
  const HouseholdOnboardingBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Card(
      color: colorScheme.secondaryContainer,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => HouseholdOnboardingWizard.show(context),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(
                Icons.home_work_outlined,
                color: colorScheme.onSecondaryContainer,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      S.current.create_workspace,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSecondaryContainer,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      S.current.workspace_banner_content,
                      style: TextStyle(
                        color: colorScheme.onSecondaryContainer,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              FilledButton(
                onPressed: () => HouseholdOnboardingWizard.show(context),
                child: Text(S.current.get_started),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
