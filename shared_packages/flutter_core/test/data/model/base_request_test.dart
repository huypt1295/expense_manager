import 'package:flutter_core/src/data/model/base_request.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('BaseRequestImpl stores flags and throws when toDictionary not overridden', () {
    final request = BaseRequestImpl(loading: true, sync: false);
    expect(request.loading, isTrue);
    expect(request.sync, isFalse);
    expect(() => request.toDictionary(), throwsUnimplementedError);
  });
}
