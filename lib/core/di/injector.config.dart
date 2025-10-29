// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:cloud_firestore/cloud_firestore.dart' as _i974;
import 'package:expense_manager/core/auth/current_user.dart' as _i79;
import 'package:expense_manager/core/di/firebase_module.dart' as _i93;
import 'package:expense_manager/core/routing/app_router.dart' as _i861;
import 'package:expense_manager/core/workspace/current_workspace.dart' as _i325;
import 'package:expense_manager/features/add_expense/presentation/add_expense/bloc/expense_bloc.dart'
    as _i1026;
import 'package:expense_manager/features/auth/data/datasources/firebase_auth_data_source.dart'
    as _i288;
import 'package:expense_manager/features/auth/data/repositories/auth_repository_impl.dart'
    as _i816;
import 'package:expense_manager/features/auth/domain/repositories/auth_repository.dart'
    as _i740;
import 'package:expense_manager/features/auth/domain/usecases/sign_in_with_fb_usecase.dart'
    as _i35;
import 'package:expense_manager/features/auth/domain/usecases/sign_in_with_google_usecase.dart'
    as _i864;
import 'package:expense_manager/features/auth/domain/usecases/sign_out_usecase.dart'
    as _i1070;
import 'package:expense_manager/features/auth/domain/usecases/watch_auth_state_usecase.dart'
    as _i553;
import 'package:expense_manager/features/auth/presentation/login/adapters/account_actions_from_auth.dart'
    as _i655;
import 'package:expense_manager/features/auth/presentation/login/adapters/current_user_from_auth_bloc.dart'
    as _i524;
import 'package:expense_manager/features/auth/presentation/login/bloc/auth_bloc.dart'
    as _i68;
import 'package:expense_manager/features/budget/data/datasources/budget_remote_data_source.dart'
    as _i78;
import 'package:expense_manager/features/budget/data/repositories/budget_repository_impl.dart'
    as _i932;
import 'package:expense_manager/features/budget/domain/repositories/budget_repository.dart'
    as _i639;
import 'package:expense_manager/features/budget/domain/usecases/add_budget_usecase.dart'
    as _i105;
import 'package:expense_manager/features/budget/domain/usecases/delete_budget_usecase.dart'
    as _i1032;
import 'package:expense_manager/features/budget/domain/usecases/update_budget_usecase.dart'
    as _i740;
import 'package:expense_manager/features/budget/domain/usecases/watch_budgets_usecase.dart'
    as _i192;
import 'package:expense_manager/features/budget/presentation/budget/bloc/budget_bloc.dart'
    as _i494;
import 'package:expense_manager/features/categories/application/categories_service.dart'
    as _i49;
import 'package:expense_manager/features/categories/data/datasources/category_remote_data_source.dart'
    as _i892;
import 'package:expense_manager/features/categories/data/repositories/category_repository_impl.dart'
    as _i939;
import 'package:expense_manager/features/categories/domain/repositories/category_repository.dart'
    as _i482;
import 'package:expense_manager/features/categories/domain/usecases/create_user_category_usecase.dart'
    as _i469;
import 'package:expense_manager/features/categories/domain/usecases/delete_user_category_usecase.dart'
    as _i380;
import 'package:expense_manager/features/categories/domain/usecases/load_categories_usecase.dart'
    as _i823;
import 'package:expense_manager/features/categories/domain/usecases/update_user_category_usecase.dart'
    as _i770;
import 'package:expense_manager/features/categories/domain/usecases/watch_categories_usecase.dart'
    as _i276;
import 'package:expense_manager/features/home/presentation/home/bloc/home_bloc.dart'
    as _i32;
import 'package:expense_manager/features/home/presentation/summary/bloc/summary_bloc.dart'
    as _i983;
import 'package:expense_manager/features/profile_setting/data/datasources/profile_remote_data_source.dart'
    as _i995;
import 'package:expense_manager/features/profile_setting/data/repositories/user_profile_repository_impl.dart'
    as _i279;
import 'package:expense_manager/features/profile_setting/data/repositories/user_repository_impl.dart'
    as _i179;
import 'package:expense_manager/features/profile_setting/domain/repositories/user_profile_repository.dart'
    as _i884;
import 'package:expense_manager/features/profile_setting/domain/repositories/user_repository.dart'
    as _i959;
import 'package:expense_manager/features/profile_setting/domain/usecases/get_profile_usecase.dart'
    as _i55;
import 'package:expense_manager/features/profile_setting/domain/usecases/get_user_usecase.dart'
    as _i1019;
import 'package:expense_manager/features/profile_setting/domain/usecases/update_profile_usecase.dart'
    as _i631;
import 'package:expense_manager/features/profile_setting/domain/usecases/upload_avatar_usecase.dart'
    as _i655;
import 'package:expense_manager/features/profile_setting/domain/usecases/watch_profile_usecase.dart'
    as _i1022;
import 'package:expense_manager/features/profile_setting/presentation/profile/bloc/profile_bloc.dart'
    as _i439;
import 'package:expense_manager/features/transactions/data/datasources/transactions_remote_data_source.dart'
    as _i376;
import 'package:expense_manager/features/transactions/data/repositories/transactions_repository_impl.dart'
    as _i596;
import 'package:expense_manager/features/transactions/domain/repositories/transactions_repository.dart'
    as _i496;
import 'package:expense_manager/features/transactions/domain/usecases/add_transaction_usecase.dart'
    as _i892;
import 'package:expense_manager/features/transactions/domain/usecases/delete_transaction_usecase.dart'
    as _i27;
import 'package:expense_manager/features/transactions/domain/usecases/get_transactions_once_usecase.dart'
    as _i189;
import 'package:expense_manager/features/transactions/domain/usecases/update_transaction_usecase.dart'
    as _i288;
import 'package:expense_manager/features/transactions/domain/usecases/watch_transactions_usecase.dart'
    as _i717;
import 'package:expense_manager/features/transactions/presentation/add_transaction/bloc/add_transaction_bloc.dart'
    as _i437;
import 'package:expense_manager/features/transactions/presentation/transactions/bloc/transactions_bloc.dart'
    as _i551;
import 'package:expense_manager/features/workspace/application/current_workspace_controller.dart'
    as _i108;
import 'package:expense_manager/features/workspace/data/datasources/workspace_remote_data_source.dart'
    as _i450;
import 'package:expense_manager/features/workspace/data/repositories/workspace_repository_impl.dart'
    as _i680;
import 'package:expense_manager/features/workspace/domain/repositories/workspace_repository.dart'
    as _i874;
import 'package:expense_manager/features/workspace/presentation/bloc/workspace_bloc.dart'
    as _i990;
import 'package:firebase_auth/firebase_auth.dart' as _i59;
import 'package:firebase_storage/firebase_storage.dart' as _i457;
import 'package:flutter_common/flutter_common.dart' as _i400;
import 'package:flutter_core/flutter_core.dart' as _i453;
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart' as _i806;
import 'package:flutter_resource/flutter_resource.dart' as _i134;
import 'package:get_it/get_it.dart' as _i174;
import 'package:google_sign_in/google_sign_in.dart' as _i116;
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
    final firebaseModule = _$FirebaseModule();
    gh.singleton<_i861.AppRouter>(() => _i861.AppRouter());
    gh.lazySingleton<_i59.FirebaseAuth>(() => firebaseModule.firebaseAuth());
    gh.lazySingleton<_i974.FirebaseFirestore>(
      () => firebaseModule.firebaseFirestore(),
    );
    gh.lazySingleton<_i457.FirebaseStorage>(
      () => firebaseModule.firebaseStorage(),
    );
    gh.lazySingleton<_i116.GoogleSignIn>(() => firebaseModule.googleSignIn());
    gh.lazySingleton<_i806.FacebookAuth>(() => firebaseModule.facebookAuth());
    gh.singleton<_i959.UserRepository>(
      () => _i179.UserRepositoryImpl(firebaseAuth: gh<_i59.FirebaseAuth>()),
    );
    gh.factory<_i1019.GetUserUseCase>(
      () => _i1019.GetUserUseCase(gh<_i959.UserRepository>()),
    );
    gh.lazySingleton<_i288.FirebaseAuthDataSource>(
      () => _i288.FirebaseAuthDataSource(
        firebaseAuth: gh<_i59.FirebaseAuth>(),
        googleSignIn: gh<_i116.GoogleSignIn>(),
        facebookAuth: gh<_i806.FacebookAuth>(),
      ),
    );
    gh.lazySingleton<_i78.BudgetRemoteDataSource>(
      () => _i78.BudgetRemoteDataSource(gh<_i974.FirebaseFirestore>()),
    );
    gh.lazySingleton<_i892.CategoryRemoteDataSource>(
      () => _i892.CategoryRemoteDataSource(gh<_i974.FirebaseFirestore>()),
    );
    gh.lazySingleton<_i376.TransactionsRemoteDataSource>(
      () => _i376.TransactionsRemoteDataSource(gh<_i974.FirebaseFirestore>()),
    );
    gh.lazySingleton<_i450.WorkspaceRemoteDataSource>(
      () => _i450.WorkspaceRemoteDataSource(gh<_i974.FirebaseFirestore>()),
    );
    gh.lazySingleton<_i995.ProfileRemoteDataSource>(
      () => _i995.ProfileRemoteDataSource(
        gh<_i974.FirebaseFirestore>(),
        gh<_i457.FirebaseStorage>(),
      ),
    );
    gh.lazySingleton<_i740.AuthRepository>(
      () => _i816.AuthRepositoryImpl(gh<_i288.FirebaseAuthDataSource>()),
    );
    gh.singleton<_i35.SignInWithFacebookUseCase>(
      () => _i35.SignInWithFacebookUseCase(gh<_i740.AuthRepository>()),
    );
    gh.singleton<_i864.SignInWithGoogleUseCase>(
      () => _i864.SignInWithGoogleUseCase(gh<_i740.AuthRepository>()),
    );
    gh.singleton<_i1070.SignOutUseCase>(
      () => _i1070.SignOutUseCase(gh<_i740.AuthRepository>()),
    );
    gh.singleton<_i553.WatchAuthStateUseCase>(
      () => _i553.WatchAuthStateUseCase(gh<_i740.AuthRepository>()),
    );
    gh.factory<_i32.HomeBloc>(() => _i32.HomeBloc(gh<_i1019.GetUserUseCase>()));
    gh.lazySingleton<_i884.UserProfileRepository>(
      () =>
          _i279.UserProfileRepositoryImpl(gh<_i995.ProfileRemoteDataSource>()),
    );
    gh.singleton<_i68.AuthBloc>(
      () => _i68.AuthBloc(
        gh<_i864.SignInWithGoogleUseCase>(),
        gh<_i35.SignInWithFacebookUseCase>(),
        gh<_i1070.SignOutUseCase>(),
        gh<_i553.WatchAuthStateUseCase>(),
        gh<_i453.Logger>(),
      ),
    );
    gh.factory<_i55.GetProfileUseCase>(
      () => _i55.GetProfileUseCase(gh<_i884.UserProfileRepository>()),
    );
    gh.factory<_i631.UpdateProfileUseCase>(
      () => _i631.UpdateProfileUseCase(gh<_i884.UserProfileRepository>()),
    );
    gh.factory<_i655.UploadAvatarUseCase>(
      () => _i655.UploadAvatarUseCase(gh<_i884.UserProfileRepository>()),
    );
    gh.singleton<_i1022.WatchProfileUseCase>(
      () => _i1022.WatchProfileUseCase(gh<_i884.UserProfileRepository>()),
    );
    gh.singleton<_i79.AccountActions>(
      () => _i655.AccountActionsFromAuth(gh<_i1070.SignOutUseCase>()),
    );
    gh.singleton<_i79.CurrentUser>(
      () => _i524.CurrentUserFromAuthBloc(gh<_i68.AuthBloc>()),
    );
    gh.singleton<_i325.CurrentWorkspace>(
      () => _i108.CurrentWorkspaceController(gh<_i79.CurrentUser>()),
    );
    gh.lazySingleton<_i639.BudgetRepository>(
      () => _i932.BudgetRepositoryImpl(
        gh<_i78.BudgetRemoteDataSource>(),
        gh<_i79.CurrentUser>(),
      ),
    );
    gh.lazySingleton<_i482.CategoryRepository>(
      () => _i939.CategoryRepositoryImpl(
        gh<_i892.CategoryRemoteDataSource>(),
        gh<_i79.CurrentUser>(),
      ),
    );
    gh.factory<_i439.ProfileBloc>(
      () => _i439.ProfileBloc(
        gh<_i79.CurrentUser>(),
        gh<_i1022.WatchProfileUseCase>(),
        gh<_i631.UpdateProfileUseCase>(),
        gh<_i655.UploadAvatarUseCase>(),
        gh<_i79.AccountActions>(),
        logger: gh<_i453.Logger>(),
      ),
    );
    gh.factory<_i105.AddBudgetUseCase>(
      () => _i105.AddBudgetUseCase(gh<_i639.BudgetRepository>()),
    );
    gh.factory<_i1032.DeleteBudgetUseCase>(
      () => _i1032.DeleteBudgetUseCase(gh<_i639.BudgetRepository>()),
    );
    gh.factory<_i740.UpdateBudgetUseCase>(
      () => _i740.UpdateBudgetUseCase(gh<_i639.BudgetRepository>()),
    );
    gh.singleton<_i192.WatchBudgetsUseCase>(
      () => _i192.WatchBudgetsUseCase(gh<_i639.BudgetRepository>()),
    );
    gh.factory<_i469.CreateUserCategoryUseCase>(
      () => _i469.CreateUserCategoryUseCase(gh<_i482.CategoryRepository>()),
    );
    gh.factory<_i380.DeleteUserCategoryUseCase>(
      () => _i380.DeleteUserCategoryUseCase(gh<_i482.CategoryRepository>()),
    );
    gh.factory<_i770.UpdateUserCategoryUseCase>(
      () => _i770.UpdateUserCategoryUseCase(gh<_i482.CategoryRepository>()),
    );
    gh.singleton<_i823.LoadCategoriesUseCase>(
      () => _i823.LoadCategoriesUseCase(gh<_i482.CategoryRepository>()),
    );
    gh.singleton<_i276.WatchCategoriesUseCase>(
      () => _i276.WatchCategoriesUseCase(gh<_i482.CategoryRepository>()),
    );
    gh.lazySingleton<_i496.TransactionsRepository>(
      () => _i596.TransactionsRepositoryImpl(
        gh<_i376.TransactionsRemoteDataSource>(),
        gh<_i79.CurrentUser>(),
        gh<_i325.CurrentWorkspace>(),
      ),
    );
    gh.lazySingleton<_i874.WorkspaceRepository>(
      () => _i680.WorkspaceRepositoryImpl(
        gh<_i450.WorkspaceRemoteDataSource>(),
        gh<_i79.CurrentUser>(),
      ),
    );
    gh.lazySingleton<_i49.CategoriesService>(
      () => _i49.CategoriesService(
        gh<_i823.LoadCategoriesUseCase>(),
        gh<_i276.WatchCategoriesUseCase>(),
        gh<_i469.CreateUserCategoryUseCase>(),
        gh<_i770.UpdateUserCategoryUseCase>(),
        gh<_i380.DeleteUserCategoryUseCase>(),
      ),
    );
    gh.singleton<_i717.WatchTransactionsUseCase>(
      () => _i717.WatchTransactionsUseCase(gh<_i496.TransactionsRepository>()),
    );
    gh.factory<_i892.AddTransactionUseCase>(
      () => _i892.AddTransactionUseCase(gh<_i496.TransactionsRepository>()),
    );
    gh.factory<_i27.DeleteTransactionUseCase>(
      () => _i27.DeleteTransactionUseCase(gh<_i496.TransactionsRepository>()),
    );
    gh.factory<_i189.GetTransactionsOnceUseCase>(
      () =>
          _i189.GetTransactionsOnceUseCase(gh<_i496.TransactionsRepository>()),
    );
    gh.factory<_i288.UpdateTransactionUseCase>(
      () => _i288.UpdateTransactionUseCase(gh<_i496.TransactionsRepository>()),
    );
    gh.factory<_i983.SummaryBloc>(
      () => _i983.SummaryBloc(
        gh<_i79.CurrentUser>(),
        gh<_i717.WatchTransactionsUseCase>(),
        logger: gh<_i453.Logger>(),
      ),
    );
    gh.factory<_i990.WorkspaceBloc>(
      () => _i990.WorkspaceBloc(
        gh<_i874.WorkspaceRepository>(),
        gh<_i325.CurrentWorkspace>(),
        logger: gh<_i453.Logger>(),
      ),
    );
    gh.factory<_i437.AddTransactionBloc>(
      () => _i437.AddTransactionBloc(
        gh<_i892.AddTransactionUseCase>(),
        gh<_i49.CategoriesService>(),
        gh<_i288.UpdateTransactionUseCase>(),
      ),
    );
    gh.factory<_i551.TransactionsBloc>(
      () => _i551.TransactionsBloc(
        gh<_i717.WatchTransactionsUseCase>(),
        gh<_i892.AddTransactionUseCase>(),
        gh<_i288.UpdateTransactionUseCase>(),
        gh<_i27.DeleteTransactionUseCase>(),
      ),
    );
    gh.factory<_i1026.ExpenseBloc>(
      () => _i1026.ExpenseBloc(gh<_i892.AddTransactionUseCase>()),
    );
    gh.factory<_i494.BudgetBloc>(
      () => _i494.BudgetBloc(
        gh<_i192.WatchBudgetsUseCase>(),
        gh<_i105.AddBudgetUseCase>(),
        gh<_i740.UpdateBudgetUseCase>(),
        gh<_i1032.DeleteBudgetUseCase>(),
        gh<_i717.WatchTransactionsUseCase>(),
        gh<_i49.CategoriesService>(),
      ),
    );
    return this;
  }
}

class _$FirebaseModule extends _i93.FirebaseModule {}
