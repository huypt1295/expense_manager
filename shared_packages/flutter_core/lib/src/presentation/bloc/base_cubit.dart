import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_core/flutter_core.dart'
    show Logger, LoggerProvider, Result, Failure, StateUpdater, ValueReducer;

import 'effect/effect.dart';

/// Base cubit that exposes an effect stream and helpers for working with
/// `Result` values while preventing stale state updates.
abstract class BaseCubit<S, E extends Effect> extends Cubit<S>
    with EffectEmitter<E> {
  BaseCubit(
    super.initialState, {
    Logger? logger,
  }) : _logger = logger ?? LoggerProvider.instance;

  final Logger? _logger;

  // Prevents older operations from overriding the result of newer ones.
  int _opSeq = 0;

  int get _nextOp => ++_opSeq;

  /// Executes [task] and reduces the resulting [Result] following a shared
  /// presentation approach.
  ///
  /// - [onStart] / [onFinally]: update the state (e.g. toggle loading).
  /// - [onOk]: reduce the success value into a new state.
  /// - [onErr]: handle failures manually; if omitted, [toErrorEffect] maps a
  ///   failure into an [E] effect for UI feedback.
  /// - [spanName]: optional label for structured logging.
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
      // Allow toggling loading or other pre-run state changes.
      emit(onStart(state));
    }

    final sw = Stopwatch()..start();
    final result = await task();
    sw.stop();

    // Skip the result if a newer operation has already completed first.
    if (op != _opSeq) {
      // Avoid calling onFinally so the latest operation controls loading state.
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

  /// Reduces an already available [Result] without awaiting a task.
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
