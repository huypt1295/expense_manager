import 'package:expense_manager/core/domain/entities/user_entity.dart';
import 'package:expense_manager/features/auth/presentation/login/bloc/auth_event.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('AuthEventStateChanged compares user equality', () {
    final user = UserEntity(id: '1', email: 'test@example.com');
    final a = AuthEventStateChanged(user);
    final b = AuthEventStateChanged(user);
    expect(a, equals(b));
  });

  test('AuthEventStreamFailed stores message', () {
    const event = AuthEventStreamFailed('error');
    expect(event.props.single, 'error');
  });

  test('sign-in/sign-out events are const and equal', () {
    expect(const AuthEventSignInWithGoogle(), const AuthEventSignInWithGoogle());
    expect(const AuthEventSignInWithFacebook(),
        const AuthEventSignInWithFacebook());
    expect(const AuthEventSignOut(), const AuthEventSignOut());
  });
}
