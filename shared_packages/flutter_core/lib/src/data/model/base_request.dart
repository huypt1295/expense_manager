abstract class BaseRequest {
  final bool? loading;
  final bool? sync;

  BaseRequest({this.loading, this.sync});

  Map<String, dynamic> toDictionary();
}

class BaseRequestImpl extends BaseRequest {
  BaseRequestImpl({bool? loading, bool? sync})
      : super(loading: loading, sync: sync);

  @override
  Map<String, dynamic> toDictionary() {
    throw UnimplementedError();
  }
}
