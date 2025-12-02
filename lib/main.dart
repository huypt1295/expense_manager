import 'dart:async';

import 'package:expense_manager/app/app.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart' show PlatformDispatcher;
import 'package:flutter/material.dart';
import 'package:expense_manager/core/di/injector.dart';
import 'package:flutter_core/flutter_core.dart';
import 'package:flutter_resource/flutter_resource.dart' show TPAnims;
import 'core/config/app_config_cubit.dart';
import 'core/firebase/firebase_options.dart';

void main() async {
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
    if (tpGetIt.isRegistered<CrashReporter>()) {
      tpGetIt.get<CrashReporter>().recordFlutterError(details);
    }
  };

  runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      await configureDependencies();

      await tpGetIt.get<CrashReporter>().init();
      await tpGetIt.get<Analytics>().init();

      Bloc.observer = tpGetIt.get<CrashBlocObserver>();

      _configLoading();
      runApp(
        BlocProvider(
          create: (_) => ConfigCubit(),
          child: const TPContainerApp(),

        ),
      );
    },
    (error, stack) {
      if (tpGetIt.isRegistered<CrashReporter>()) {
        tpGetIt<CrashReporter>().recordError(error, stack, fatal: true);
      }
    },
  );

  PlatformDispatcher.instance.onError = (error, stack) {
    if (tpGetIt.isRegistered<CrashReporter>()) {
      tpGetIt<CrashReporter>().recordError(error, stack, fatal: true);
    }
    return true;
  };
}

void _configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..loadingStyle = EasyLoadingStyle.custom
    ..maskType = EasyLoadingMaskType.custom
    ..backgroundColor = Colors.transparent
    ..maskColor = Colors.black.withValues(alpha: 0.7)
    ..userInteractions = false
    ..boxShadow = []
    ..indicatorWidget = Lottie.asset(TPAnims.loading)
    ..indicatorColor = Colors.amber
    ..textColor = Colors.amber
    ..dismissOnTap = false;
}
