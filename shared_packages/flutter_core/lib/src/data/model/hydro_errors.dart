import 'package:flutter_core/flutter_core.dart';
import 'package:json_annotation/json_annotation.dart';

part 'hydro_errors.g.dart';

@JsonSerializable(explicitToJson: true)
class HydroErrors {
  String? description;
  int? responseCode;
  int? requestCode;
  ErrorMessage? errorMessage;

  HydroErrors(
      {this.description,
      this.responseCode,
      this.requestCode,
      this.errorMessage});

  factory HydroErrors.fromJson(Map<String, dynamic> json) =>
      _$HydroErrorsFromJson(json);

  Map<String, dynamic> toJson() => _$HydroErrorsToJson(this);

  HydroErrors.commonError() {
    description = null;
    responseCode = 0;
    requestCode = 0;
    errorMessage = ErrorMessage.createCommonMessage();
  }

  HydroErrors.commonError2() {
    description = null;
    responseCode = 0;
    requestCode = 0;
    errorMessage = ErrorMessage.createCommonMessage2();
  }

  HydroErrors.timeoutError() {
    description = null;
    responseCode = 0;
    requestCode = 0;
    errorMessage = ErrorMessage.createTimeoutErrorMessage();
  }

  String get message => errorMessage?.messages?.localize ?? "";

  String get title =>
      errorMessage?.titles?.localize ??
      TextLocalize(en: "Notification", vn: "Thông Báo").localize;

  String get errorCode => errorMessage?.errorCode ?? "";
}

@JsonSerializable()
class ErrorMessage {
  TextLocalize? titles;
  String? errorDesc;
  String? errorCode;
  TextLocalize? messages;

  ErrorMessage({this.titles, this.errorDesc, this.errorCode, this.messages});

  factory ErrorMessage.fromJson(Map<String, dynamic> json) =>
      _$ErrorMessageFromJson(json);

  Map<String, dynamic> toJson() => _$ErrorMessageToJson(this);

  ErrorMessage.createCommonMessage() {
    titles = TextLocalize(en: "Notification", vn: "Thông Báo");
    messages = TextLocalize(
        en: "An error has occurred. Please try again or call 1900 585 885 for further assistance",
        vn: "Đã có lỗi xảy ra. Vui lòng thử lại hoặc liên hệ tổng đài 1900 585 885 để được hỗ trợ.");
  }

  ErrorMessage.createCommonMessage2() {
    titles = TextLocalize(en: "Notification", vn: "Thông Báo");
    messages = TextLocalize(
        en: "Cannot update transaction data due to system error. Please try again later.",
        vn: "Không thể cập nhật dữ liệu giao dịch do lỗi hệ thống. Bạn vui lòng thử lại sau!");
  }

  ErrorMessage.createTimeoutErrorMessage() {
    titles = TextLocalize(en: "Notification", vn: "Thông Báo");
    messages = TextLocalize(
        en: "Cannot load transaction data, Please try again later",
        vn: "Không lấy được dữ liệu giao dịch, Bạn vui lòng thử lại sau");
  }
}

class TextLocalize {
  String? en;
  String? vn;

  TextLocalize({this.en, this.vn});

  TextLocalize.fromJson(Map<String, dynamic> json) {
    en = json['en'];
    vn = json['vn'];
  }

  TextLocalize.fromLocalize(String key) {
    // vn = tpGetIt.get<LocaleService>().getStringLocalization(key, 'vi');
    // en = tpGetIt.get<LocaleService>().getStringLocalization(key, 'en');
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['en'] = en;
    data['vn'] = vn;
    return data;
  }

  String get localize => "vi";
  // (tpGetIt.get<LocaleService>().currentLocale.languageCode == "vi"
  //     ? vn
  //     : en) ??
  // "";
}

class HttpException implements Exception {
  final HydroErrors? errors;

  HttpException(this.errors);
}
