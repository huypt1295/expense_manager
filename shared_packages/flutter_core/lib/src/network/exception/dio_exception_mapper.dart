import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_core/src/network/exception/base/exception_mapper.dart';
import 'package:flutter_core/src/network/exception/remote/remote_exception.dart';

class DioExceptionMapper extends ExceptionMapper<RemoteException> {
  DioExceptionMapper();

  @override
  RemoteException map(Object? exception) {
    if (exception is RemoteException) {
      return exception;
    }

    RemoteExceptionKind kind = RemoteExceptionKind.unknown;
    int? httpErrorCode;
    if (exception is DioException) {
      switch (exception.type) {
        case DioExceptionType.cancel:
          kind = RemoteExceptionKind.cancellation;
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.receiveTimeout:
        case DioExceptionType.sendTimeout:
          kind = RemoteExceptionKind.timeout;
        case DioExceptionType.badResponse:
          kind = RemoteExceptionKind.serverUndefined;
          httpErrorCode = exception.response?.statusCode ?? -1;
        case DioExceptionType.badCertificate:
          kind = RemoteExceptionKind.badCertificate;
        case DioExceptionType.connectionError:
          kind = RemoteExceptionKind.network;
        case DioExceptionType.unknown:
          if (exception.error is SocketException) {
            kind = RemoteExceptionKind.network;
          }

          if (exception.error is RemoteException) {
            return exception.error as RemoteException;
          }
      }
    }

    return RemoteException(
        kind: kind, rootException: exception, httpErrorCode: httpErrorCode);
  }
}
