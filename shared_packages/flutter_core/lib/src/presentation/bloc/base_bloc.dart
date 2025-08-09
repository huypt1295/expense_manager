import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_core/flutter_core.dart';

abstract class BaseBloc<E extends BaseBlocEvent, S extends BaseBlocState>
    extends BaseBlocDelegate<E, S> {
  BaseBloc(super.initialState);
}

abstract class BaseBlocDelegate<E extends BaseBlocEvent,
    S extends BaseBlocState> extends Bloc<E, S> {
  BaseBlocDelegate(super.initialState);

  @override
  void add(E event) {
    if (!isClosed) {
      super.add(event);
    }
  }

  @protected
  Future<void> handleException(AppExceptionWrapper appExceptionWrapper) async {
    await ExceptionHandler().handleException(appExceptionWrapper);
  }

  void showLoading() {
    EasyLoading.show();
  }

  void hideLoading({
    bool animation = true,
  }) {
    EasyLoading.dismiss(animation: animation);
  }

  Future<void> runBlocCatching({
    required Future<void> Function() action,
    Future<void> Function()? doOnRetry,
    Future<void> Function(AppException)? doOnError,
    Future<void> Function()? doOnSubscribe,
    Future<void> Function()? doOnSuccessOrError,
    Future<void> Function()? doOnEventCompleted,
    bool handleLoading = true,
    bool handleError = true,
    bool handleRetry = true,
    bool Function(AppException)? forceHandleError,
    String? overrideErrorMessage,
    int? maxRetries,
  }) async {
    assert(maxRetries == null || maxRetries >= 0,
        'maxRetries must be non-negative');
    Completer<void>? recursion;
    try {
      await doOnSubscribe?.call();
      if (handleLoading) {
        showLoading();
      }

      await action.call();

      if (handleLoading) {
        hideLoading();
      }
      await doOnSuccessOrError?.call();
    } on AppException catch (e) {
      if (handleLoading) {
        hideLoading();
      }
      await doOnSuccessOrError?.call();
      await doOnError?.call(e);

      if (handleError || (forceHandleError?.call(e) ?? _forceHandleError(e))) {
        await handleException(AppExceptionWrapper(
          appException: e,
          doOnRetry: doOnRetry ??
              (handleRetry && (maxRetries == null || maxRetries > 0)
                  ? () async {
                      recursion = Completer();
                      await runBlocCatching(
                        action: action,
                        doOnEventCompleted: doOnEventCompleted,
                        doOnSubscribe: doOnSubscribe,
                        doOnSuccessOrError: doOnSuccessOrError,
                        doOnError: doOnError,
                        doOnRetry: doOnRetry,
                        forceHandleError: forceHandleError,
                        handleError: handleError,
                        handleLoading: handleLoading,
                        handleRetry: handleRetry,
                        overrideErrorMessage: overrideErrorMessage,
                        maxRetries: maxRetries?.minus(1),
                      );
                      recursion?.complete();
                    }
                  : null),
          overrideMessage: overrideErrorMessage,
        ));
      }
    } catch (e) {
      await doOnSuccessOrError?.call();
      rethrow;
    } finally {
      await recursion?.future;
      await doOnEventCompleted?.call();
      if (handleLoading) {
        hideLoading();
      }
    }
  }

  bool _forceHandleError(AppException appException) {
    return appException is RemoteException &&
        appException.kind == RemoteExceptionKind.refreshTokenFailed;
  }
}
