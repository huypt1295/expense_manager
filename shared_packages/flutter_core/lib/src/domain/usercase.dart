import 'package:flutter_core/src/foundation/failure.dart' show UnknownFailure;
import 'package:flutter_core/src/foundation/result.dart';

abstract class BaseUseCase<P, R> {
  Future<Result<R>> call(P params);
}

class NoParam {}
