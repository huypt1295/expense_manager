import 'package:expense_manager/core/domain/entities/user_entity.dart';
import 'package:expense_manager/features/profile_setting/domain/usecases/get_user_usecase.dart';
import 'package:flutter_core/flutter_core.dart';
import 'home_event.dart';
import 'home_state.dart';

@injectable
class HomeBloc extends BaseBloc<HomeEvent, HomeState> {
  final GetUserUseCase _getUserUseCase;

  HomeBloc(this._getUserUseCase) : super(const HomeInitial()) {
    on<HomeLoadData>(_onLoadData);
  }

  void _onLoadData(HomeLoadData event, Emitter<HomeState> emit) async {
    emit(const HomeLoading());
    (await runAsyncCatching<UserEntity>(
      action: () => _getUserUseCase.call(null),
    )).when(
      success: (user) => emit(HomeLoaded(user: user)),
      failure: (e) => emit(HomeError(e.toString())),
    );
  }
}
