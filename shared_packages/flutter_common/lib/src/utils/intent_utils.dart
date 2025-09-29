import 'package:flutter_core/flutter_core.dart';

/// Wrapper utilities for launching platform intents.
class IntentUtils {
  /// Attempts to open [url] either in-app or via an external browser.
  ///
  /// The [inApp] toggle exists for API compatibility but is not currently used
  /// in this implementation.
  static Future<bool> openBrowserURL({
    required Uri url,
    bool inApp = false,
  }) async {
    return await canLaunchUrl(url) ? await launchUrl(url) : false;
  }
}
