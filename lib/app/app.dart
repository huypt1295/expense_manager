import 'package:expense_manager/core/config/app_config.dart';
import 'package:expense_manager/core/config/app_config_cubit.dart';
import 'package:expense_manager/core/routing/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_core/flutter_core.dart';
import 'package:flutter_resource/flutter_resource.dart';

class TPContainerApp extends StatefulWidget {
  const TPContainerApp({super.key});

  @override
  State<TPContainerApp> createState() => _TPContainerAppState();
}

class _TPContainerAppState extends State<TPContainerApp> {

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ConfigCubit, AppConfig>(
      builder: (context, config) {
        return MaterialApp.router(
          title: 'Flutter Container',
          theme: config.themeType.themeData,
          localizationsDelegates: const [
            ...L10n.localizationsDelegates,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: L10n.supportedLocales,
          locale: Locale(config.localize),
          routerConfig: tpGetIt.get<AppRouter>().router,
          builder: (context, child) {
            return MediaQuery(
              data: MediaQuery.of(context)
                  .copyWith(textScaler: const TextScaler.linear(1.0)),
              child: EasyLoading.init()(context, child ?? Container()),
            );
          },
        );
      },
    );
  }
}