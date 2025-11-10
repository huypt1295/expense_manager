import 'package:collection/collection.dart';
import 'package:expense_manager/core/config/app_config_cubit.dart';
import 'package:expense_manager/core/routing/app_router.dart';
import 'package:expense_manager/core/routing/app_routes.dart';
import 'package:expense_manager/features/profile_setting/presentation/profile/bloc/profile_bloc.dart';
import 'package:expense_manager/features/profile_setting/presentation/profile/bloc/profile_effect.dart';
import 'package:expense_manager/features/profile_setting/presentation/profile/bloc/profile_event.dart';
import 'package:expense_manager/features/profile_setting/presentation/profile/bloc/profile_state.dart';
import 'package:expense_manager/features/profile_setting/presentation/profile/widget/app_setting_section.dart';
import 'package:expense_manager/features/profile_setting/presentation/profile/widget/general_setting_section.dart';
import 'package:expense_manager/features/profile_setting/presentation/profile/widget/profile_header.dart';
import 'package:expense_manager/features/profile_setting/presentation/profile/widget/section_card.dart';
import 'package:expense_manager/features/profile_setting/presentation/profile/widget/signout_button.dart';
import 'package:expense_manager/features/profile_setting/presentation/profile/widget/support_section.dart';
import 'package:expense_manager/features/workspace/domain/entities/workspace_entity.dart';
import 'package:expense_manager/features/workspace/presentation/bloc/workspace_bloc.dart';
import 'package:expense_manager/features/workspace/presentation/bloc/workspace_state.dart';
import 'package:expense_manager/features/workspace/presentation/onboarding/household_onboarding_wizard.dart';
import 'package:expense_manager/features/workspace/presentation/settings/workspace_management_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_common/flutter_common.dart';
import 'package:flutter_core/flutter_core.dart';
import 'package:flutter_resource/flutter_resource.dart';
import 'package:flutter_resource/l10n/gen/l10n.dart';
import 'package:go_router/go_router.dart';

const _languageOptions = [
  _LanguageOption(code: 'vi', label: 'Ti\u1ebfng Vi\u1ec7t'),
  _LanguageOption(code: 'en', label: 'English'),
];

class ProfilePage extends BaseStatefulWidget {
  const ProfilePage({super.key});

  @override
  BaseState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends BaseState<ProfilePage> {
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();

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
              (uiContext) => ScaffoldMessenger.of(
                uiContext,
              ).showSnackBar(SnackBar(content: Text(effect.message))),
            );
          } else if (effect is ProfileSignedOutEffect) {
            tpGetIt.get<AppRouter>().allowLoginGuardBypassOnce();
            emitUi((uiContext) => uiContext.go(AppRoute.login.path));
          }
        },
        child: BlocConsumer<ProfileBloc, ProfileState>(
          listenWhen: (previous, current) =>
              previous.profile != current.profile,
          listener: (context, state) {
            final profile = state.profile;
            if (profile != null) {
              _nameController.text = profile.displayName ?? '';
              _addressController.text = profile.address ?? '';
            }
          },
          builder: (context, state) {
            final config = context.watch<ConfigCubit>().state;
            final languageCode = config.locale.languageCode;

            return _ProfileContent(
              state: state,
              languageLabel: _languageLabel(languageCode),
              onLanguageTap: () => _showLanguageSelector(context, languageCode),
              themeMode: config.themeMode,
              onThemeModeChanged: (mode) =>
                  context.read<ConfigCubit>().toggleTheme(themeMode: mode),
              onEditProfile: () => _showEditProfileSheet(context),
              onSelectSupport: (item) => _handleSupportTap(context, item),
              onSignOut: () => context.read<ProfileBloc>().add(
                const ProfileSignOutRequested(),
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> _showLanguageSelector(
    BuildContext context,
    String selectedCode,
  ) async {
    final cubit = context.read<ConfigCubit>();
    final result = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        final theme = Theme.of(sheetContext);
        final bottomInset = MediaQuery.of(sheetContext).viewInsets.bottom;

        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            bottom: bottomInset + 24,
          ),
          child: SectionCard(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Ch\u1ecdn ng\u00f4n ng\u1eef',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 16),
                ..._languageOptions.map(
                  (option) => SupportTile(
                    label: option.label,
                    trailing: option.code == selectedCode
                        ? const Icon(Icons.check_rounded)
                        : null,
                    onTap: () => Navigator.of(sheetContext).pop(option.code),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );

    if (result != null && result != selectedCode) {
      await cubit.changeLanguage(languageCode: result);
    }
  }

  Future<void> _showEditProfileSheet(BuildContext context) async {
    final bloc = context.read<ProfileBloc>();
    final profile = bloc.state.profile;
    if (profile == null) {
      return;
    }

    _nameController.text = profile.displayName ?? '';
    _addressController.text = profile.address ?? '';

    final shouldSave = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        final theme = Theme.of(sheetContext);
        final colors = sheetContext.tpColors;
        final bottomInset = MediaQuery.of(sheetContext).viewInsets.bottom;

        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            bottom: bottomInset + 24,
          ),
          child: SectionCard(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Ch\u1ec9nh s\u1eeda th\u00f4ng tin',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _nameController,
                  textCapitalization: TextCapitalization.words,
                  decoration: const InputDecoration(
                    labelText: 'T\u00ean hi\u1ec3n th\u1ecb',
                    hintText: 'Nh\u1eadp t\u00ean c\u1ee7a b\u1ea1n',
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _addressController,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: const InputDecoration(
                    labelText: '\u0110\u1ecba ch\u1ec9',
                    hintText:
                        'Th\u00eam \u0111\u1ecba ch\u1ec9 c\u1ee7a b\u1ea1n',
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.of(sheetContext).pop(false),
                        child: const Text('H\u1ee7y'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: FilledButton(
                        onPressed: () {
                          FocusScope.of(sheetContext).unfocus();
                          Navigator.of(sheetContext).pop(true);
                        },
                        style: FilledButton.styleFrom(
                          backgroundColor: theme.colorScheme.primary,
                          foregroundColor: colors.textReverse,
                        ),
                        child: const Text('L\u01b0u'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );

    if (shouldSave == true) {
      final trimmedAddress = _addressController.text.trim();
      bloc.add(
        ProfileUpdateRequested(
          displayName: _nameController.text.trim(),
          address: trimmedAddress.isEmpty ? null : trimmedAddress,
        ),
      );
    }
  }

  void _handleSupportTap(BuildContext context, SupportItem item) {
    final label = switch (item) {
      SupportItem.helpCenter => 'Trung t\u00e2m tr\u1ee3 gi\u00fap',
      SupportItem.terms => '\u0110i\u1ec1u kho\u1ea3n d\u1ecbch v\u1ee5',
      SupportItem.privacy => 'Ch\u00ednh s\u00e1ch b\u1ea3o m\u1eadt',
    };

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '$label \u0111ang \u0111\u01b0\u1ee3c ph\u00e1t tri\u1ec3n',
        ),
      ),
    );
  }

  String _languageLabel(String code) {
    return _languageOptions
        .firstWhere(
          (option) => option.code == code,
          orElse: () => const _LanguageOption(code: 'en', label: 'English'),
        )
        .label;
  }
}

class _ProfileContent extends StatelessWidget {
  const _ProfileContent({
    required this.state,
    required this.languageLabel,
    required this.onLanguageTap,
    required this.themeMode,
    required this.onThemeModeChanged,
    required this.onEditProfile,
    required this.onSelectSupport,
    required this.onSignOut,
  });

  final ProfileState state;
  final String languageLabel;
  final VoidCallback onLanguageTap;
  final ThemeMode themeMode;
  final ValueChanged<ThemeMode> onThemeModeChanged;
  final VoidCallback onEditProfile;
  final ValueChanged<SupportItem> onSelectSupport;
  final VoidCallback onSignOut;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = context.tpColors;
    final profile = state.profile;
    final bottomPadding = MediaQuery.of(context).padding.bottom;
    final WorkspaceState workspaceState = context.watch<WorkspaceBloc>().state;
    final WorkspaceEntity? householdWorkspace = workspaceState.workspaces
        .firstWhereOrNull((workspace) => !workspace.isPersonal);
    final String workspaceLabel = householdWorkspace?.name ?? S.current.only_me;

    return ColoredBox(
      color: colors.backgroundMain,
      child: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 150,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    theme.colorScheme.primary,
                    _colorWithOpacity(theme.colorScheme.primary, 0.8),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
          ),
          SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(16, 24, 16, 32 + bottomPadding + 56),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  S.current.profile,
                  style: theme.textTheme.headlineMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 24),
                ProfileHeader(
                  profile: profile,
                  isUploading: state.isUploadingAvatar,
                  onEditProfile: profile == null ? null : onEditProfile,
                ),
                const SizedBox(height: 24),
                AppSettingsSection(
                  workspaceLabel: workspaceLabel,
                  onWorkspaceTap: () {
                    final target = householdWorkspace;
                    if (target == null) {
                      HouseholdOnboardingWizard.show(context);
                      return;
                    }
                    WorkspaceManagementSheet.show(
                      context,
                      householdId: target.id,
                      householdName: target.name,
                      currentRole: target.role,
                    );
                  },
                ),
                const SizedBox(height: 24),
                GeneralSettingsSection(
                  languageLabel: languageLabel,
                  onLanguageTap: onLanguageTap,
                  themeMode: themeMode,
                  onThemeModeChanged: onThemeModeChanged,
                ),
                const SizedBox(height: 24),
                SupportSection(onItemTap: onSelectSupport),
                const SizedBox(height: 24),
                SignOutButton(
                  isBusy: state.isSaving,
                  onPressed: state.isSaving ? null : onSignOut,
                ),
              ],
            ),
          ),
          if (state.isLoading || state.isSaving)
            const Positioned.fill(
              child: ColoredBox(
                color: Colors.black12,
                child: Center(child: CircularProgressIndicator()),
              ),
            ),
        ],
      ),
    );
  }
}

class _LanguageOption {
  const _LanguageOption({required this.code, required this.label});

  final String code;
  final String label;
}

Color _colorWithOpacity(Color color, double opacity) {
  final double alpha = (color.a * opacity).clamp(0.0, 1.0);
  return color.withValues(alpha: alpha);
}
