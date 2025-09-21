import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter_core/flutter_core.dart';
import 'package:flutter_core/src/presentation/bloc/effect/effect.dart';

// import 'effect_emitter.dart'; // nếu EffectEmitter nằm file riêng
// ở đây giả định bạn đã có Effect + EffectEmitter như trong BaseCubit

typedef StateUpdater<S> = S Function(S);
typedef ValueReducer<S, R> = S Function(S, R);

/// BaseBloc:
/// - One-shot side-effects qua EffectEmitter
/// - runResult / reduceResult làm việc với Result<T>
/// - Chống ghi đè state từ tác vụ cũ (opSeq theo group/trackKey)
/// - Hook logger (tùy chọn)
abstract class BaseBloc<EVENT, S, FX extends Effect> extends Bloc<EVENT, S>
    with EffectEmitter<FX> {
  BaseBloc(
    super.initialState, {
    Logger? logger,
  }) : _logger = logger;

  final Logger? _logger;

  /// Mỗi "nhóm" tác vụ có bộ đếm riêng để tránh race-condition.
  /// Ví dụ: trackKey='loadList' vs 'refreshProfile' chạy song song mà không chặn nhau.
  final Map<Object, int> _opSeqBy = {};

  int _nextOp(Object key) =>
      _opSeqBy.update(key, (v) => v + 1, ifAbsent: () => 1);

  bool _isStale(Object key, int op) => (_opSeqBy[key] ?? 0) != op;

  /// Chạy 1 tác vụ trả Future<Result<R>> theo "recipe" chung của presentation:
  /// - emit(onStart(state)) trước khi chạy, emit(onFinally(state)) sau khi xong
  /// - onOk: reducer cập nhật state khi thành công
  /// - onErr: tự xử lý khi lỗi; nếu không cung cấp thì map Failure -> Effect để UI hiển thị
  /// - spanName: tên để log
  /// - trackKey: khoá "nhóm" để chống race-condition độc lập giữa nhiều tác vụ
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

    // Nếu đã có tác vụ mới hơn cùng trackKey hoàn tất trước, bỏ qua kết quả cũ.
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

  /// Khi đã có Result<R> sẵn (không cần await), xử lý nhanh.
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
