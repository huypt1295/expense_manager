import 'dart:typed_data';

import 'package:expense_manager/features/profile_setting/domain/entities/user_profile_entity.dart';
import 'package:flutter_core/flutter_core.dart';

abstract class ProfileEvent extends BaseBlocEvent with EquatableMixin {
  const ProfileEvent();

  @override
  List<Object?> get props => <Object?>[];
}

class ProfileStarted extends ProfileEvent {
  const ProfileStarted();
}

class ProfileProfileChanged extends ProfileEvent {
  const ProfileProfileChanged(this.profile);

  final UserProfileEntity profile;

  @override
  List<Object?> get props => <Object?>[profile];
}

class ProfileUpdateRequested extends ProfileEvent {
  const ProfileUpdateRequested({
    this.displayName,
    this.address,
  });

  final String? displayName;
  final String? address;

  @override
  List<Object?> get props => <Object?>[displayName, address];
}

class ProfileAvatarSelected extends ProfileEvent {
  const ProfileAvatarSelected({
    required this.bytes,
    this.fileName,
  });

  final Uint8List bytes;
  final String? fileName;

  @override
  List<Object?> get props => <Object?>[bytes, fileName];
}

class ProfileSignOutRequested extends ProfileEvent {
  const ProfileSignOutRequested();
}

class ProfileFailed extends ProfileEvent {
  const ProfileFailed(this.message);

  final String message;

  @override
  List<Object?> get props => <Object?>[message];
}
