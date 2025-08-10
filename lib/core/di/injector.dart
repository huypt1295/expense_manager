import 'package:flutter_common/flutter_common.dart';
import 'package:expense_manager/core/di/injector.config.dart';
import 'package:flutter_core/flutter_core.dart';
import 'package:flutter_resource/flutter_resource.dart';
import 'package:expense_manager/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:expense_manager/features/auth/domain/repositories/auth_repository.dart';
import 'package:expense_manager/features/auth/presentation/login/bloc/auth_bloc.dart';

@InjectableInit(
  includeMicroPackages: true,
  // ignoreUnregisteredTypesInPackages: ['flutter_core'],
  externalPackageModulesBefore: [
    ExternalModule(FlutterCorePackageModule),
    ExternalModule(FlutterCommonPackageModule),
    ExternalModule(FlutterResourcePackageModule),
  ],
)
Future<GetIt> configureDependencies() async {
  final getIt = await tpGetIt.init();

  // Register Auth Repository
  getIt.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl());

  return getIt;
}
