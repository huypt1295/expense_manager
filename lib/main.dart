import 'dart:async';

import 'package:expense_manager/app/app.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_common/flutter_common.dart';
import 'package:expense_manager/core/config/app_config.dart';
import 'package:expense_manager/core/di/injector.dart';
import 'package:flutter_core/flutter_core.dart';
import 'package:flutter_resource/flutter_resource.dart' show TPAnims;
import 'core/config/app_config_cubit.dart';
import 'firebase_options.dart';

void main() async {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
    await configureDependencies();
    _configLoading();
    runApp(
      BlocProvider(
        create: (_) => ConfigCubit(AppConfig.initialConfig()),
        child: const TPContainerApp(),
      ),
    );
  }, (error, stack) {
    Log.e('Unhandled error', stackTrace: stack);
  });
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
