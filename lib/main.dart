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
    LoggerProvider.instance?.error('flutter.error', {
      'exception': details.exceptionAsString(),
      'stack': details.stack?.toString(),
    });
  };

  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
    await configureDependencies();
    _configLoading();
    runApp(
      BlocProvider(
        create: (_) => ConfigCubit(),
        child: const TPContainerApp(),
      ),
    );
  }, (error, stack) {
    LoggerProvider.instance?.error('zone.error', {
      'exception': error.toString(),
      'stack': stack.toString(),
    });
  });

  PlatformDispatcher.instance.onError = (error, stack) {
    LoggerProvider.instance?.error('platform.error', {
      'exception': error.toString(),
      'stack': stack.toString(),
    });
    return true;
  };
}

void _configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..loadingStyle = EasyLoadingStyle.custom
    ..maskType = EasyLoadingMaskType.custom
    ..backgroundColor = Colors.transparent
    ..maskColor = Colors.black.withOpacity(0.7)
    ..userInteractions = false
    ..boxShadow = []
    ..indicatorWidget = Lottie.asset(TPAnims.loading)
    ..indicatorColor = Colors.amber
    ..textColor = Colors.amber
    ..dismissOnTap = false;
}
