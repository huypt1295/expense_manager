import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_manager/core/di/injector.config.dart';
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
