import 'dart:async';

import 'package:photo_manager/photo_manager.dart';

enum MyRequestType { common, audio, image, video, all }

RequestType _mapRequestType(MyRequestType requestType) {
  switch (requestType) {
    case MyRequestType.common:
      return RequestType.common;
    case MyRequestType.audio:
      return RequestType.audio;
    case MyRequestType.image:
      return RequestType.image;
    case MyRequestType.video:
      return RequestType.video;
    default:
      return RequestType.all;
  }
}

class MediaServices {
  static Future loadAlbums(MyRequestType requestType) async {
    var permission = await PhotoManager.requestPermissionExtend();

    List<AssetPathEntity> albumList = [];
    if (permission.isAuth == true) {
      final photoManagerRequestType = _mapRequestType(requestType);
      albumList = await PhotoManager.getAssetPathList(
        type: photoManagerRequestType,
      );
    } else {
      PhotoManager.openSetting();
    }
    return albumList;
  }

  static Future loadAssets(AssetPathEntity selectedAlbum) async {
    int assetCount = await selectedAlbum.assetCountAsync;
    List<AssetEntity> assetsList = await selectedAlbum.getAssetListRange(
      start: 0,
      end: assetCount,
    );
    return assetsList;
  }
}

class MediaServices1 {
  Future loadAlbums(MyRequestType requestType) async {
    var permission = await PhotoManager.requestPermissionExtend();
    List<AssetPathEntity> albumList = [];
    if (permission.isAuth == true) {
      final photoManagerRequestType = _mapRequestType(requestType);
      albumList = await PhotoManager.getAssetPathList(
        type: photoManagerRequestType,
      );
    } else {
      PhotoManager.openSetting();
    }
    return albumList;
  }

  Future<List<AssetEntity>> loadAssets(AssetPathEntity selectedAlbum) async {
    int assetCount = await selectedAlbum.assetCountAsync;
    List<AssetEntity> assetsList = await selectedAlbum.getAssetListRange(
      start: 0,
      end: assetCount,
    );
    return assetsList;
  }
}

class MediaServicesBottomSheet {
  Future<List<AssetPathEntity>> loadAlbums(MyRequestType requestType) async {
    var permission = await PhotoManager.requestPermissionExtend();
    List<AssetPathEntity> albumList = [];
    if (permission.isAuth == true) {
      final photoManagerRequestType = _mapRequestType(requestType);
      albumList = await PhotoManager.getAssetPathList(
        type: photoManagerRequestType,
      );
    } else {
      PhotoManager.openSetting();
    }
    return albumList;
  }

  Future<List<AssetEntity>> loadAssets(AssetPathEntity selectedAlbum) async {
    int assetCount = await selectedAlbum.assetCountAsync;
    List<AssetEntity> assetsList = await selectedAlbum.getAssetListRange(
      start: 0,
      end: assetCount,
    );
    return assetsList;
  }
}

class MediaServicesBottomSheetImageSelector {
  static Future loadAlbums(MyRequestType requestType) async {
    var permission = await PhotoManager.requestPermissionExtend();

    List<AssetPathEntity> albumList = [];
    if (permission.isAuth == true) {
      final photoManagerRequestType = _mapRequestType(requestType);
      albumList = await PhotoManager.getAssetPathList(
        type: photoManagerRequestType,
      );
    } else {
      PhotoManager.openSetting();
    }
    return albumList;
  }

  static Future loadAssets(AssetPathEntity selectedAlbum) async {
    int assetCount = await selectedAlbum.assetCountAsync;
    List<AssetEntity> assetsList = await selectedAlbum.getAssetListRange(
      start: 0,
      end: assetCount,
    );
    return assetsList;
  }
}

///////////////////////////////////////////////////
///////////////////////////////////////////////////
///
///
///
///
///

///////////////////////////////////////////////////////
///
///
///
///
///
///
///
///
