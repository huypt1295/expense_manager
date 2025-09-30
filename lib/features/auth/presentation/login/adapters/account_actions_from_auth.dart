import 'package:expense_manager/core/auth/current_user.dart';
import 'package:expense_manager/features/auth/domain/usecases/sign_out_usecase.dart';
import 'package:flutter_core/flutter_core.dart';

class AccountActionsFromAuth implements AccountActions {
  AccountActionsFromAuth(this._signOutUseCase);

  final SignOutUseCase _signOutUseCase;

  @override
  Future<void> signOut() async {
    final result = await _signOutUseCase(NoParam());
    result.fold(ok: (_) {}, err: (failure) => throw failure);
  }
}
