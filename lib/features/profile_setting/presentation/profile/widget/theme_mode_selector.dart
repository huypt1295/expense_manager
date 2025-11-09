import 'package:flutter/material.dart';
import 'package:flutter_common/flutter_common.dart';
import 'package:flutter_resource/flutter_resource.dart' show TPTextStyle;
import 'package:flutter_resource/l10n/gen/l10n.dart' show S;

class ThemeModeSelector extends StatelessWidget {
  const ThemeModeSelector({
    super.key,
    required this.themeMode,
    required this.onChanged,
  });

  final ThemeMode themeMode;
  final ValueChanged<ThemeMode> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final options = [
      _ThemeOption(
        mode: ThemeMode.light,
        label: S.current.theme_mode_light,
        icon: Icons.light_mode,
      ),
      _ThemeOption(
        mode: ThemeMode.dark,
        label: S.current.theme_mode_dark,
        icon: Icons.dark_mode,
      ),
      _ThemeOption(
        mode: ThemeMode.system,
        label: S.current.theme_mode_system,
        icon: Icons.settings,
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(themeMode.icon, color: context.tpColors.iconSub),
            const SizedBox(width: 8),
            Text(
              S.current.theme,
              style: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            for (var i = 0; i < options.length; i++) ...[
              Expanded(
                child: SizedBox(
                  width: double.infinity,
                  child: ChoiceChip(
                    label: Align(
                      alignment: Alignment.center,
                      child: Text(options[i].label),
                    ),
                    selected: options[i].mode == themeMode,
                    onSelected: (_) => onChanged(options[i].mode),
                    showCheckmark: false,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    side: BorderSide(color: context.tpColors.borderDefault),
                    shape: RoundedSuperellipseBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    backgroundColor: context.tpColors.surfaceSub,
                    selectedColor: context.tpColors.surfaceNeutralComponent,
                    labelStyle: TPTextStyle.bodyM.copyWith(
                      color: options[i].mode == themeMode
                          ? context.tpColors.textReverse
                          : context.tpColors.textSub,
                    ),
                  ),
                ),
              ),
              if (i != options.length - 1) const SizedBox(width: 12),
            ],
          ],
        ),
      ],
    );
  }
}

class _ThemeOption {
  const _ThemeOption({
    required this.mode,
    required this.label,
    required this.icon,
  });

  final ThemeMode mode;
  final String label;
  final IconData icon;
}
