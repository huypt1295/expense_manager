import 'package:equatable/equatable.dart';

/// Base type for entities that can produce an Equatable JSON representation.
abstract class BaseEntity with EquatableMixin {
  /// Converts the entity into a JSON-serializable map.
  Map<String, dynamic> toJson();
}
