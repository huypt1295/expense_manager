import 'package:expense_manager/core/domain/entities/user_entity.dart';
import 'package:expense_manager/features/profile_setting/domain/usecases/get_user_usecase.dart';
import 'package:flutter_core/flutter_core.dart';
import 'home_event.dart';
import 'home_effect.dart';
import 'home_state.dart';

@injectable
class HomeBloc extends BaseBloc<HomeEvent, HomeState, HomeEffect> {
  final GetUserUseCase _getUserUseCase;

  HomeBloc(this._getUserUseCase) : super(const HomeInitial()) {
    on<HomeLoadData>(_onLoadData);
  }

  Future<void> _onLoadData(HomeLoadData event, Emitter<HomeState> emit) async {
    await runResult<UserEntity>(
      emit: emit,
      task: () => _getUserUseCase(NoParam()),
      onStart: (_) => const HomeLoading(),
      onOk: (_, user) => HomeLoaded(user: user),
      onErr: (_, failure) {
        final message = failure.message ?? failure.code;
        emit(HomeError(message));
        emitEffect(HomeShowErrorEffect(message));
      },
      trackKey: 'loadUserProfile',
      spanName: 'home.loadUser',
    );
  }
}
