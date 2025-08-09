import 'package:flutter_core/flutter_core.dart';

class IntentUtils {
  static Future<bool> openBrowserURL({
    required Uri url,
    bool inApp = false,
  }) async {
    return await canLaunchUrl(url) ? await launchUrl(url) : false;
  }
}
