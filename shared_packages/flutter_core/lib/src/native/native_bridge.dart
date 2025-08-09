import 'dart:convert';

import 'package:flutter_core/src/data/model/hydro_errors.dart';
import 'package:flutter_core/src/native/constant.dart';

class NativeBridge {
  NativeBridge._();

  static final NativeBridge instance = NativeBridge._();

  Future<Map<String, dynamic>?> callApi({
    required String url,
    required String method,
    Map<String, dynamic>? params,
    String? apiServiceName,
    bool? loading,
    bool? isArrayBody,
    String? sync,
  }) async {
    try {
      var data = {
        'url': url,
        'method': method,
        'params': params,
        'apiServiceName': apiServiceName,
        'loading': loading,
        'isArrayBody': isArrayBody,
      };
      if (sync != null) {
        data['sync'] = sync;
      }
      final String? result =
          await kMethodChannel.invokeMethod(kOttApiChannelHost, data);
      if (result != null) {
        Map<String, dynamic> json = jsonDecode(result);
        if (json['errorMessage'] != null) {
          throw HydroErrors.fromJson(json);
        }
        return json;
      }
      throw HydroErrors.commonError();
    } catch (e) {
      rethrow;
    }
  }
}
