import 'dart:async';

import 'package:expense_manager/core/auth/current_user.dart';
import 'package:expense_manager/core/workspace/current_workspace.dart';
import 'package:expense_manager/core/workspace/workspace_context.dart';
import 'package:expense_manager/features/workspace/application/current_workspace_controller.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeCurrentUser implements CurrentUser {
  _FakeCurrentUser(this._snapshot) {
    _controller = StreamController<CurrentUserSnapshot?>.broadcast(sync: true);
    _controller.add(_snapshot);
  }

  CurrentUserSnapshot? _snapshot;
  late final StreamController<CurrentUserSnapshot?> _controller;

  @override
  CurrentUserSnapshot? now() => _snapshot;

  @override
  Stream<CurrentUserSnapshot?> watch() => _controller.stream;

  void emit(CurrentUserSnapshot? snapshot) {
    _snapshot = snapshot;
    _controller.add(snapshot);
  }

  Future<void> close() => _controller.close();
}

void main() {
  group('CurrentWorkspaceController', () {
    late _FakeCurrentUser currentUser;
    late CurrentWorkspaceController controller;

    setUp(() {
      currentUser = _FakeCurrentUser(
        const CurrentUserSnapshot(uid: 'uid-123', displayName: 'Taylor'),
      );
      controller = CurrentWorkspaceController(currentUser);
    });

    tearDown(() async {
      await currentUser.close();
      await controller.dispose();
    });

    test('initial snapshot defaults to personal workspace', () {
      final snapshot = controller.now();
      expect(snapshot, isNotNull);
      expect(snapshot!.id, 'uid-123');
      expect(snapshot.isPersonal, isTrue);
    });

    test('select updates current snapshot and notifies listeners', () async {
      final updates = <CurrentWorkspaceSnapshot?>[];
      final subscription = controller.watch().listen(updates.add);

      const household = CurrentWorkspaceSnapshot(
        id: 'household-1',
        type: WorkspaceType.household,
        name: 'Family',
        role: 'owner',
      );

      await controller.select(household);
      await pumpEventQueue();

      expect(controller.now()!.id, 'household-1');
      expect(updates.last!.id, 'household-1');

      await subscription.cancel();
    });

    test('clears snapshot when user signs out', () async {
      currentUser.emit(null);
      await pumpEventQueue();

      expect(controller.now(), isNull);
    });
  });
}
