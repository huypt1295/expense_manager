import 'dart:async';

import 'package:expense_manager/core/auth/current_user.dart';
import 'package:expense_manager/features/auth/presentation/login/bloc/auth_bloc.dart';
import 'package:expense_manager/features/auth/presentation/login/bloc/auth_state.dart';
import 'package:flutter_core/flutter_core.dart';

@Singleton(as: CurrentUser)
class CurrentUserFromAuthBloc implements CurrentUser {
  CurrentUserFromAuthBloc(this._authBloc);

  final AuthBloc _authBloc;

  @override
  CurrentUserSnapshot? now() {
    return _snapshotFromState(_authBloc.state);
  }

  @override
  Stream<CurrentUserSnapshot?> watch() async* {
    CurrentUserSnapshot? previous = now();
    yield previous;
    await for (final state in _authBloc.stream) {
      final snapshot = _snapshotFromState(state);
      if (_equals(previous, snapshot)) {
        continue;
      }
      previous = snapshot;
      yield snapshot;
    }
  }

  CurrentUserSnapshot? _snapshotFromState(AuthState state) {
    final user = state.user;
    if (user == null) {
      return null;
    }
    return CurrentUserSnapshot(
      uid: user.id,
      displayName: user.displayName,
      email: user.email,
      photoUrl: user.photoURL,
    );
  }

  bool _equals(CurrentUserSnapshot? a, CurrentUserSnapshot? b) {
    if (identical(a, b)) return true;
    if (a == null || b == null) {
      return a == b;
    }
    return a == b;
  }
}
