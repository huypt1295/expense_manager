import 'package:flutter_core/src/foundation/result.dart';

/// Generic definition for asynchronous use cases that transform [P] into [R]
/// and return the outcome as a [Result].
abstract class BaseUseCase<P, R> {
  /// Executes the use case with the provided [params].
  Future<Result<R>> call(P params);
}

/// Placeholder parameter used when a use case does not require input.
class NoParam {}
