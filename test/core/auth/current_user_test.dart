import 'package:expense_manager/core/auth/current_user.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('CurrentUserSnapshot equality compares fields', () {
    const a = CurrentUserSnapshot(
      uid: '1',
      displayName: 'Alice',
      email: 'alice@example.com',
      photoUrl: 'photo.png',
    );
    const b = CurrentUserSnapshot(
      uid: '1',
      displayName: 'Alice',
      email: 'alice@example.com',
      photoUrl: 'photo.png',
    );

    expect(a, equals(b));
    expect(a.hashCode, equals(b.hashCode));
  });

  test('isAuthenticated returns true when uid not empty', () {
    const snapshot = CurrentUserSnapshot(uid: '123');
    const emptySnapshot = CurrentUserSnapshot();

    expect(snapshot.isAuthenticated, isTrue);
    expect(emptySnapshot.isAuthenticated, isFalse);
  });
}
