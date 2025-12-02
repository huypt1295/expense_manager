import 'dart:io';
import 'dart:typed_data';
import 'package:flutter_core/flutter_core.dart';

/// Utility helpers for reading, writing, and managing files on disk.
class FileUtils {
  /// If set, we want to save all files into a specific folder
  static String? defaultDir;

  /// Downloads the file at [imageUrl] into the cache and returns it when
  /// successful.
  ///
  /// Returns `null` if the file cannot be retrieved.
  static Future<File?> getImageFileFromUrl(String imageUrl) async {
    try {
      return await DefaultCacheManager().getSingleFile(imageUrl);
    } catch (_) {
      return null;
    }
  }

  /// Read content of file by file-name
  ///
  /// Example:
  /// ```dart
  /// final fileContent = await FileUtils.readFile('temp-file.txt');
  ///
  /// // read png image from cached folder
  /// final pngContent = await FileUtils.readFile('my-avatar.png', temporary: true);
  /// ```
  static Future<Uint8List?> readFile(String filename, {bool temporary = false}) async {
    final theFile = await _getFile(filename, temporary: temporary);
    if (theFile != null) {
      return await theFile.readAsBytes();
    }

    return null;
  }

  /// Writes [buffer] to a file with [filename], optionally using a temporary
  /// directory or generating a unique name when [override] is `false`.
  static Future<File> writeFile(
    String filename,
    Uint8List buffer, {
    bool temporary = false,
    bool override = false,
  }) async {
    final theFile = await _getFile(filename, temporary: temporary);
    if (theFile == null) {
      final newFilePath = await _filePath(filename, temporary: temporary);

      return await File(newFilePath).writeAsBytes(buffer);
    } else {
      if (override) {
        return await theFile.writeAsBytes(buffer);
      } else {
        final oldFileName = filename.split('.').toList();
        var fileExtension = '';
        if (oldFileName.length > 1) {
          fileExtension = '.${oldFileName.removeLast()}';
        }

        final newFileName =
            '${oldFileName.join(".")}_${(DateTime.now().millisecondsSinceEpoch) / 1000}$fileExtension';

        return await writeFile(newFileName, buffer, temporary: temporary, override: override);
      }
    }
  }

  /// Returns the MIME type for the provided [file], or `null` if unknown.
  static String? getMimeType(File file) {
    return lookupMimeType(file.path);
  }

  /// Checks whether a file exists at [filePath].
  static bool isExist(String filePath) {
    return File(filePath).existsSync();
  }

  /// Checks whether the path at [filePath] points to a directory.
  static bool isFolder(String filePath) {
    return FileSystemEntity.typeSync(filePath) == FileSystemEntityType.directory;
  }

  /// Deletes the file or directory at [filePath]. Returns `true` when the
  /// operation succeeds.
  static Future<bool> removeFile(String filePath) async {
    try {
      await File(filePath).delete(recursive: true);

      return true;
    // ignore: empty_catches
    } catch (e) {}

    return false;
  }

  /// Gets the app's temporary directory, optionally nested under [defaultDir].
  ///
  /// A temporary directory (cache) that the system can clear at any time.
  ///
  /// Returns `null` if the directory cannot be obtained.
  static Future<Directory?> _getTemporaryDir() async {
    try {
      final directory = await getTemporaryDirectory();
      final tempDirPath = "${directory.path}${defaultDir != null ? '/$defaultDir' : ''}";
      final tempDir = Directory(tempDirPath);
      if (!(await tempDir.exists())) {
        return await tempDir.create(recursive: true);
      }

      return tempDir;
    // coverage:ignore-start
    } on MissingPlatformDirectoryException catch (_) {}
    // coverage:ignore-end

    return null;
  }

  /// Gets the app's documents directory, optionally nested under [defaultDir].
  ///
  /// The system clears the directory only when the app is deleted.
  ///
  /// Returns `null` if the directory cannot be obtained.
  static Future<Directory?> _getDocumentDir() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final documentPath = "${directory.path}${defaultDir != null ? '/$defaultDir' : ''}";
      final documentDir = Directory(documentPath);
      if (!(await documentDir.exists())) {
        return await documentDir.create(recursive: true);
      }

      return documentDir;
    // coverage:ignore-start
    } on MissingPlatformDirectoryException catch (_) {}
    // coverage:ignore-end

    return null;
  }

  /// Resolves [filename] into a [File]. Returns `null` when the file does not
  /// exist on disk.
  static Future<File?> _getFile(String filename, {bool temporary = false}) async {
    final filePath = await _filePath(filename, temporary: temporary);
    final file = File(filePath);

    return (await file.exists()) ? file : null;
  }

  /// Returns a fully qualified file path for [filename] based on the selected
  /// storage location.
  static Future<String> _filePath(String filename, {bool temporary = false}) async {
    return temporary
        ? "${(await _getTemporaryDir())?.path ?? ''}/$filename"
        : "${(await _getDocumentDir())?.path ?? ''}/$filename";
  }
}
