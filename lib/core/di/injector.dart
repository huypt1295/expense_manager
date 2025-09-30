import 'package:flutter_common/flutter_common.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:expense_manager/core/auth/current_user.dart';
import 'package:expense_manager/core/di/injector.config.dart';
import 'package:flutter_core/flutter_core.dart';
import 'package:flutter_resource/flutter_resource.dart';
import 'package:expense_manager/features/auth/data/datasources/firebase_auth_data_source.dart';
import 'package:expense_manager/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:expense_manager/features/auth/domain/repositories/auth_repository.dart';
import 'package:expense_manager/features/auth/domain/usecases/sign_out_usecase.dart';
import 'package:expense_manager/features/auth/presentation/login/adapters/account_actions_from_auth.dart';
import 'package:expense_manager/features/auth/presentation/login/adapters/current_user_from_auth_bloc.dart';
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
  final getIt = tpGetIt;

  // Register Auth data source & repository before Injectable wiring so that
  // dependent use cases can resolve the repository during codegen setup.
  if (!getIt.isRegistered<FirebaseAuthDataSource>()) {
    getIt.registerLazySingleton<FirebaseAuthDataSource>(
      FirebaseAuthDataSource.new,
    );
  }
  if (!getIt.isRegistered<AuthRepository>()) {
    getIt.registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(getIt<FirebaseAuthDataSource>()),
    );
  }

  if (!getIt.isRegistered<FirebaseFirestore>()) {
    getIt.registerLazySingleton<FirebaseFirestore>(
      () => FirebaseFirestore.instance,
    );
  }
  if (!getIt.isRegistered<FirebaseStorage>()) {
    getIt.registerLazySingleton<FirebaseStorage>(
      () => FirebaseStorage.instance,
    );
  }

  await getIt.init();

  if (!getIt.isRegistered<CurrentUser>()) {
    getIt.registerLazySingleton<CurrentUser>(
      () => CurrentUserFromAuthBloc(getIt<AuthBloc>()),
    );
  }
  if (!getIt.isRegistered<AccountActions>()) {
    getIt.registerLazySingleton<AccountActions>(
      () => AccountActionsFromAuth(getIt<SignOutUseCase>()),
    );
  }

  return getIt;
}
