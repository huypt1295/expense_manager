import 'package:equatable/equatable.dart';

abstract class BaseEntity with EquatableMixin{
  Map<String, dynamic> toJson();
}