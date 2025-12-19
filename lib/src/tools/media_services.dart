import 'dart:async';
import 'dart:io';

import 'package:external_path_ios_mac/external_path_ios_mac.dart';
import 'package:media_manager/media_manager.dart';
import 'package:native_android_path/native_android_path.dart';
import 'package:flutter_better_pickers/src/tools/media_manager_wrapper.dart';

enum MyRequestType { common, audio, image, video, all }

/// مدیریت دسترسی به رسانه‌ها با پشتیبانی Android و iOS
class MediaServices {
  static final MediaManager _mediaManager = MediaManager();
  static final NativeAndroidPath _nativeAndroidPath = NativeAndroidPath();
  static final ExternalPathIosMac _externalPathIosMac = ExternalPathIosMac();

  /// درخواست مجوز و بازگرداندن لیست آلبوم‌ها
  static Future<List<String>> loadAlbums(MyRequestType requestType) async {
    try {
      // درخواست مجوز
      final hasPermission = await MediaManagerWrapper.requestPermission();
      if (!hasPermission) {
        throw Exception('Storage permission denied');
      }

      // دریافت دایرکتوری‌های اصلی
      List<String> directories = [];

      if (Platform.isAndroid) {
        directories = await _getAndroidDirectories(requestType);
      } else if (Platform.isIOS) {
        directories = await _getIOSDirectories(requestType);
      }

      return directories;
    } catch (e) {
      throw Exception('Error loading albums: $e');
    }
  }

  /// دریافت دایرکتوری‌های Android
  static Future<List<String>> _getAndroidDirectories(
    MyRequestType requestType,
  ) async {
    List<String> directories = [];

    try {
      // دریافت مسیر‌های اصلی
      final downloadPath = await _nativeAndroidPath.getDownloadPath();
      final picturesPath = await _nativeAndroidPath.getPicturesPath();
      final moviesPath = await _nativeAndroidPath.getMoviesPath();
      final musicPath = await _nativeAndroidPath.getMusicPath();
      final documentsPath = await _nativeAndroidPath.getDocumentsPath();

      if (downloadPath != null) directories.add(downloadPath);
      if (picturesPath != null) directories.add(picturesPath);
      if (moviesPath != null) directories.add(moviesPath);
      if (musicPath != null) directories.add(musicPath);
      if (documentsPath != null) directories.add(documentsPath);
    } catch (e) {
      throw Exception('Error getting Android directories: $e');
    }

    return directories;
  }

  /// دریافت دایرکتوری‌های iOS
  static Future<List<String>> _getIOSDirectories(
    MyRequestType requestType,
  ) async {
    List<String> directories = [];

    try {
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

      if (downloadPath != null) directories.add(downloadPath);
      if (picturesPath != null) directories.add(picturesPath);
      if (moviesPath != null) directories.add(moviesPath);
      if (musicPath != null) directories.add(musicPath);
      if (documentsPath != null) directories.add(documentsPath);
    } catch (e) {
      throw Exception('Error getting iOS directories: $e');
    }

    return directories;
  }

  /// دریافت فایل‌های یک دایرکتوری
  static Future<List<String>> loadAssets(String directoryPath) async {
    try {
      final contents = await _mediaManager.getDirectoryContents(directoryPath);
      return contents
          .where((item) => item['isDirectory'] == false)
          .map((item) => item['path'] as String)
          .toList();
    } catch (e) {
      throw Exception('Error loading assets: $e');
    }
  }

  /// دریافت تمام تصاویر
  static Future<List<String>> getAllImages() async {
    try {
      return await MediaManagerWrapper.getAllImages();
    } catch (e) {
      throw Exception('Error loading images: $e');
    }
  }

  /// دریافت تمام ویدئوها
  static Future<List<String>> getAllVideos() async {
    try {
      return await MediaManagerWrapper.getAllVideos();
    } catch (e) {
      throw Exception('Error loading videos: $e');
    }
  }

  /// دریافت تمام فایل‌های صوتی
  static Future<List<String>> getAllAudio() async {
    try {
      return await MediaManagerWrapper.getAllAudio();
    } catch (e) {
      throw Exception('Error loading audio: $e');
    }
  }

  /// دریافت تمام اسناد
  static Future<List<String>> getAllDocuments() async {
    try {
      return await MediaManagerWrapper.getAllDocuments();
    } catch (e) {
      throw Exception('Error loading documents: $e');
    }
  }

  /// دریافت تمام فایل‌های فشرده
  static Future<List<String>> getAllZipFiles() async {
    try {
      return await MediaManagerWrapper.getAllZipFiles();
    } catch (e) {
      throw Exception('Error loading zip files: $e');
    }
  }
}
