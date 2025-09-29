import 'package:injectable/injectable.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

@module
abstract class ThirdPartyModule {
  @lazySingleton
  FirebaseCrashlytics get crashlytics => FirebaseCrashlytics.instance;

  @lazySingleton
  FirebaseAnalytics get analytics => FirebaseAnalytics.instance;
}
