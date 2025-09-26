import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter_core/flutter_core.dart';
import 'package:flutter_core/src/presentation/bloc/effect/effect.dart';

/// Signature for transforming a state value without additional input.
typedef StateUpdater<S> = S Function(S);

/// Signature for reducing a state value using an additional payload.
typedef ValueReducer<S, R> = S Function(S, R);

/// Base class for bloc implementations that emit one-shot [Effect]s and
/// provide opinionated helpers for working with [Result] values.
///
/// * Uses [EffectEmitter] to forward transient UI effects.
/// * Guards against stale asynchronous results by tracking operations per
///   `trackKey`.
/// * Provides `runResult` and `reduceResult` helpers that log execution time
///   and automatically translate [Failure] instances into effects.
abstract class BaseBloc<EVENT, S, FX extends Effect> extends Bloc<EVENT, S>
    with EffectEmitter<FX> {
  BaseBloc(
    super.initialState, {
    Logger? logger,
  }) : _logger = logger;

  final Logger? _logger;

  /// Tracks the most recent operation identifier per [trackKey] to guard
  /// against stale asynchronous updates.
  final Map<Object, int> _opSeqBy = {};

  int _nextOp(Object key) =>
      _opSeqBy.update(key, (value) => value + 1, ifAbsent: () => 1);

  bool _isStale(Object key, int op) => (_opSeqBy[key] ?? 0) != op;

  /// Executes a task that produces a `Future<Result<R>>` and applies a
  /// structured set of callbacks to update state, emit effects, and log the
  /// lifecycle of the operation.
  ///
  /// The sequence is:
  /// * Optionally call [onStart] and emit the derived state before executing
  ///   [task].
  /// * Await the [Result] returned by [task].
  /// * Ignore stale results that belong to a superseded operation.
  /// * Invoke [onOk] or [onErr] depending on the outcome and optionally emit an
  ///   effect via [toErrorEffect].
  /// * Emit [onFinally] after completion if provided.
  ///
  /// [trackKey] allows isolating concurrent operations; each key has its own
  /// monotonic counter so newer operations can invalidate older ones.
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
        _logger?.warn('bloc.err', {
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

  /// Applies the same success/error handling logic as [runResult] without
  /// awaiting a task when a [Result] instance is already available.
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
