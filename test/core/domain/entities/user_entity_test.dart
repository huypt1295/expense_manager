import 'package:expense_manager/core/domain/entities/user_entity.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('UserEntity equality compares all fields', () {
    final a = UserEntity(id: '1', email: 'user@example.com');
    final b = UserEntity(id: '1', email: 'user@example.com');
    expect(a, equals(b));
  });

  test('UserEntity copyWith overrides provided properties', () {
    final user = UserEntity(id: '1', email: 'user@example.com');
    final updated = user.copyWith(email: 'new@example.com');

    expect(updated.email, 'new@example.com');
    expect(updated.id, '1');
  });

  test('toJson exports all fields', () {
    final user = UserEntity(
      id: '1',
      email: 'user@example.com',
      displayName: 'User',
      photoURL: 'photo.png',
      providerId: 'google',
      createdAt: 'now',
      updatedAt: 'later',
    );

    final json = user.toJson();
    expect(json['displayName'], 'User');
    expect(json['providerId'], 'google');
  });
}
