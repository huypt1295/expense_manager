import 'package:flutter/services.dart';
import 'package:flutter_common/src/utils/intent_utils.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const MethodChannel channel =
      MethodChannel('plugins.flutter.io/url_launcher');
  TestWidgetsFlutterBinding.ensureInitialized();

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  test('openBrowserURL returns true when the url can be launched', () async {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
      if (methodCall.method == 'canLaunch') {
        return true;
      }
      if (methodCall.method == 'launch') {
        return true;
      }

      return false;
    });

    final result =
        await IntentUtils.openBrowserURL(url: Uri.parse('https://example.com'));

    expect(result, isTrue);
  });

  test('openBrowserURL returns false when the url cannot be launched',
      () async {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
      if (methodCall.method == 'canLaunch') {
        return false;
      }

      return false;
    });

    final result =
        await IntentUtils.openBrowserURL(url: Uri.parse('https://example.com'));

    expect(result, isFalse);
  });

  test('openBrowserURL returns false when launch fails', () async {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
      if (methodCall.method == 'canLaunch') {
        return true;
      }
      if (methodCall.method == 'launch') {
        return false;
      }

      return false;
    });

    final result =
        await IntentUtils.openBrowserURL(url: Uri.parse('https://example.com'));

    expect(result, isFalse);
  });
}
