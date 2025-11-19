import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_manager/core/auth/current_user.dart';
import 'package:expense_manager/core/di/injector.config.dart';
import 'package:expense_manager/core/workspace/current_workspace.dart';
import 'package:expense_manager/features/workspace/data/datasources/household_remote_data_source.dart';
import 'package:expense_manager/features/workspace/data/datasources/workspace_remote_data_source.dart';
import 'package:expense_manager/features/workspace/data/repositories/household_repository_impl.dart';
import 'package:expense_manager/features/workspace/domain/repositories/household_repository.dart';
import 'package:expense_manager/features/workspace/domain/usecases/cancel_household_invitation_usecase.dart';
import 'package:expense_manager/features/workspace/domain/usecases/create_household_usecase.dart';
import 'package:expense_manager/features/workspace/domain/usecases/delete_household_usecase.dart';
import 'package:expense_manager/features/workspace/domain/usecases/ensure_personal_workspace_usecase.dart';
import 'package:expense_manager/features/workspace/domain/usecases/remove_household_member_usecase.dart';
import 'package:expense_manager/features/workspace/domain/usecases/send_household_invitation_usecase.dart';
import 'package:expense_manager/features/workspace/domain/usecases/update_household_member_role_usecase.dart';
import 'package:expense_manager/features/workspace/domain/usecases/watch_household_invitations_usecase.dart';
import 'package:expense_manager/features/workspace/domain/usecases/watch_household_members_usecase.dart';
import 'package:expense_manager/features/workspace/presentation/onboarding/cubit/household_onboarding_cubit.dart';
import 'package:expense_manager/features/workspace/presentation/settings/bloc/workspace_members_bloc.dart';
import 'package:flutter_common/flutter_common.dart';
import 'package:flutter_core/flutter_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_resource/flutter_resource.dart';
import 'package:google_sign_in/google_sign_in.dart';

@InjectableInit(
  includeMicroPackages: true,
  // ignoreUnregisteredTypesInPackages: ['flutter_core'],
  externalPackageModulesBefore: [
    ExternalModule(FlutterCorePackageModule),
    ExternalModule(FlutterCommonPackageModule),
    ExternalModule(FlutterResourcePackageModule),
  ],
  ignoreUnregisteredTypes: [
    FirebaseAuth,
    FirebaseFirestore,
    FirebaseStorage,
    GoogleSignIn,
    FacebookAuth,
  ],
  ignoreUnregisteredTypesInPackages: [
    'package:firebase_auth',
    'package:google_sign_in',
    'package:flutter_facebook_auth',
  ],
)
Future<GetIt> configureDependencies() async {
  final getIt = tpGetIt;

  await getIt.init();

  LoggerProvider.instance ??= getIt<Logger>();

  return getIt;
}
