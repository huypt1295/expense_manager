import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_core/flutter_core.dart' show Logger, Result, Failure, StateUpdater, ValueReducer;

import 'effect/effect.dart';

/// Base cubit providing shared infrastructure for handling asynchronous
/// operations that emit [Result] values alongside transient [Effect]s.
///
/// The helper methods guard against stale state updates, provide structured
/// logging, and surface failures as effects when desired.
abstract class BaseCubit<S, E extends Effect> extends Cubit<S>
    with EffectEmitter<E> {
  BaseCubit(
    super.initialState, {
    Logger? logger,
  }) : _logger = logger;

  final Logger? _logger;

  /// Monotonic sequence number to detect and discard stale asynchronous work.
  int _opSeq = 0;

  int get _nextOp => ++_opSeq;

  /// Executes a task that resolves to `Future<Result<R>>` while applying a
  /// repeatable handling pattern for loading, success, and error states.
  ///
  /// The optional callbacks mirror those exposed by the bloc helper
  /// `runResult`. They allow callers to mutate state before the task runs,
  /// after it completes, and when the result is either successful or failed.
  /// When [toErrorEffect] is provided, failures are surfaced to the UI as
  /// effects.
  @protected
  Future<void> runResult<R>({
    required Future<Result<R>> Function() task,
    StateUpdater<S>? onStart,
    StateUpdater<S>? onFinally,
    ValueReducer<S, R>? onOk,
    void Function(S state, Failure f)? onErr,
    E Function(Failure f)? toErrorEffect,
    String? spanName,
  }) async {
    final op = _nextOp;

    if (onStart != null) {
      emit(onStart(state));
    }

    final sw = Stopwatch()..start();
    final result = await task();
    sw.stop();

    if (op != _opSeq) {
      return;
    }

    result.fold(
      ok: (value) {
        _logger?.info('cubit.ok', {
          'span': spanName ?? runtimeType.toString(),
          'ms': sw.elapsedMilliseconds,
        });
        if (onOk != null) {
          emit(onOk(state, value));
        }
      },
      err: (f) {
        _logger?.warn('cubit.err', {
          'span': spanName ?? runtimeType.toString(),
          'code': f.code,
          'retryable': f.retryable,
          'ms': sw.elapsedMilliseconds,
        });
        if (onErr != null) {
          onErr(state, f);
        } else if (toErrorEffect != null) {
          emitEffect(toErrorEffect(f));
        }
      },
    );

    if (onFinally != null) {
      emit(onFinally(state));
    }
  }

  /// Applies the same success/error handling logic as [runResult] when a
  /// [Result] instance is already available.
  @protected
  void reduceResult<R>({
    required Result<R> result,
    ValueReducer<S, R>? onOk,
    void Function(S state, Failure f)? onErr,
    E Function(Failure f)? toErrorEffect,
  }) {
    result.fold(
      ok: (v) {
        if (onOk != null) emit(onOk(state, v));
      },
      err: (f) {
        if (onErr != null) {
          onErr(state, f);
        } else if (toErrorEffect != null) {
          emitEffect(toErrorEffect(f));
        }
      },
    );
  }

  @override
  Future<void> close() {
    disposeEffects();
    return super.close();
  }
}
