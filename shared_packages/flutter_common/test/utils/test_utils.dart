import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_resource/flutter_resource.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';

AppColorSchemeExtension createAppColorSchemeExtension(
    {Color color = Colors.blue}) {
  return AppColorSchemeExtension(
    textMain: color,
    textSub: color,
    textPositive: color,
    textNegative: color,
    textWarning: color,
    textTertiary: color,
    textLink: color,
    textPlaceholder: color,
    textReverse: color,
    textNeutral: color,
    textPressed: color,
    textDisable: color,
    surfaceNegative: color,
    surfaceMain: color,
    surfacePositive: color,
    surfaceNeutral: color,
    surfaceWarning: color,
    surfaceOverlay: color,
    surfaceAccent: color,
    surfaceGreyComponent: color,
    surfaceNeutralComponent: color,
    surfacePositiveComponent: color,
    surfaceNegativeComponent: color,
    surfacePressed: color,
    surfaceDisable: color,
    surfaceNeutralComponent2: color,
    surfaceAccentComponent: color,
    surfaceGreyComponent2: color,
    surfaceSub: color,
    borderActive: color,
    borderDefault: color,
    borderPositiveComponent: color,
    borderNeutralComponent: color,
    iconWarning: color,
    iconNeutral: color,
    iconNegative: color,
    iconPositive: color,
    iconAccent: color,
    iconMain: color,
    iconSub: color,
    iconPlaceHolder: color,
    iconTertiary: color,
    iconReverse: color,
    iconPressed: color,
    iconDisable: color,
    shadowSub: color,
    shadowMain: color,
    backgroundSub: color,
    backgroundMain: color,
  );
}

class TestPathProviderPlatform extends PathProviderPlatform {
  TestPathProviderPlatform({
    required this.temporaryPath,
    required this.applicationDocumentsPath,
    String? applicationSupportPath,
  }) : applicationSupportPath =
            applicationSupportPath ?? applicationDocumentsPath;

  final String temporaryPath;
  final String applicationDocumentsPath;
  final String applicationSupportPath;

  @override
  Future<String?> getTemporaryPath() async => temporaryPath;

  @override
  Future<String?> getApplicationDocumentsPath() async =>
      applicationDocumentsPath;

  @override
  Future<String?> getDownloadsPath({Map<String, dynamic>? arguments}) async =>
      null;

  @override
  Future<String?> getLibraryPath() async => null;

  @override
  Future<String?> getApplicationSupportPath() async => applicationSupportPath;

  @override
  Future<List<String>?> getExternalStoragePaths(
          {StorageDirectory? type}) async =>
      null;

  @override
  Future<String?> getApplicationCachePath() async => temporaryPath;

  Future<String?> getExternalCachePath() async => null;

  Future<List<String>?> getExternalStoragePathsForSystem(
          {StorageDirectory? type}) async =>
      null;

  Future<Uri?> getContainerUri(String appGroupIdentifier) async => null;
}

Directory createTempDir(String label) {
  final Directory tempBase =
      Directory.systemTemp.createTempSync('flutter_common_test');
  final Directory scoped = Directory('${tempBase.path}/$label')
    ..createSync(recursive: true);
  return scoped;
}
