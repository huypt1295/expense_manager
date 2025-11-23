import 'dart:async';

import 'package:expense_manager/core/auth/current_user.dart';
import 'package:expense_manager/core/workspace/current_workspace.dart';
import 'package:expense_manager/core/workspace/workspace_context.dart';
import 'package:expense_manager/features/workspace/domain/usecases/ensure_personal_workspace_usecase.dart';
import 'package:flutter_core/flutter_core.dart';

@Singleton(as: CurrentWorkspace)
class CurrentWorkspaceController implements CurrentWorkspace {
  CurrentWorkspaceController(
    this._currentUser,
    this._ensurePersonalWorkspaceUseCase,
  ) {
    _userSubscription = _currentUser.watch().listen(_handleUserChanged);
    _handleUserChanged(_currentUser.now());
  }

  final CurrentUser _currentUser;
  final EnsurePersonalWorkspaceUseCase _ensurePersonalWorkspaceUseCase;

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

    if (snapshot == null) return;

    _ensurePersonalWorkspaceAndSetSnapshot(uid, snapshot);
  }

  Future<void> _ensurePersonalWorkspaceAndSetSnapshot(
    String uid,
    CurrentUserSnapshot snapshot,
  ) async {
    try {
      await _ensurePersonalWorkspaceUseCase();

      // Poll for member document existence with timeout
      await _waitForMemberDocument(uid);
    } catch (error) {
      print('Error ensuring personal workspace: $error');
    }

    final name = snapshot.displayName?.trim();
    final personal = CurrentWorkspaceSnapshot.personal(
      id: uid,
      name: name != null && name.isNotEmpty ? name : null,
    );

    if (_snapshot == null || _snapshot!.isPersonal) {
      _snapshot = personal;
      _controller.add(_snapshot);
      return;
    }

    if (_snapshot!.type == WorkspaceType.workspace) {
      _controller.add(_snapshot);
    }
  }

  Future<void> _waitForMemberDocument(String uid) async {
    const maxAttempts = 10;
    const delayBetweenAttempts = Duration(milliseconds: 200);

    for (var i = 0; i < maxAttempts; i++) {
      final exists = await _ensurePersonalWorkspaceUseCase.verifyMemberExists(
        workspaceId: uid,
        userId: uid,
      );

      if (exists) {
        print('Member document verified after ${i + 1} attempts');
        return;
      }

      if (i < maxAttempts - 1) {
        await Future.delayed(delayBetweenAttempts);
      }
    }

    print('Warning: Member document not verified after $maxAttempts attempts');
  }
}
