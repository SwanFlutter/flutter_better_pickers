import 'dart:io';

import 'package:external_path_ios_mac/external_path_ios_mac.dart';
import 'package:flutter/foundation.dart';
import 'package:media_manager/media_manager.dart';
import 'package:native_android_path/native_android_path.dart';
import 'package:permission_handler/permission_handler.dart';

/// Wrapper for media_manager with support for Android and iOS paths
class MediaManagerWrapper {
  static final MediaManager _mediaManager = MediaManager();
  static final NativeAndroidPath _nativeAndroidPath = NativeAndroidPath();
  static final ExternalPathIosMac _externalPathIosMac = ExternalPathIosMac();

  static final Map<String, Uint8List?> _mediaCache = {};
  static Future<bool>? _permissionRequestInFlight;

  static Future<bool> _requestPermissions({
    required bool photos,
    required bool videos,
    required bool audio,
    required bool storage,
  }) async {
    if (Platform.isAndroid) {
      final mediaPermissions = <Permission>[];
      if (photos) mediaPermissions.add(Permission.photos);
      if (videos) mediaPermissions.add(Permission.videos);
      if (audio) mediaPermissions.add(Permission.audio);

      if (mediaPermissions.isNotEmpty) {
        final statuses = await mediaPermissions.request();
        final mediaOk = statuses.values.every(
          (s) => s.isGranted || s.isLimited,
        );
        if (mediaOk) {
          return true;
        }
      }

      if (storage) {
        final storageStatus = await Permission.storage.request();
        return storageStatus.isGranted;
      }

      return false;
    }

    final permissions = <Permission>[];
    if (photos) permissions.add(Permission.photos);
    if (videos) permissions.add(Permission.videos);
    if (audio) permissions.add(Permission.audio);
    if (storage) permissions.add(Permission.storage);

    if (permissions.isEmpty) {
      return true;
    }

    final statuses = await permissions.request();
    return statuses.values.every((s) => s.isGranted || s.isLimited);
  }

  static Future<bool> _ensurePermission({
    required bool photos,
    required bool videos,
    required bool audio,
    required bool storage,
  }) async {
    final inFlight = _permissionRequestInFlight;
    if (inFlight != null) {
      return await inFlight;
    }

    final future = _requestPermissions(
      photos: photos,
      videos: videos,
      audio: audio,
      storage: storage,
    );
    _permissionRequestInFlight = future;
    try {
      return await future;
    } finally {
      if (_permissionRequestInFlight == future) {
        _permissionRequestInFlight = null;
      }
    }
  }

  /// درخواست مجوز
  static Future<bool> requestPermission() async {
    try {
      return await _ensurePermission(
        photos: true,
        videos: true,
        audio: true,
        storage: !Platform.isIOS,
      );
    } catch (e) {
      throw Exception('Permission request failed: $e');
    }
  }

  /// دریافت تمام تصاویر
  static Future<List<String>> getAllImages() async {
    try {
      final hasPermission = await _ensurePermission(
        photos: true,
        videos: false,
        audio: false,
        storage: !Platform.isIOS,
      );
      if (!hasPermission) throw Exception('Permission denied');
      return await _mediaManager.getAllImages();
    } catch (e) {
      throw Exception('Error loading images: $e');
    }
  }

  /// دریافت تمام ویدئوها
  static Future<List<String>> getAllVideos() async {
    try {
      final hasPermission = await _ensurePermission(
        photos: false,
        videos: true,
        audio: false,
        storage: !Platform.isIOS,
      );
      if (!hasPermission) throw Exception('Permission denied');
      return await _mediaManager.getAllVideos();
    } catch (e) {
      throw Exception('Error loading videos: $e');
    }
  }

  /// دریافت تمام فایل‌های صوتی
  static Future<List<String>> getAllAudio() async {
    try {
      final hasPermission = await _ensurePermission(
        photos: false,
        videos: false,
        audio: true,
        storage: !Platform.isIOS,
      );
      if (!hasPermission) throw Exception('Permission denied');
      return await _mediaManager.getAllAudio();
    } catch (e) {
      throw Exception('Error loading audio: $e');
    }
  }

  /// دریافت تمام اسناد
  static Future<List<String>> getAllDocuments() async {
    try {
      final hasPermission = await requestPermission();
      if (!hasPermission) throw Exception('Permission denied');
      return await _mediaManager.getAllDocuments();
    } catch (e) {
      throw Exception('Error loading documents: $e');
    }
  }

  /// دریافت تمام فایل‌های فشرده
  static Future<List<String>> getAllZipFiles() async {
    try {
      final hasPermission = await requestPermission();
      if (!hasPermission) throw Exception('Permission denied');
      return await _mediaManager.getAllZipFiles();
    } catch (e) {
      throw Exception('Error loading zip files: $e');
    }
  }

  /// دریافت پیش‌نمایش تصویر با کش
  static Future<Uint8List?> getImagePreview(String path) async {
    if (_mediaCache.containsKey(path)) {
      return _mediaCache[path];
    }
    try {
      final data = await _mediaManager.getImagePreview(path);
      _mediaCache[path] = data;
      return data;
    } catch (e) {
      debugPrint('Error getting image preview for $path: $e');
      return null;
    }
  }

  /// دریافت تصویر بندانگشتی ویدئو با کش
  static Future<Uint8List?> getVideoThumbnail(String path) async {
    if (_mediaCache.containsKey(path)) {
      return _mediaCache[path];
    }
    try {
      final data = await _mediaManager.getVideoThumbnail(path);
      _mediaCache[path] = data;
      return data;
    } catch (e) {
      debugPrint('Error getting video thumbnail for $path: $e');
      return null;
    }
  }

  /// دریافت مسیرهای دایرکتوری‌های اصلی
  static Future<Map<String, String>> getDirectoryPaths() async {
    final paths = <String, String>{};

    try {
      if (Platform.isAndroid) {
        final downloadPath = await _nativeAndroidPath.getDownloadPath();
        final picturesPath = await _nativeAndroidPath.getPicturesPath();
        final moviesPath = await _nativeAndroidPath.getMoviesPath();
        final musicPath = await _nativeAndroidPath.getMusicPath();
        final documentsPath = await _nativeAndroidPath.getDocumentsPath();

        if (downloadPath != null) paths['downloads'] = downloadPath;
        if (picturesPath != null) paths['pictures'] = picturesPath;
        if (moviesPath != null) paths['movies'] = moviesPath;
        if (musicPath != null) paths['music'] = musicPath;
        if (documentsPath != null) paths['documents'] = documentsPath;
      } else if (Platform.isIOS) {
        final downloadPath = await _externalPathIosMac.getDirectoryPath(
          directory: DirectoryType.downloads,
        );
        final picturesPath = await _externalPathIosMac.getDirectoryPath(
          directory: DirectoryType.pictures,
        );
        final moviesPath = await _externalPathIosMac.getDirectoryPath(
          directory: DirectoryType.movies,
        );
        final musicPath = await _externalPathIosMac.getDirectoryPath(
          directory: DirectoryType.music,
        );
        final documentsPath = await _externalPathIosMac.getDirectoryPath(
          directory: DirectoryType.documents,
        );

        if (downloadPath != null) paths['downloads'] = downloadPath;
        if (picturesPath != null) paths['pictures'] = picturesPath;
        if (moviesPath != null) paths['movies'] = moviesPath;
        if (musicPath != null) paths['music'] = musicPath;
        if (documentsPath != null) paths['documents'] = documentsPath;
      }
    } catch (e) {
      throw Exception('Error getting directory paths: $e');
    }

    return paths;
  }

  /// دریافت محتویات دایرکتوری
  static Future<List<String>> getDirectoryContents(String path) async {
    try {
      final contents = await _mediaManager.getDirectoryContents(path);
      return contents
          .where((item) => item['isDirectory'] == false)
          .map((item) => item['path'] as String)
          .toList();
    } catch (e) {
      throw Exception('Error getting directory contents: $e');
    }
  }

  /// پاک کردن کش تصاویر
  static Future<void> clearImageCache() async {
    try {
      _mediaCache.clear();
      await _mediaManager.clearImageCache();
    } catch (e) {
      throw Exception('Error clearing cache: $e');
    }
  }
}
