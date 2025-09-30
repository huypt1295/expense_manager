import 'package:expense_manager/features/profile_setting/domain/entities/user_profile_entity.dart';
import 'package:flutter_core/flutter_core.dart';

class ProfileState extends BaseBlocState with EquatableMixin {
  const ProfileState({
    this.profile,
    this.isLoading = false,
    this.isSaving = false,
    this.isUploadingAvatar = false,
    this.errorMessage,
  });

  final UserProfileEntity? profile;
  final bool isLoading;
  final bool isSaving;
  final bool isUploadingAvatar;
  final String? errorMessage;

  ProfileState copyWith({
    UserProfileEntity? profile,
    bool? isLoading,
    bool? isSaving,
    bool? isUploadingAvatar,
    bool clearError = false,
    String? errorMessage,
  }) {
    return ProfileState(
      profile: profile ?? this.profile,
      isLoading: isLoading ?? this.isLoading,
      isSaving: isSaving ?? this.isSaving,
      isUploadingAvatar: isUploadingAvatar ?? this.isUploadingAvatar,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => <Object?>[
        profile,
        isLoading,
        isSaving,
        isUploadingAvatar,
        errorMessage,
      ];
}
