import 'package:expense_manager/features/profile_setting/domain/entities/user_entity.dart';
import 'package:flutter_core/flutter_core.dart';

// States
abstract class HomeState extends BaseBlocState with EquatableMixin {
  const HomeState();

  @override
  List<Object?> get props => [];
}

class HomeInitial extends HomeState {
  const HomeInitial();
}

class HomeLoading extends HomeState {
  const HomeLoading();
}

class HomeLoaded extends HomeState {
  final UserEntity user;

  const HomeLoaded({
    required this.user,
  });

  @override
  List<Object?> get props => [user];

  HomeLoaded copyWith({
    UserEntity? user,
  }) {
    return HomeLoaded(
      user: user ?? this.user,
    );
  }
}

class HomeError extends HomeState {
  final String message;

  const HomeError(this.message);

  @override
  List<Object?> get props => [message];
}
