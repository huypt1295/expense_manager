import 'package:flutter/material.dart';
import 'package:flutter_core/flutter_core.dart';
import 'package:flutter_resource/flutter_resource.dart';
import 'package:expense_manager/core/config/app_config_cubit.dart';

class ProfilePage extends BaseStatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget buildContent(BuildContext context) {
    final configCubit = context.read<ConfigCubit>();
    final currentLocale =
        context.watch<ConfigCubit>().state.locale.languageCode;
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
                configCubit.changeLanguage(languageCode: locale);
              },
            ),
            const SizedBox(height: 24),
            Text('Theme', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            SegmentedButton<ThemeMode>(
              segments: const <ButtonSegment<ThemeMode>>[
                ButtonSegment<ThemeMode>(
                    value: ThemeMode.light, label: Text('Light')),
                ButtonSegment<ThemeMode>(
                    value: ThemeMode.dark, label: Text('Dark')),
              ],
              selected: {context.watch<ConfigCubit>().state.themeMode},
              onSelectionChanged: (selection) {
                final theme = selection.first;
                context.read<ConfigCubit>().toggleTheme(themeMode: theme);
              },
            ),
          ],
        ),
      ),
    );
  }
}
