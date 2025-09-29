import 'failure.dart';

/// Models the outcome of an operation as either a success value or a failure.
sealed class Result<T> {
  const Result();

  /// Creates a successful result wrapping [value].
  const factory Result.success(T value) = _Success<T>;

  /// Creates a failure result containing the [failure] detail.
  const factory Result.failure(Failure failure) = _Failure<T>;

  /// Transforms the result into another type by invoking [ok] for success or
  /// [err] for failure.
  R fold<R>({required R Function(T) ok, required R Function(Failure) err});

  /// Indicates whether the result represents success.
  bool get isSuccess => this is _Success<T>;

  /// Indicates whether the result represents failure.
  bool get isFailure => this is _Failure<T>;

  /// Returns the success value or `null` when the result is a failure.
  T? get valueOrNull => switch (this) {
    _Success(value: final v) => v,
    _ => null,
  };

  /// Returns the failure information or `null` when the result is a success.
  Failure? get failureOrNull => switch (this) {
    _Failure(failure: final f) => f,
    _ => null,
  };

  /// Maps the contained success value with [transform] while preserving
  /// failures untouched.
  Result<U> map<U>(U Function(T) transform) => switch (this) {
    _Success(value: final v) => Result.success(transform(v)),
    _Failure(:final failure) => Result.failure(failure),
  };

  /// Recovers from a failure by converting it into a success value using
  /// [handler]; success values pass through unchanged.
  Result<T> recover(T Function(Failure f) handler) => switch (this) {
    _Success() => this,
    _Failure(:final failure) => Result.success(handler(failure)),
  };

  /// Executes [block] catching errors and mapping them to a [Result] via [map].
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

/// Internal success variant of [Result].
final class _Success<T> extends Result<T> {
  /// Stored success value.
  final T value;

  /// Creates a success result containing [value].
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

/// Internal failure variant of [Result].
final class _Failure<T> extends Result<T> {
  /// Stored failure value.
  final Failure failure;

  /// Creates a failure result containing [failure].
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
