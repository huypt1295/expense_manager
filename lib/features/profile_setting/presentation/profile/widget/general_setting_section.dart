import 'package:expense_manager/features/profile_setting/presentation/profile/widget/section_card.dart';
import 'package:expense_manager/features/profile_setting/presentation/profile/widget/setting_tile.dart' show SettingTile;
import 'package:expense_manager/features/profile_setting/presentation/profile/widget/theme_mode_selector.dart' show ThemeModeSelector;
import 'package:flutter/material.dart';
import 'package:flutter_resource/l10n/gen/l10n.dart';

class GeneralSettingsSection extends StatelessWidget {
  const GeneralSettingsSection({super.key,
    required this.languageLabel,
    required this.onLanguageTap,
    required this.themeMode,
    required this.onThemeModeChanged,
  });

  final String languageLabel;
  final VoidCallback onLanguageTap;
  final ThemeMode themeMode;
  final ValueChanged<ThemeMode> onThemeModeChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            S.current.setting,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 16),
          SettingTile(
            icon: Icons.language_rounded,
            title: S.current.language,
            trailing: languageLabel,
            onTap: onLanguageTap,
          ),
          const SizedBox(height: 20),
          const Divider(height: 1),
          const SizedBox(height: 20),
          ThemeModeSelector(
            themeMode: themeMode,
            onChanged: onThemeModeChanged,
          ),
        ],
      ),
    );
  }
}