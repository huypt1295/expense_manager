// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hydro_errors.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HydroErrors _$HydroErrorsFromJson(Map<String, dynamic> json) => HydroErrors(
      description: json['description'] as String?,
      responseCode: (json['responseCode'] as num?)?.toInt(),
      requestCode: (json['requestCode'] as num?)?.toInt(),
      errorMessage: json['errorMessage'] == null
          ? null
          : ErrorMessage.fromJson(json['errorMessage'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$HydroErrorsToJson(HydroErrors instance) =>
    <String, dynamic>{
      'description': instance.description,
      'responseCode': instance.responseCode,
      'requestCode': instance.requestCode,
      'errorMessage': instance.errorMessage?.toJson(),
    };

ErrorMessage _$ErrorMessageFromJson(Map<String, dynamic> json) => ErrorMessage(
      titles: json['titles'] == null
          ? null
          : TextLocalize.fromJson(json['titles'] as Map<String, dynamic>),
      errorDesc: json['errorDesc'] as String?,
      errorCode: json['errorCode'] as String?,
      messages: json['messages'] == null
          ? null
          : TextLocalize.fromJson(json['messages'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ErrorMessageToJson(ErrorMessage instance) =>
    <String, dynamic>{
      'titles': instance.titles,
      'errorDesc': instance.errorDesc,
      'errorCode': instance.errorCode,
      'messages': instance.messages,
    };
