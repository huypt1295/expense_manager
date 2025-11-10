import 'package:equatable/equatable.dart';

class HouseholdEntity extends Equatable {
  const HouseholdEntity({
    required this.id,
    required this.name,
    required this.currencyCode,
    required this.ownerId,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final String name;
  final String currencyCode;
  final String ownerId;
  final DateTime createdAt;
  final DateTime updatedAt;

  HouseholdEntity copyWith({
    String? id,
    String? name,
    String? currencyCode,
    String? ownerId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return HouseholdEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      currencyCode: currencyCode ?? this.currencyCode,
      ownerId: ownerId ?? this.ownerId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => <Object?>[
        id,
        name,
        currencyCode,
        ownerId,
        createdAt,
        updatedAt,
      ];
}
