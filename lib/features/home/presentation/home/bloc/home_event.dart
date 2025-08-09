import 'package:flutter_core/flutter_core.dart';

// Events
abstract class HomeEvent extends BaseBlocEvent with EquatableMixin {
  const HomeEvent();

  @override
  List<Object?> get props => [];
}

class HomeLoadData extends HomeEvent {
  const HomeLoadData();
}
