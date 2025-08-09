// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:expense_manager/core/routing/app_router.dart' as _i6;
import 'package:expense_manager/features/home/presentation/home/bloc/home_bloc.dart'
    as _i10;
import 'package:expense_manager/features/profile_setting/data/repositories/user_repository_impl.dart'
    as _i8;
import 'package:expense_manager/features/profile_setting/domain/repositories/user_repository.dart'
    as _i7;
import 'package:expense_manager/features/profile_setting/domain/usecases/get_user_usecase.dart'
    as _i9;
import 'package:flutter_common/flutter_common.dart' as _i4;
import 'package:flutter_core/flutter_core.dart' as _i3;
import 'package:flutter_resource/flutter_resource.dart' as _i5;
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;

extension GetItInjectableX on _i1.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  Future<_i1.GetIt> init({
    String? environment,
    _i2.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i2.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    await _i3.FlutterCorePackageModule().init(gh);
    await _i4.FlutterCommonPackageModule().init(gh);
    await _i5.FlutterResourcePackageModule().init(gh);
    gh.singleton<_i6.AppRouter>(() => _i6.AppRouter());
    gh.singleton<_i7.UserRepository>(() => _i8.UserRepositoryImpl());
    gh.factory<_i9.GetUserUseCase>(
        () => _i9.GetUserUseCase(gh<_i7.UserRepository>()));
    gh.factory<_i10.HomeBloc>(() => _i10.HomeBloc(gh<_i9.GetUserUseCase>()));
    return this;
  }
}
