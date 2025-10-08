import 'package:expense_manager/core/config/app_config.dart';
import 'package:expense_manager/core/config/app_config_cubit.dart';
import 'package:expense_manager/core/routing/app_router.dart';
import 'package:expense_manager/features/auth/presentation/login/bloc/auth_bloc.dart';
import 'package:expense_manager/features/auth/presentation/login/bloc/auth_effect.dart';
import 'package:expense_manager/features/auth/presentation/login/bloc/auth_event.dart';
import 'package:expense_manager/features/auth/presentation/login/bloc/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_core/flutter_core.dart';
import 'package:flutter_resource/flutter_resource.dart';

class TPContainerApp extends StatefulWidget {
  final List<NavigatorObserver> navigatorObservers;

  const TPContainerApp({
    super.key,
    this.navigatorObservers = const <NavigatorObserver>[],
  });

  @override
  State<TPContainerApp> createState() => _TPContainerAppState();
}

class _TPContainerAppState extends State<TPContainerApp> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (context) =>
              tpGetIt.get<AuthBloc>()..add(const AuthEventWatchAuthState()),
        ),
      ],
      child: EffectBlocListener<AuthState, AuthEffect, AuthBloc>(
        listener: (effect, ui) {
          if (effect is AuthShowErrorEffect) {
            ui((ctx) => EasyLoading.showError(effect.message));
          }
        },
        child: BlocBuilder<ConfigCubit, AppConfig>(
          builder: (context, config) {
            return MaterialApp.router(
              theme: ThemeType.light.themeData,
              darkTheme: ThemeType.dark.themeData,
              themeMode: config.themeMode,
              localizationsDelegates: const [
                ...L10n.localizationsDelegates,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: L10n.supportedLocales,
              locale: config.locale,
              routerConfig: tpGetIt.get<AppRouter>().router(
                tpGetIt.get<GARouteObserver>(),
                tpGetIt.get<CrashRouteObserver>(),
              ),
              builder: (context, child) {
                return MediaQuery(
                  data: MediaQuery.of(
                    context,
                  ).copyWith(textScaler: const TextScaler.linear(1.0)),
                  child: EasyLoading.init()(context, child ?? Container()),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
