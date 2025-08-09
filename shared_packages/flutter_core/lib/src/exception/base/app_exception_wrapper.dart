import 'dart:async';

import 'package:flutter_core/src/exception/base/app_exception.dart';

class AppExceptionWrapper {
  AppExceptionWrapper({
    required this.appException,
    this.doOnRetry,
    this.overrideMessage,
  });

  final AppException appException;
  final Future<void> Function()? doOnRetry;
  final String? overrideMessage;

  @override
  String toString() {
    return 'AppExceptionWrapper(appException: $appException, doOnRetry: $doOnRetry, overrideMessage: $overrideMessage)';
  }
}
