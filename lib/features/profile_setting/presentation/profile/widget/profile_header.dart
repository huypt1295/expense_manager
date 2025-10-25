import 'package:expense_manager/features/profile_setting/domain/entities/user_profile_entity.dart';
import 'package:expense_manager/features/profile_setting/presentation/profile/bloc/profile_bloc.dart';
import 'package:expense_manager/features/profile_setting/presentation/profile/bloc/profile_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_common/flutter_common.dart';
import 'package:flutter_core/flutter_core.dart';
import 'package:image_picker/image_picker.dart';

class ProfileHeader extends BaseStatefulWidget {
  const ProfileHeader({
    super.key,
    required this.profile,
    required this.isUploading,
    this.onEditProfile,
  });

  final UserProfileEntity? profile;
  final bool isUploading;
  final VoidCallback? onEditProfile;

  @override
  State<ProfileHeader> createState() => _ProfileHeaderState();
}

class _ProfileHeaderState extends BaseState<ProfileHeader> {
  final _imagePicker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = context.tpColors;
    final profile = widget.profile;
    final displayName = _resolveDisplayName(profile);
    final email = profile?.email ?? '';
    final address = profile?.address;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colors.surfaceMain,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: context.tpColors.borderDefault),
        boxShadow: [
          BoxShadow(
            color: _colorWithOpacity(colors.shadowMain, 0.12),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _AvatarButton(
            profile: profile,
            isUploading: widget.isUploading,
            onPickAvatar: () => _pickAvatar(context),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            displayName,
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            email,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: colors.textSub,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (widget.onEditProfile != null)
                      TextButton(
                        onPressed: widget.onEditProfile,
                        style: TextButton.styleFrom(
                          visualDensity: VisualDensity.compact,
                          padding: EdgeInsets.zero,
                          foregroundColor: theme.colorScheme.primary,
                        ),
                        child: const Text('S\u1eeda'),
                      ),
                  ],
                ),
                if (address != null && address.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        size: 18,
                        color: colors.iconNeutral,
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          address,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: colors.textSub,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _pickAvatar(BuildContext context) async {
    if (widget.isUploading) return;

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
    bloc.add(ProfileAvatarSelected(bytes: bytes, fileName: picked.name));
  }

  String _resolveDisplayName(UserProfileEntity? profile) {
    final raw = profile?.displayName?.trim();
    if (raw != null && raw.isNotEmpty) {
      return raw;
    }
    final email = profile?.email ?? '';
    if (email.isNotEmpty) {
      return email.split('@').first;
    }
    return 'Ng\u01b0\u1eddi d\u00f9ng';
  }
}

class _AvatarButton extends StatelessWidget {
  const _AvatarButton({
    required this.profile,
    required this.isUploading,
    required this.onPickAvatar,
  });

  final UserProfileEntity? profile;
  final bool isUploading;
  final VoidCallback onPickAvatar;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = context.tpColors;
    final avatarUrl = profile?.avatarUrl;
    final hasAvatar = avatarUrl != null && avatarUrl.isNotEmpty;
    final initials = _buildInitials(profile);

    return Stack(
      clipBehavior: Clip.none,
      children: [
        CircleAvatar(
          radius: 46,
          backgroundColor: colors.surfaceNeutralComponent,
          backgroundImage: hasAvatar ? NetworkImage(avatarUrl) : null,
          child: !hasAvatar
              ? Text(
                  initials,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    color: colors.textReverse,
                    fontWeight: FontWeight.w700,
                  ),
                )
              : null,
        ),
        Positioned(
          bottom: -4,
          right: -4,
          child: Material(
            color: Colors.transparent,
            shape: const CircleBorder(),
            child: InkWell(
              onTap: isUploading ? null : onPickAvatar,
              customBorder: const CircleBorder(),
              child: Ink(
                height: 36,
                width: 36,
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary,
                  shape: BoxShape.circle,
                  border: Border.all(color: colors.surfaceMain, width: 2),
                ),
                child: Center(
                  child: isUploading
                      ? const SizedBox(
                          height: 16,
                          width: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        )
                      : const Icon(
                          Icons.camera_alt_outlined,
                          size: 18,
                          color: Colors.white,
                        ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  String _buildInitials(UserProfileEntity? profile) {
    final displayName = profile?.displayName?.trim();
    if (displayName != null && displayName.isNotEmpty) {
      final parts = displayName
          .split(RegExp(r'\s+'))
          .where((part) => part.isNotEmpty);
      final initials = parts
          .take(2)
          .map((part) => part[0].toUpperCase())
          .join();
      if (initials.isNotEmpty) {
        return initials;
      }
    }

    final email = profile?.email ?? '';
    if (email.isNotEmpty) {
      return email[0].toUpperCase();
    }

    return '?';
  }
}

Color _colorWithOpacity(Color color, double opacity) {
  final double alpha = (color.a * opacity).clamp(0.0, 1.0);
  return color.withValues(alpha: alpha);
}
