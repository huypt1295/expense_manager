import 'package:flutter_core/src/data/model/base_model.dart';
import 'package:flutter_core/src/domain/entity.dart';
import 'package:flutter_test/flutter_test.dart';

class _TestEntity extends BaseEntity {
  _TestEntity(this.value);
  final String value;

  @override
  Map<String, dynamic> toJson() => {'value': value};

  @override
  List<Object?> get props => [value];
}

class _TestModel extends BaseModel<_TestEntity> {
  _TestModel(this.value);
  final String value;

  @override
  _TestEntity toEntity() => _TestEntity(value);

  @override
  Map<String, dynamic> toJson() => {'value': value};
}

void main() {
  test('BaseModel implementations convert to entity and json', () {
    final model = _TestModel('hello');
    expect(model.toEntity().value, 'hello');
    expect(model.toJson(), {'value': 'hello'});
  });

  test('safeParseJson returns map or throws FormatException', () {
    final json = BaseModel.safeParseJson({'foo': 'bar'});
    expect(json['foo'], 'bar');
    expect(
      () => BaseModel.safeParseJson('not a map'),
      throwsA(isA<FormatException>()),
    );
  });
}
