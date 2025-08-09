import 'package:flutter_core/src/domain/entity.dart';

abstract class BaseModel<Entity extends BaseEntity> {
  BaseModel();

  Entity toEntity();

  Map<String, dynamic> toJson();

  static Map<String, dynamic> safeParseJson(dynamic json) {
    if (json is Map<String, dynamic>) return json;
    throw const FormatException('Invalid JSON format');
  }
}
