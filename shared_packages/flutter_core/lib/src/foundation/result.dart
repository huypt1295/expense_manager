import 'failure.dart';

sealed class Result<T> {
  const Result();

  const factory Result.success(T value) = _Success<T>;
  const factory Result.failure(Failure failure) = _Failure<T>;

  R fold<R>({required R Function(T) ok, required R Function(Failure) err});

  bool get isSuccess => this is _Success<T>;
  bool get isFailure => this is _Failure<T>;

  T? get valueOrNull => switch (this) {
    _Success(value: final v) => v,
    _ => null,
  };

  Failure? get failureOrNull => switch (this) {
    _Failure(failure: final f) => f,
    _ => null,
  };

  Result<U> map<U>(U Function(T) transform) => switch (this) {
    _Success(value: final v) => Result.success(transform(v)),
    _Failure(:final failure) => Result.failure(failure),
  };

  Result<T> recover(T Function(Failure f) handler) => switch (this) {
    _Success() => this,
    _Failure(:final failure) => Result.success(handler(failure)),
  };

  static Future<Result<T>> guard<T>(
      Future<T> Function() block,
      Failure Function(Object e, StackTrace st) map,
      ) async {
    try {
      return Result.success(await block());
    } catch (e, st) {
      return Result.failure(map(e, st));
    }
  }
}

final class _Success<T> extends Result<T> {
  final T value;
  const _Success(this.value);

  @override
  R fold<R>({required R Function(T) ok, required R Function(Failure) err}) => ok(value);

  @override
  String toString() => 'Result.success($value)';

  @override
  int get hashCode => Object.hash(runtimeType, value);
  @override
  bool operator ==(Object other) => other is _Success<T> && other.value == value;
}

final class _Failure<T> extends Result<T> {
  final Failure failure;
  const _Failure(this.failure);

  @override
  R fold<R>({required R Function(T) ok, required R Function(Failure) err}) => err(failure);

  @override
  String toString() => 'Result.failure(${failure.code})';

  @override
  int get hashCode => Object.hash(runtimeType, failure);
  @override
  bool operator ==(Object other) => other is _Failure<T> && other.failure == failure;
}
