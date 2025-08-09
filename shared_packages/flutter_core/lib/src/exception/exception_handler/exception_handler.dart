import 'package:flutter/material.dart';
import 'package:flutter_core/flutter_core.dart';

class ExceptionHandler {
  static final ExceptionHandler _instance = ExceptionHandler._internal();

  factory ExceptionHandler() => _instance;

  ExceptionHandler._internal();

  BuildContext? _context;

  void initialize(BuildContext context) {
    _context = context;
  }

  Future<void> handleException(
    AppExceptionWrapper appExceptionWrapper,
  ) async {
    final String message =
        (appExceptionWrapper.overrideMessage?.isNotEmpty ?? false)
            ? appExceptionWrapper.overrideMessage!
            : _deriveMessage(appExceptionWrapper.appException);

    switch (appExceptionWrapper.appException.appExceptionType) {
      case AppExceptionType.remote:
        final exception = appExceptionWrapper.appException as RemoteException;
        switch (exception.kind) {
          case RemoteExceptionKind.refreshTokenFailed:
            await _showErrorDialog(
              isRefreshTokenFailed: true,
              message: message,
            );
            break;
          case RemoteExceptionKind.noInternet:
          case RemoteExceptionKind.timeout:
            await _showErrorDialogWithRetry(
              message: message,
              onRetryPressed: () async {
                Navigator.of(_context!).pop();
                await appExceptionWrapper.doOnRetry?.call();
              },
            );
            break;
          default:
            await _showErrorDialog(message: message);
            break;
        }
        break;
      case AppExceptionType.parse:
        return _showErrorSnackBar(message: message);
      case AppExceptionType.remoteConfig:
        return _showErrorSnackBar(message: message);
      case AppExceptionType.uncaught:
        await _showErrorDialog(message: message);
      case AppExceptionType.validation:
        await _showErrorDialog(message: message);
        break;
    }
  }

  Future<void> _showErrorSnackBar({
    required String message,
  }) async {
    ScaffoldMessenger.of(_context!).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  Future<void> _showErrorDialog({
    required String message,
    VoidCallback? onPressed,
    bool isRefreshTokenFailed = false,
  }) async {
    showDialog(
      context: _context!,
      builder: (context) => AlertDialog(
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              if (onPressed != null) {
                onPressed();
              } else {
                Navigator.of(context).pop();
              }
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<void> _showErrorDialogWithRetry({
    required String message,
    VoidCallback? onPressed,
    required VoidCallback onRetryPressed,
  }) async {
    showDialog(
      context: _context!,
      builder: (context) => AlertDialog(
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              if (onPressed != null) {
                onPressed();
              } else {
                Navigator.of(context).pop();
              }
            },
            child: const Text('OK'),
          ),
          TextButton(
            onPressed: onRetryPressed,
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  String _deriveMessage(AppException exception) {
    if (exception is RemoteException) {
      return exception.generalServerMessage ??
          'Something went wrong. Please try again.';
    }
    return 'Something went wrong. Please try again.';
  }
}
