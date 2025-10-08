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
import 'package:expense_manager/core/routing/app_router.dart' as _i861;
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
import 'package:expense_manager/features/categories/domain/usecases/load_categories_usecase.dart'
    as _i823;
import 'package:expense_manager/features/home/presentation/summary/bloc/summary_bloc.dart'
    as _i983;
import 'package:expense_manager/features/profile_setting/data/datasources/profile_remote_data_source.dart'
    as _i995;
import 'package:expense_manager/features/profile_setting/data/repositories/user_profile_repository_impl.dart'
    as _i279;
import 'package:expense_manager/features/profile_setting/domain/repositories/user_profile_repository.dart'
    as _i884;
import 'package:expense_manager/features/profile_setting/domain/usecases/get_profile_usecase.dart'
    as _i55;
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
import 'package:expense_manager/features/transactions/presentation/add_transaction/bloc/expense_bloc.dart'
    as _i626;
import 'package:expense_manager/features/transactions/presentation/transactions/bloc/transactions_bloc.dart'
    as _i551;
import 'package:firebase_storage/firebase_storage.dart' as _i457;
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
    gh.singleton<_i553.WatchAuthStateUseCase>(
      () => _i553.WatchAuthStateUseCase(gh<_i740.AuthRepository>()),
    );
    gh.singleton<_i864.SignInWithGoogleUseCase>(
      () => _i864.SignInWithGoogleUseCase(gh<_i740.AuthRepository>()),
    );
    gh.singleton<_i35.SignInWithFacebookUseCase>(
      () => _i35.SignInWithFacebookUseCase(gh<_i740.AuthRepository>()),
    );
    gh.singleton<_i1070.SignOutUseCase>(
      () => _i1070.SignOutUseCase(gh<_i740.AuthRepository>()),
    );
    gh.lazySingleton<_i376.TransactionsRemoteDataSource>(
      () => _i376.TransactionsRemoteDataSource(gh<_i974.FirebaseFirestore>()),
    );
    gh.lazySingleton<_i892.CategoryRemoteDataSource>(
      () => _i892.CategoryRemoteDataSource(gh<_i974.FirebaseFirestore>()),
    );
    gh.lazySingleton<_i78.BudgetRemoteDataSource>(
      () => _i78.BudgetRemoteDataSource(gh<_i974.FirebaseFirestore>()),
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
    gh.lazySingleton<_i995.ProfileRemoteDataSource>(
      () => _i995.ProfileRemoteDataSource(
        gh<_i974.FirebaseFirestore>(),
        gh<_i457.FirebaseStorage>(),
      ),
    );
    gh.lazySingleton<_i482.CategoryRepository>(
      () => _i939.CategoryRepositoryImpl(gh<_i892.CategoryRemoteDataSource>()),
    );
    gh.singleton<_i79.AccountActions>(
      () => _i655.AccountActionsFromAuth(gh<_i1070.SignOutUseCase>()),
    );
    gh.singleton<_i79.CurrentUser>(
      () => _i524.CurrentUserFromAuthBloc(gh<_i68.AuthBloc>()),
    );
    gh.lazySingleton<_i639.BudgetRepository>(
      () => _i932.BudgetRepositoryImpl(
        gh<_i78.BudgetRemoteDataSource>(),
        gh<_i79.CurrentUser>(),
      ),
    );
    gh.lazySingleton<_i884.UserProfileRepository>(
      () =>
          _i279.UserProfileRepositoryImpl(gh<_i995.ProfileRemoteDataSource>()),
    );
    gh.factory<_i631.UpdateProfileUseCase>(
      () => _i631.UpdateProfileUseCase(gh<_i884.UserProfileRepository>()),
    );
    gh.factory<_i655.UploadAvatarUseCase>(
      () => _i655.UploadAvatarUseCase(gh<_i884.UserProfileRepository>()),
    );
    gh.factory<_i55.GetProfileUseCase>(
      () => _i55.GetProfileUseCase(gh<_i884.UserProfileRepository>()),
    );
    gh.singleton<_i1022.WatchProfileUseCase>(
      () => _i1022.WatchProfileUseCase(gh<_i884.UserProfileRepository>()),
    );
    gh.factory<_i105.AddBudgetUseCase>(
      () => _i105.AddBudgetUseCase(gh<_i639.BudgetRepository>()),
    );
    gh.factory<_i740.UpdateBudgetUseCase>(
      () => _i740.UpdateBudgetUseCase(gh<_i639.BudgetRepository>()),
    );
    gh.factory<_i1032.DeleteBudgetUseCase>(
      () => _i1032.DeleteBudgetUseCase(gh<_i639.BudgetRepository>()),
    );
    gh.singleton<_i192.WatchBudgetsUseCase>(
      () => _i192.WatchBudgetsUseCase(gh<_i639.BudgetRepository>()),
    );
    gh.singleton<_i823.LoadCategoriesUseCase>(
      () => _i823.LoadCategoriesUseCase(gh<_i482.CategoryRepository>()),
    );
    gh.lazySingleton<_i496.TransactionsRepository>(
      () => _i596.TransactionsRepositoryImpl(
        gh<_i376.TransactionsRemoteDataSource>(),
        gh<_i79.CurrentUser>(),
      ),
    );
    gh.lazySingleton<_i49.CategoriesService>(
      () => _i49.CategoriesService(gh<_i823.LoadCategoriesUseCase>()),
    );
    gh.singleton<_i717.WatchTransactionsUseCase>(
      () => _i717.WatchTransactionsUseCase(gh<_i496.TransactionsRepository>()),
    );
    gh.factory<_i189.GetTransactionsOnceUseCase>(
      () =>
          _i189.GetTransactionsOnceUseCase(gh<_i496.TransactionsRepository>()),
    );
    gh.factory<_i892.AddTransactionUseCase>(
      () => _i892.AddTransactionUseCase(gh<_i496.TransactionsRepository>()),
    );
    gh.factory<_i288.UpdateTransactionUseCase>(
      () => _i288.UpdateTransactionUseCase(gh<_i496.TransactionsRepository>()),
    );
    gh.factory<_i27.DeleteTransactionUseCase>(
      () => _i27.DeleteTransactionUseCase(gh<_i496.TransactionsRepository>()),
    );
    gh.factory<_i983.SummaryBloc>(
      () => _i983.SummaryBloc(
        gh<_i79.CurrentUser>(),
        gh<_i717.WatchTransactionsUseCase>(),
        logger: gh<_i453.Logger>(),
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
    gh.factory<_i551.TransactionsBloc>(
      () => _i551.TransactionsBloc(
        gh<_i717.WatchTransactionsUseCase>(),
        gh<_i892.AddTransactionUseCase>(),
        gh<_i288.UpdateTransactionUseCase>(),
        gh<_i27.DeleteTransactionUseCase>(),
      ),
    );
    gh.factory<_i626.ExpenseBloc>(
      () => _i626.ExpenseBloc(gh<_i892.AddTransactionUseCase>()),
    );
    return this;
  }
}
