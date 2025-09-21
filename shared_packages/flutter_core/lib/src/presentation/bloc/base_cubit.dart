import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_core/flutter_core.dart' show Logger, Result, Failure, StateUpdater, ValueReducer;

import 'effect/effect.dart';


abstract class BaseCubit<S, E extends Effect> extends Cubit<S>
    with EffectEmitter<E> {
  BaseCubit(
    super.initialState, {
    Logger? logger,
  }) : _logger = logger;

  final Logger? _logger;

  // Ngăn tác vụ cũ ghi đè kết quả của tác vụ mới hơn
  int _opSeq = 0;

  int get _nextOp => ++_opSeq;

  /// Chạy 1 tác vụ trả về Future<Result<R>> theo “recipe” chung:
  /// - onStart / onFinally: updater state (ví dụ bật/tắt loading)
  /// - onOk: cập nhật state khi thành công
  /// - onErr: xử lý khi lỗi; nếu không cung cấp, có thể bắn Effect lỗi qua toErrorEffect
  /// - toErrorEffect: map Failure -> E (Effect) để UI hiển thị snackbar/dialog
  /// - spanName: tên nhịp để logger dễ đọc
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
      // cho phép toggle loading, vv.
      emit(onStart(state));
    }

    final sw = Stopwatch()..start();
    final result = await task();
    sw.stop();

    // Nếu đã có tác vụ mới hơn chạy xong trước, bỏ qua kết quả cũ để tránh giật state.
    if (op != _opSeq) {
      // Không gọi onFinally để tránh tắt loading của tác vụ mới.
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

  /// Khi đã có sẵn Result<R> (không cần await), xử lý nhanh.
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
