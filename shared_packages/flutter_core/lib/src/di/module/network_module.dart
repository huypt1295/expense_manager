import 'package:dio/dio.dart';
import 'package:flutter_core/flutter_core.dart'
    show
        HttpInterceptor,
        CrashBreadcrumbInterceptor,
        RetryPolicy,
        ExponentialBackoff,
        dioShouldRetry;
import 'package:injectable/injectable.dart';


@module
abstract class NetworkModule {
  @lazySingleton
  Dio dio() => Dio(); // app set baseUrl/headers ở nơi khác (đúng tinh thần shared module)

  /// Danh sách interceptor ở DI: có thể push thêm ở app layer bằng @Named cùng tên.
  @Named('networkInterceptors')
  @lazySingleton
  List<HttpInterceptor> interceptors(
    CrashBreadcrumbInterceptor crash, // inject sẵn
  ) => [crash];

  @Named('networkRetryPolicy')
  @lazySingleton
  RetryPolicy get networkRetryPolicy => RetryPolicy(
        shouldRetry: dioShouldRetry,
        backoff: networkRetryBackoff,
      );

  @Named('networkRetryNonIdempotent')
  @lazySingleton
  bool get networkRetryNonIdempotent => false;

  @lazySingleton
  ExponentialBackoff get networkRetryBackoff => const ExponentialBackoff(
        maxRetries: 3,
        base: Duration(milliseconds: 250),
        max: Duration(seconds: 2),
      );

}