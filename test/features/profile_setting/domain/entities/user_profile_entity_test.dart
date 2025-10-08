import 'package:expense_manager/features/profile_setting/domain/entities/user_profile_entity.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  UserProfileEntity entity() => UserProfileEntity(
        uid: 'uid',
        email: 'user@example.com',
        displayName: 'User',
        address: 'Address',
        avatarUrl: 'avatar.png',
      );

  test('UserProfileEntity equality compares fields', () {
    expect(entity(), equals(entity()));
  });

  test('UserProfileEntity copyWith overrides fields', () {
    final updated = entity().copyWith(
      displayName: 'New User',
      address: 'New Address',
      avatarUrl: 'new.png',
    );

    expect(updated.displayName, 'New User');
    expect(updated.address, 'New Address');
    expect(updated.avatarUrl, 'new.png');
  });

  test('UserProfileEntity toJson exports map', () {
    final json = entity().toJson();
    expect(json['uid'], 'uid');
    expect(json['email'], 'user@example.com');
    expect(json['avatarUrl'], 'avatar.png');
  });
}
