import 'package:flutter_core/src/domain/entity.dart';

/// Base contract for data models that can map to domain [BaseEntity] instances.
abstract class BaseModel<Entity extends BaseEntity> {
  BaseModel();

  /// Converts this model into its domain entity counterpart.
  Entity toEntity();

  /// Serializes this model into a JSON-compatible structure.
  Map<String, dynamic> toJson();

  /// Ensures [json] is a map and throws a descriptive error otherwise.
  static Map<String, dynamic> safeParseJson(dynamic json) {
    if (json is Map<String, dynamic>) return json;
    throw const FormatException('Invalid JSON format');
  }
}
