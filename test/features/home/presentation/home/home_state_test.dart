import 'package:expense_manager/core/domain/entities/user_entity.dart';
import 'package:expense_manager/features/home/presentation/home/bloc/home_state.dart';
import 'package:flutter_test/flutter_test.dart';

UserEntity _user(String id) => UserEntity(id: id, email: '$id@example.com');

void main() {
  test('HomeLoaded equality compares users', () {
    final a = HomeLoaded(user: _user('a'));
    final b = HomeLoaded(user: _user('a'));
    expect(a, equals(b));
  });

  test('HomeLoaded copyWith replaces user when provided', () {
    final original = HomeLoaded(user: _user('a'));
    final updated = original.copyWith(user: _user('b'));

    expect(updated.user.id, 'b');
    expect(original.user.id, 'a');
  });

  test('HomeError stores message in props', () {
    const error = HomeError('oops');
    expect(error.props.single, 'oops');
  });
}
