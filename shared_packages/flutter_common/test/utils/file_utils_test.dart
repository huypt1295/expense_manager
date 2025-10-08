import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_common/src/utils/file_utils.dart';
import 'package:flutter_core/flutter_core.dart' hide test;
import 'package:flutter_test/flutter_test.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'test_utils.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late Directory tempDir;
  late Directory documentsDir;
  late Directory supportDir;
  late Directory tempRoot;
  late Directory docsRoot;
  late Directory supportRoot;
  late PathProviderPlatform originalPlatform;

  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  setUp(() {
    originalPlatform = PathProviderPlatform.instance;
    tempDir = createTempDir('temp');
    documentsDir = createTempDir('docs');
    supportDir = createTempDir('support');
    tempRoot = tempDir.parent;
    docsRoot = documentsDir.parent;
    supportRoot = supportDir.parent;

    PathProviderPlatform.instance = TestPathProviderPlatform(
      temporaryPath: tempDir.path,
      applicationDocumentsPath: documentsDir.path,
      applicationSupportPath: supportDir.path,
    );

    FileUtils.defaultDir = null;
  });

  tearDown(() async {
    PathProviderPlatform.instance = originalPlatform;
    if (await tempRoot.exists()) {
      await tempRoot.delete(recursive: true);
    }
    if (await docsRoot.exists()) {
      await docsRoot.delete(recursive: true);
    }
    if (await supportRoot.exists()) {
      await supportRoot.delete(recursive: true);
    }
  });

  test('writeFile saves to documents directory by default', () async {
    final bytes = Uint8List.fromList([1, 2, 3]);

    final file = await FileUtils.writeFile('demo.txt', bytes);

    expect(file.existsSync(), isTrue);
    expect(file.path, '${documentsDir.path}/demo.txt');
    expect(file.readAsBytesSync(), bytes);
  });

  test('writeFile saves to temporary directory when requested', () async {
    final bytes = Uint8List.fromList([4, 5, 6]);

    final file = await FileUtils.writeFile('temp.dat', bytes, temporary: true);

    expect(file.existsSync(), isTrue);
    expect(file.path, '${tempDir.path}/temp.dat');
    expect(file.readAsBytesSync(), bytes);
  });

  test('writeFile applies defaultDir for temporary and document directories',
      () async {
    FileUtils.defaultDir = 'custom';
    final bytes = Uint8List.fromList([1, 2, 3]);

    // remove custom directories to exercise creation paths
    final customTempPath = '${tempDir.path}/custom';
    final customDocsPath = '${documentsDir.path}/custom';
    final customTempDir = Directory(customTempPath);
    if (customTempDir.existsSync()) {
      await customTempDir.delete(recursive: true);
    }
    final customDocsDir = Directory(customDocsPath);
    if (customDocsDir.existsSync()) {
      await customDocsDir.delete(recursive: true);
    }

    final tempFile =
        await FileUtils.writeFile('temp.txt', bytes, temporary: true);
    final docsFile = await FileUtils.writeFile('doc.txt', bytes);

    expect(tempFile.path, '$customTempPath/temp.txt');
    expect(docsFile.path, '$customDocsPath/doc.txt');
    expect(tempFile.existsSync(), isTrue);
    expect(docsFile.existsSync(), isTrue);

    FileUtils.defaultDir = null;
  });

  test('writeFile creates a new file when override is false and file exists',
      () async {
    final initialBytes = Uint8List.fromList([7, 8]);
    final newBytes = Uint8List.fromList([9, 10]);

    final first = await FileUtils.writeFile('duplicate.txt', initialBytes);
    final second = await FileUtils.writeFile('duplicate.txt', newBytes);

    expect(first.existsSync(), isTrue);
    expect(second.existsSync(), isTrue);
    expect(first.path, isNot(equals(second.path)));
    expect(first.readAsBytesSync(), initialBytes);
    expect(second.readAsBytesSync(), newBytes);
  });

  test('writeFile overwrites file when override is true', () async {
    final initialBytes = Uint8List.fromList([1]);
    final newBytes = Uint8List.fromList([2]);

    final file = await FileUtils.writeFile('override.bin', initialBytes);
    final overwritten = await FileUtils.writeFile(
      'override.bin',
      newBytes,
      override: true,
    );

    expect(file.path, overwritten.path);
    expect(overwritten.readAsBytesSync(), newBytes);
  });

  test('readFile returns the file content', () async {
    final bytes = Uint8List.fromList([11, 12, 13]);

    await FileUtils.writeFile('read.txt', bytes);

    final result = await FileUtils.readFile('read.txt');

    expect(result, bytes);
  });

  test('readFile returns null when file is missing', () async {
    final result = await FileUtils.readFile('missing.txt');

    expect(result, isNull);
  });

  test('getMimeType returns mime type based on file extension', () async {
    final file = File('${documentsDir.path}/file.json')
      ..createSync(recursive: true)
      ..writeAsStringSync('{}');

    expect(FileUtils.getMimeType(file), 'application/json');
  });

  test('isExist checks if a file exists on disk', () async {
    final file = File('${documentsDir.path}/exists.txt')
      ..createSync(recursive: true)
      ..writeAsStringSync('content');

    expect(FileUtils.isExist(file.path), isTrue);
    expect(FileUtils.isExist('${documentsDir.path}/missing.txt'), isFalse);
  });

  test('isFolder checks if path is a directory', () async {
    final dir = Directory('${documentsDir.path}/nested')
      ..createSync(recursive: true);
    final file = File('${documentsDir.path}/file.txt')
      ..createSync(recursive: true)
      ..writeAsStringSync('content');

    expect(FileUtils.isFolder(dir.path), isTrue);
    expect(FileUtils.isFolder(file.path), isFalse);
  });

  test('removeFile deletes file recursively', () async {
    final dir = Directory('${documentsDir.path}/remove')
      ..createSync(recursive: true);
    final file = File('${dir.path}/file.txt')
      ..createSync(recursive: true)
      ..writeAsStringSync('data');

    final result = await FileUtils.removeFile(dir.path);

    expect(result, isTrue);
    expect(dir.existsSync(), isFalse);
    expect(file.existsSync(), isFalse);
  });

  test('removeFile returns false when target is missing', () async {
    final result = await FileUtils.removeFile('${documentsDir.path}/missing');

    expect(result, isFalse);
  });

  test('getImageFileFromUrl returns null when the download fails', () async {
    final file =
        await FileUtils.getImageFileFromUrl('http://invalid.test/image.png');

    expect(file, isNull);
  });

  test('readFile handles missing platform directories gracefully', () async {
    PathProviderPlatform.instance = ThrowingPathProviderPlatform();

    final tempResult = await FileUtils.readFile('missing.txt', temporary: true);
    final docsResult = await FileUtils.readFile('missing.txt');

    expect(tempResult, isNull);
    expect(docsResult, isNull);
  });
}

class ThrowingPathProviderPlatform extends PathProviderPlatform {
  @override
  Future<String?> getTemporaryPath() async =>
      throw MissingPlatformDirectoryException('temp');

  @override
  Future<String?> getApplicationDocumentsPath() async =>
      throw MissingPlatformDirectoryException('docs');

  @override
  Future<String?> getApplicationSupportPath() async =>
      throw MissingPlatformDirectoryException('support');
}
