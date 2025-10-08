import 'dart:typed_data';

import 'package:expense_manager/features/profile_setting/domain/entities/user_profile_entity.dart';
import 'package:expense_manager/features/profile_setting/presentation/profile/bloc/profile_event.dart';
import 'package:flutter_test/flutter_test.dart';

UserProfileEntity _profile(String uid) => UserProfileEntity(
      uid: uid,
      email: 'user@example.com',
      displayName: 'User',
    );

void main() {
  test('ProfileProfileChanged exposes profile in props', () {
    final event = ProfileProfileChanged(_profile('uid'));
    expect(event.props.single, _profile('uid'));
  });

  test('ProfileUpdateRequested exposes optional fields', () {
    const event = ProfileUpdateRequested(displayName: 'Alice', address: 'Road');
    expect(event.props, equals(['Alice', 'Road']));
  });

  test('ProfileAvatarSelected includes bytes and optional filename', () {
    final bytes = Uint8List.fromList([1, 2, 3]);
    final event = ProfileAvatarSelected(bytes: bytes, fileName: 'avatar.png');

    expect(event.props, equals([bytes, 'avatar.png']));
  });

  test('ProfileFailed stores error message', () {
    const event = ProfileFailed('error');
    expect(event.props.single, 'error');
  });
}
