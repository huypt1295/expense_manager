import 'package:expense_manager/core/config/app_config_cubit.dart';
import 'package:expense_manager/features/profile_setting/domain/entities/user_profile_entity.dart';
import 'package:expense_manager/features/profile_setting/presentation/profile/bloc/profile_bloc.dart';
import 'package:expense_manager/features/profile_setting/presentation/profile/bloc/profile_effect.dart';
import 'package:expense_manager/features/profile_setting/presentation/profile/bloc/profile_event.dart';
import 'package:expense_manager/features/profile_setting/presentation/profile/bloc/profile_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_core/flutter_core.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePage extends BaseStatefulWidget {
  const ProfilePage({super.key});

  @override
  BaseState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends BaseState<ProfilePage> {
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _imagePicker = ImagePicker();

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => tpGetIt.get<ProfileBloc>()..add(const ProfileStarted()),
      child: EffectBlocListener<ProfileState, ProfileEffect, ProfileBloc>(
        listener: (effect, emitUi) {
          if (effect is ProfileShowErrorEffect) {
            emitUi(
              (uiContext) => ScaffoldMessenger.of(uiContext).showSnackBar(
                SnackBar(content: Text(effect.message)),
              ),
            );
          }
        },
        child: BlocConsumer<ProfileBloc, ProfileState>(
          listenWhen: (previous, current) => previous.profile != current.profile,
          listener: (context, state) {
            final profile = state.profile;
            if (profile != null) {
              _nameController.text = profile.displayName ?? '';
              _addressController.text = profile.address ?? '';
            }
          },
          builder: (context, state) {
            final profile = state.profile;
            final theme = Theme.of(context);

            return Stack(
              children: [
                SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _ProfileHeader(
                        profile: profile,
                        isUploading: state.isUploadingAvatar,
                        onChangeAvatar: () => _pickAvatar(context),
                      ),
                      const SizedBox(height: 24),
                      Text('Profile details', style: theme.textTheme.titleMedium),
                      const SizedBox(height: 12),
                      TextField(
                        controller: _nameController,
                        decoration: const InputDecoration(labelText: 'Display name'),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: _addressController,
                        decoration: const InputDecoration(labelText: 'Address'),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: state.isSaving || profile == null
                              ? null
                              : () {
                                  context.read<ProfileBloc>().add(
                                        ProfileUpdateRequested(
                                          displayName: _nameController.text,
                                          address: _addressController.text,
                                        ),
                                      );
                                },
                          child: state.isSaving
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                )
                              : const Text('Save changes'),
                        ),
                      ),
                      const SizedBox(height: 32),
                      Text('Preferences', style: theme.textTheme.titleMedium),
                      const SizedBox(height: 16),
                      _LanguageSelector(),
                      const SizedBox(height: 16),
                      _ThemeSelector(),
                      const SizedBox(height: 32),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          icon: const Icon(Icons.logout),
                          label: const Text('Sign out'),
                          onPressed: state.isSaving
                              ? null
                              : () {
                                  context
                                      .read<ProfileBloc>()
                                      .add(const ProfileSignOutRequested());
                                },
                        ),
                      ),
                    ],
                  ),
                ),
                if (state.isLoading)
                  const Positioned.fill(
                    child: ColoredBox(
                      color: Colors.black12,
                      child: Center(child: CircularProgressIndicator()),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  Future<void> _pickAvatar(BuildContext context) async {
    final bloc = context.read<ProfileBloc>();
    final picked = await _imagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );
    if (picked == null) {
      return;
    }
    final bytes = await picked.readAsBytes();
    if (!mounted) return;
    bloc.add(
      ProfileAvatarSelected(
        bytes: bytes,
        fileName: picked.name,
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader({
    required this.profile,
    required this.isUploading,
    required this.onChangeAvatar,
  });

  final UserProfileEntity? profile;
  final bool isUploading;
  final VoidCallback onChangeAvatar;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final avatarUrl = profile?.avatarUrl;
    final initials = (profile?.displayName?.isNotEmpty ?? false)
        ? profile!.displayName!.trim().split(' ').map((p) => p.isNotEmpty ? p[0] : '').take(2).join().toUpperCase()
        : (profile?.email.isNotEmpty ?? false)
            ? profile!.email[0].toUpperCase()
            : '?';

    return Row(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            CircleAvatar(
              radius: 40,
              backgroundImage: (avatarUrl != null && avatarUrl.isNotEmpty)
                  ? NetworkImage(avatarUrl)
                  : null,
              child: (avatarUrl == null || avatarUrl.isEmpty)
                  ? Text(
                      initials,
                      style: theme.textTheme.headlineSmall,
                    )
                  : null,
            ),
            if (isUploading)
              const SizedBox(
                height: 80,
                width: 80,
                child: CircularProgressIndicator(),
              ),
          ],
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                profile?.displayName ?? 'Anonymous',
                style: theme.textTheme.titleLarge,
              ),
              Text(
                profile?.email ?? '',
                style: theme.textTheme.bodyMedium,
              ),
              const SizedBox(height: 8),
              OutlinedButton.icon(
                onPressed: isUploading ? null : onChangeAvatar,
                icon: const Icon(Icons.camera_alt_outlined),
                label: const Text('Change avatar'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _LanguageSelector extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final configCubit = context.read<ConfigCubit>();
    final currentLocale = context.watch<ConfigCubit>().state.locale.languageCode;
    return Column(
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
      ],
    );
  }
}

class _ThemeSelector extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeMode = context.watch<ConfigCubit>().state.themeMode;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Theme', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 12),
        SegmentedButton<ThemeMode>(
          segments: const <ButtonSegment<ThemeMode>>[
            ButtonSegment<ThemeMode>(value: ThemeMode.light, label: Text('Light')),
            ButtonSegment<ThemeMode>(value: ThemeMode.dark, label: Text('Dark')),
          ],
          selected: {themeMode},
          onSelectionChanged: (selection) {
            context.read<ConfigCubit>().toggleTheme(themeMode: selection.first);
          },
        ),
      ],
    );
  }
}
