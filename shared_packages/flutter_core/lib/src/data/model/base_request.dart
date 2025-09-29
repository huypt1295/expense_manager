/// Base DTO contract for API requests shared across data sources.
abstract class BaseRequest {
  final bool? loading;
  final bool? sync;

  BaseRequest({this.loading, this.sync});

  /// Serializes this request into a map suitable for an HTTP body.
  Map<String, dynamic> toDictionary();
}

/// Default implementation stub for quick experiments or tests.
class BaseRequestImpl extends BaseRequest {
  BaseRequestImpl({super.loading, super.sync});

  @override
  Map<String, dynamic> toDictionary() {
    throw UnimplementedError();
  }
}
