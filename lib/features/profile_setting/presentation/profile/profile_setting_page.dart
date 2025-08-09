import 'package:flutter/material.dart';
import 'package:flutter_core/flutter_core.dart';
import 'package:flutter_resource/flutter_resource.dart';
import 'package:expense_manager/core/config/app_config_cubit.dart';

class ProfilePage extends BaseStatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget buildContent(BuildContext context) {
    final configCubit = context.read<ConfigCubit>();
    final currentLocale = context.watch<ConfigCubit>().state.localize;
    return Scaffold(
      appBar: AppBar(title: Text(S.of(context).appName)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Language', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            SegmentedButton<String>(
              segments: const <ButtonSegment<String>>[
                ButtonSegment<String>(value: 'en', label: Text('English')),
                ButtonSegment<String>(value: 'vi', label: Text('Tiếng Việt')),
              ],
              selected: {currentLocale},
              onSelectionChanged: (selection) {
                final locale = selection.first;
                configCubit.changeLanguage(locale);
              },
            ),
            const SizedBox(height: 24),
            Text('Theme', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            SegmentedButton<ThemeType>(
              segments: const <ButtonSegment<ThemeType>>[
                ButtonSegment<ThemeType>(
                    value: ThemeType.light, label: Text('Light')),
                ButtonSegment<ThemeType>(
                    value: ThemeType.dark, label: Text('Dark')),
              ],
              selected: {context.watch<ConfigCubit>().state.themeType},
              onSelectionChanged: (selection) {
                final theme = selection.first;
                context.read<ConfigCubit>().updateConfig(context
                    .read<ConfigCubit>()
                    .state
                    .copyWith(themeType: theme));
              },
            ),
          ],
        ),
      ),
    );
  }
}
