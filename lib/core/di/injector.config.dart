// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:expense_manager/core/routing/app_router.dart' as _i861;
import 'package:expense_manager/features/auth/domain/repositories/auth_repository.dart'
    as _i740;
import 'package:expense_manager/features/auth/presentation/login/bloc/auth_bloc.dart'
    as _i68;
import 'package:expense_manager/features/home/presentation/home/bloc/home_bloc.dart'
    as _i32;
import 'package:expense_manager/features/profile_setting/data/repositories/user_repository_impl.dart'
    as _i179;
import 'package:expense_manager/features/profile_setting/domain/repositories/user_repository.dart'
    as _i959;
import 'package:expense_manager/features/profile_setting/domain/usecases/get_user_usecase.dart'
    as _i1019;
import 'package:flutter_common/flutter_common.dart' as _i400;
import 'package:flutter_core/flutter_core.dart' as _i453;
import 'package:flutter_resource/flutter_resource.dart' as _i134;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    await _i453.FlutterCorePackageModule().init(gh);
    await _i400.FlutterCommonPackageModule().init(gh);
    await _i134.FlutterResourcePackageModule().init(gh);
    gh.singleton<_i861.AppRouter>(() => _i861.AppRouter());
    gh.factory<_i68.AuthBloc>(() => _i68.AuthBloc(gh<_i740.AuthRepository>()));
    gh.singleton<_i959.UserRepository>(() => _i179.UserRepositoryImpl());
    gh.factory<_i1019.GetUserUseCase>(
      () => _i1019.GetUserUseCase(gh<_i959.UserRepository>()),
    );
    gh.factory<_i32.HomeBloc>(() => _i32.HomeBloc(gh<_i1019.GetUserUseCase>()));
    return this;
  }
}
