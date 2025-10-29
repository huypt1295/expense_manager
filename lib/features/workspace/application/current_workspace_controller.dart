import 'dart:async';

import 'package:expense_manager/core/auth/current_user.dart';
import 'package:expense_manager/core/workspace/current_workspace.dart';
import 'package:expense_manager/core/workspace/workspace_context.dart';
import 'package:flutter_core/flutter_core.dart';

@Singleton(as: CurrentWorkspace)
class CurrentWorkspaceController implements CurrentWorkspace {
  CurrentWorkspaceController(this._currentUser) {
    _userSubscription = _currentUser.watch().listen(_handleUserChanged);
    _handleUserChanged(_currentUser.now());
  }

  final CurrentUser _currentUser;

  final StreamController<CurrentWorkspaceSnapshot?> _controller =
      StreamController<CurrentWorkspaceSnapshot?>.broadcast(sync: true);

  StreamSubscription<CurrentUserSnapshot?>? _userSubscription;

  CurrentWorkspaceSnapshot? _snapshot;

  @override
  CurrentWorkspaceSnapshot? now() => _snapshot;

  @override
  Stream<CurrentWorkspaceSnapshot?> watch() => _controller.stream;

  @override
  Future<void> select(CurrentWorkspaceSnapshot? snapshot) async {
    _snapshot = snapshot;
    _controller.add(_snapshot);
  }

  Future<void> dispose() async {
    await _userSubscription?.cancel();
    await _controller.close();
  }

  void _handleUserChanged(CurrentUserSnapshot? snapshot) {
    final uid = snapshot?.uid;
    if (uid == null || uid.isEmpty) {
      _snapshot = null;
      _controller.add(_snapshot);
      return;
    }

    final name = snapshot?.displayName?.trim();
    final personal = CurrentWorkspaceSnapshot.personal(
      id: uid,
      name: name != null && name.isNotEmpty ? name : null,
    );

    if (_snapshot == null || _snapshot!.isPersonal) {
      _snapshot = personal;
      _controller.add(_snapshot);
      return;
    }

    if (_snapshot!.type == WorkspaceType.household) {
      _controller.add(_snapshot);
    }
  }
}
