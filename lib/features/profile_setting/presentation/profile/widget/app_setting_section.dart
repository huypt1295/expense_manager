import 'package:expense_manager/features/profile_setting/presentation/profile/widget/section_card.dart';
import 'package:expense_manager/features/profile_setting/presentation/profile/widget/setting_tile.dart'
    show SettingTile;
import 'package:flutter/material.dart';
import 'package:flutter_resource/l10n/gen/l10n.dart';

class AppSettingsSection extends StatelessWidget {
  const AppSettingsSection({
    super.key,
    required this.onWorkspaceTap,
    required this.workspaceLabel,
  });

  final VoidCallback onWorkspaceTap;
  final String workspaceLabel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            S.current.app_setting,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 16),
          SettingTile(
            icon: Icons.supervisor_account_outlined,
            title: S.current.workspace,
            trailing: workspaceLabel,
            onTap: onWorkspaceTap,
          ),
        ],
      ),
    );
  }
}
