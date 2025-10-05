import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter_core/flutter_core.dart';

typedef StateUpdater<S> = S Function(S);
typedef ValueReducer<S, R> = S Function(S, R);

/// Base [Bloc] that supports effect streams, convenient `Result` handling, and
/// race-condition safeguards when running asynchronous work.
///
/// - Integrates the [EffectEmitter] mixin for one-shot side effects.
/// - Provides [runResult] / [reduceResult] helpers for working with
///   `Result<T>`.
/// - Prevents stale state updates by tracking operations per [trackKey].
/// - Optionally logs successes and failures through [Logger].
abstract class BaseBloc<EVENT, S, FX extends Effect> extends Bloc<EVENT, S>
    with EffectEmitter<FX> {
  BaseBloc(super.initialState, {Logger? logger})
      : _logger = logger ?? LoggerProvider.instance;

  final Logger? _logger;

  /// Maintains a counter per operation group to avoid race conditions.
  /// Example: `trackKey='loadList'` versus `'refreshProfile'` can run in
  /// parallel without blocking each other.
  final Map<Object, int> _opSeqBy = {};

  int _nextOp(Object key) =>
      _opSeqBy.update(key, (v) => v + 1, ifAbsent: () => 1);

  bool _isStale(Object key, int op) => (_opSeqBy[key] ?? 0) != op;

  /// Executes [task] and reduces the resulting [Result] following the
  /// presentation-layer recipe.
  ///
  /// - Emits [onStart] before running and [onFinally] after completion.
  /// - [onOk]: reduces the success value into a new state.
  /// - [onErr]: handles failures manually; otherwise [toErrorEffect] maps a
  ///   failure into an effect for UI feedback.
  /// - [spanName]: optional label for logging and performance tracking.
  /// - [trackKey]: isolates concurrent operations to avoid race conditions.
  @protected
  Future<void> runResult<R>({
    required Emitter<S> emit,
    required Future<Result<R>> Function() task,
    StateUpdater<S>? onStart,
    StateUpdater<S>? onFinally,
    ValueReducer<S, R>? onOk,
    void Function(S state, Failure f)? onErr,
    FX Function(Failure f)? toErrorEffect,
    String? spanName,
    Object trackKey = 'default',
  }) async {
    final op = _nextOp(trackKey);

    if (onStart != null) {
      emit(onStart(state));
    }

    final sw = Stopwatch()..start();
    final result = await task();
    sw.stop();

    // Skip the result if a newer operation with the same trackKey completed.
    if (_isStale(trackKey, op)) {
      return;
    }

    result.fold(
      ok: (value) {
        _logger?.info('bloc.ok', {
          'span': spanName ?? runtimeType.toString(),
          'ms': sw.elapsedMilliseconds,
          'track': trackKey.toString(),
        });
        if (onOk != null) {
          emit(onOk(state, value));
        }
      },
      err: (f) {
        _logger?.warn('bloc.err -> ${f.message}', {
          'span': spanName ?? runtimeType.toString(),
          'code': f.code,
          'retryable': f.retryable,
          'ms': sw.elapsedMilliseconds,
          'track': trackKey.toString(),
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

  /// Reduces an already available [Result] without awaiting a task.
  @protected
  void reduceResult<R>({
    required Emitter<S> emit,
    required Result<R> result,
    ValueReducer<S, R>? onOk,
    void Function(S state, Failure f)? onErr,
    FX Function(Failure f)? toErrorEffect,
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
