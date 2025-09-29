//@GeneratedMicroModule;FlutterCorePackageModule;package:flutter_core/src/di/injector.module.dart
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i687;

import 'package:dio/dio.dart' as _i361;
import 'package:firebase_analytics/firebase_analytics.dart' as _i398;
import 'package:firebase_crashlytics/firebase_crashlytics.dart' as _i141;
import 'package:flutter_core/flutter_core.dart' as _i453;
import 'package:flutter_core/src/data/monitoring/ga/firebase_ga_analytics.dart'
    as _i869;
import 'package:flutter_core/src/data/network/http_client.dart' as _i1007;
import 'package:flutter_core/src/data/network/interceptor/breadcrumb_interceptor.dart'
    as _i814;
import 'package:flutter_core/src/di/module/network_module.dart' as _i581;
import 'package:flutter_core/src/di/module/third_party_module.dart' as _i706;
import 'package:flutter_core/src/domain/analytics/analytics_service.dart'
    as _i125;
import 'package:flutter_core/src/domain/analytics/analytics_service_impl.dart'
    as _i805;
import 'package:flutter_core/src/foundation/monitoring/adapters/firebase_crash_reporter.dart'
    as _i332;
import 'package:flutter_core/src/foundation/monitoring/analytics.dart' as _i764;
import 'package:flutter_core/src/foundation/monitoring/crash_reporter.dart'
    as _i947;
import 'package:flutter_core/src/presentation/bloc/crash_bloc_observer.dart'
    as _i959;
import 'package:flutter_core/src/presentation/navigation/crash_route_observer.dart'
    as _i512;
import 'package:flutter_core/src/presentation/navigation/ga_route_observer.dart'
    as _i236;
import 'package:injectable/injectable.dart' as _i526;

class FlutterCorePackageModule extends _i526.MicroPackageModule {
// initializes the registration of main-scope dependencies inside of GetIt
  @override
  _i687.FutureOr<void> init(_i526.GetItHelper gh) {
    final networkModule = _$NetworkModule();
    final thirdPartyModule = _$ThirdPartyModule();
    gh.lazySingleton<_i453.ExponentialBackoff>(
        () => networkModule.networkRetryBackoff);
    gh.lazySingleton<_i361.Dio>(() => networkModule.dio());
    gh.lazySingleton<_i141.FirebaseCrashlytics>(
        () => thirdPartyModule.crashlytics);
    gh.lazySingleton<_i398.FirebaseAnalytics>(() => thirdPartyModule.analytics);
    gh.lazySingleton<_i947.CrashReporter>(
        () => _i332.FirebaseCrashReporter(gh<_i141.FirebaseCrashlytics>()));
    gh.lazySingleton<_i453.Analytics>(() => _i869.FirebaseGAAnalytics());
    gh.singleton<_i959.CrashBlocObserver>(
        () => _i959.CrashBlocObserver(gh<_i453.CrashReporter>()));
    gh.lazySingleton<_i512.CrashRouteObserver>(
        () => _i512.CrashRouteObserver(gh<_i453.CrashReporter>()));
    gh.lazySingleton<_i453.RetryPolicy>(
      () => networkModule.networkRetryPolicy,
      instanceName: 'networkRetryPolicy',
    );
    gh.lazySingleton<bool>(
      () => networkModule.networkRetryNonIdempotent,
      instanceName: 'networkRetryNonIdempotent',
    );
    gh.lazySingleton<_i814.CrashBreadcrumbInterceptor>(
        () => _i814.CrashBreadcrumbInterceptor(
              gh<_i453.CrashReporter>(),
              gh<_i453.Analytics>(),
            ));
    gh.lazySingleton<_i236.GARouteObserver>(
        () => _i236.GARouteObserver(gh<_i453.Analytics>()));
    gh.lazySingleton<_i125.AnalyticsService>(
        () => _i805.AnalyticsServiceImpl(gh<_i764.Analytics>()));
    gh.lazySingleton<List<_i453.HttpInterceptor>>(
      () => networkModule.interceptors(gh<_i453.CrashBreadcrumbInterceptor>()),
      instanceName: 'networkInterceptors',
    );
    gh.lazySingleton<_i1007.HttpClient>(() => _i1007.DioHttpClient(
          gh<_i361.Dio>(),
          gh<List<_i453.HttpInterceptor>>(instanceName: 'networkInterceptors'),
          policy: gh<_i453.RetryPolicy>(instanceName: 'networkRetryPolicy'),
          retryNonIdempotent:
              gh<bool>(instanceName: 'networkRetryNonIdempotent'),
        ));
  }
}

class _$NetworkModule extends _i581.NetworkModule {}

class _$ThirdPartyModule extends _i706.ThirdPartyModule {}
