// ignore_for_file: unnecessary_import

library;

import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_better_pickers/src/bottom_sheet.dart';
import 'package:flutter_better_pickers/src/bottom_sheet_image_selector.dart';
import 'package:flutter_better_pickers/src/config/picker_labels.dart';
import 'package:flutter_better_pickers/src/config/picker_style.dart';
import 'package:flutter_better_pickers/src/custom_picker.dart';
import 'package:flutter_better_pickers/src/scaffold_bottom_sheet.dart';
import 'package:flutter_better_pickers/src/tools/media_services.dart'
    as media_services;
import 'package:flutter_better_pickers/src/widget/global/camera_image_setting.dart';
import 'package:flutter_saver/flutter_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:media_manager/media_manager.dart';

export 'package:flutter_better_pickers/src/config/media_manager_config.dart';
export 'package:flutter_better_pickers/src/config/picker_config.dart';
export 'package:flutter_better_pickers/src/config/picker_labels.dart';
export 'package:flutter_better_pickers/src/config/picker_style.dart';
export 'package:flutter_better_pickers/src/config/picker_theme.dart';
export 'package:flutter_better_pickers/src/custom_picker.dart';
export 'package:flutter_better_pickers/src/telegram_media_picker.dart';
export 'package:flutter_better_pickers/src/tools/media_cache_manager.dart';
export 'package:flutter_better_pickers/src/tools/media_services.dart';
export 'package:flutter_better_pickers/src/widget/global/camera_image_setting.dart';
export 'package:media_manager/media_manager.dart';

/// A stateful widget that allows users to pick media files from their device.
class FlutterBetterPicker extends StatefulWidget {
  final int maxCount;
  final media_services.MyRequestType requestType;
  final String confirmText;
  final Color confirmTextColor;
  final Color textColor;
  final Color backgroundColor;
  final Color appbarColor;
  final Color backBottomColor;
  final Color iconCameraColor;
  final Color iconGalleryColor;
  final Color iconSelectedListAlbumColor;
  final Color textSelectedListAssetColor;
  final Color backgroundDropDownColor;
  final Color nullColorText;
  final Color? textEmptyListColor;
  final String textEmptyList;
  final Widget? loading;
  final CameraImageSettings? cameraImageSettings;
  final Widget title;

  const FlutterBetterPicker({
    required this.maxCount,
    required this.requestType,
    this.confirmText = 'Send',
    this.confirmTextColor = Colors.white,
    this.textColor = Colors.white,
    this.backgroundColor = const Color(0xFF2A2D3E),
    this.appbarColor = const Color(0xFF2A2D3E),
    this.backBottomColor = Colors.white,
    this.iconCameraColor = Colors.white,
    this.iconGalleryColor = Colors.white,
    this.iconSelectedListAlbumColor = Colors.white,
    this.textSelectedListAssetColor = Colors.white,
    this.backgroundDropDownColor = Colors.white,
    this.nullColorText = Colors.white,
    this.textEmptyListColor = Colors.white,
    this.textEmptyList = 'No albums found.',
    this.loading,
    this.cameraImageSettings,
    this.title = const Text(
      'Album',
      style: TextStyle(fontSize: 22, color: Colors.white),
    ),
    super.key,
  });

  static String _getMediaTypeString(media_services.MyRequestType requestType) {
    switch (requestType) {
      case media_services.MyRequestType.image:
        return 'image';
      case media_services.MyRequestType.video:
        return 'video';
      case media_services.MyRequestType.audio:
        return 'audio';
      case media_services.MyRequestType.common:
      case media_services.MyRequestType.all:
        return 'image';
    }
  }

  static Future<List<String>> customPicker({
    required BuildContext context,
    required int maxCount,
    required media_services.MyRequestType requestType,
    final Key? key,
    bool showOnlyVideo = true,
    bool showOnlyImage = true,
    PickerLabels? labels,
    PickerStyle? style,
  }) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CustomPicker(
          maxCount: maxCount,
          requestType: requestType,
          showOnlyVideo: showOnlyVideo,
          showOnlyImage: showOnlyImage,
          labels: labels,
          style: style,
          key: key,
        ),
      ),
    );
    return (result != null && result.isNotEmpty) ? result : [];
  }

  static Future<List<String>> bottomSheets({
    required BuildContext context,
    required final int maxCount,
    required final media_services.MyRequestType requestType,
    final Key? key,
    final String confirmText = "Send",
    final String textEmptyList = "No albums found.",
    final Color? confirmButtonColor,
    final Color confirmTextColor = Colors.black,
    final Color? backgroundColor,
    final Color? textEmptyListColor,
    final Color? backgroundSnackBarColor,
    final Color? dropdownColor,
    final Widget iconCamera = const Icon(Icons.camera, color: Colors.black),
    final TextStyle textStyleDropdown = const TextStyle(
      fontSize: 18,
      color: Colors.black,
    ),
    CameraImageSettings? cameraImageSettings,
    PickerLabels? labels,
    PickerStyle? style,
  }) async {
    final result = await showModalBottomSheet<List<String>>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (BuildContext context) {
        return BottomSheets(
          maxCount: maxCount,
          requestType: requestType,
          backgroundColor: backgroundColor,
          backgroundSnackBarColor: backgroundSnackBarColor,
          confirmButtonColor: confirmButtonColor,
          confirmText: confirmText,
          confirmTextColor: confirmTextColor,
          key: key,
          textEmptyList: textEmptyList,
          textEmptyListColor: textEmptyListColor,
          dropdownColor: dropdownColor,
          iconCamera: iconCamera,
          textStyleDropdown: textStyleDropdown,
          cameraImageSettings: cameraImageSettings,
          labels: labels,
          style: style,
        );
      },
    );
    return (result != null && result.isNotEmpty) ? result : [];
  }

  static Future<List<String>> scaffoldBottomSheet({
    required BuildContext context,
    required int maxCount,
    required media_services.MyRequestType requestType,
    String confirmText = "Send",
    String textEmptyList = "No albums found.",
    Color? confirmButtonColor,
    Color confirmTextColor = Colors.black,
    Color? backgroundColor,
    Color? textEmptyListColor,
    Color? backgroundSnackBarColor,
    CameraImageSettings? cameraImageSettings,
    PickerLabels? labels,
    PickerStyle? style,
  }) async {
    final result = await showModalBottomSheet<List<String>>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (BuildContext context) {
        return ScaffoldBottomSheet(
          maxCount: maxCount,
          requestType: requestType,
          confirmText: confirmText,
          textEmptyList: textEmptyList,
          confirmButtonColor: confirmButtonColor,
          confirmTextColor: confirmTextColor,
          backgroundColor: backgroundColor,
          textEmptyListColor: textEmptyListColor,
          backgroundSnackBarColor: backgroundSnackBarColor,
          cameraImageSettings: cameraImageSettings,
          labels: labels,
          style: style,
        );
      },
    );
    return (result != null && result.isNotEmpty) ? result : [];
  }

  static Future<List<String>> bottomSheetImageSelector({
    required BuildContext context,
    required int maxCount,
    required media_services.MyRequestType requestType,
    String confirmText = "Send",
    String textEmptyList = "No albums found.",
    Color? confirmButtonColor,
    Color confirmTextColor = Colors.black,
    final Color? backgroundColor,
    final Color? textEmptyListColor,
    final Color? backgroundSnackBarColor,
    final Color? dropdownColor,
    final TextStyle textStyleDropdown = const TextStyle(
      fontSize: 18,
      color: Colors.black,
    ),
    final Widget iconCamera = const Icon(Icons.camera, color: Colors.black),
    final Widget? loading,
    CameraImageSettings? cameraImageSettings,
    PickerLabels? labels,
    PickerStyle? style,
  }) async {
    final result = await showModalBottomSheet<List<String>>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (BuildContext context) {
        return BottomSheetImageSelector(
          maxCount: maxCount,
          requestType: requestType,
          confirmText: confirmText,
          backgroundColor: backgroundColor,
          backgroundSnackBarColor: backgroundSnackBarColor,
          confirmButtonColor: confirmButtonColor,
          confirmTextColor: confirmTextColor,
          textEmptyList: textEmptyList,
          textEmptyListColor: textEmptyListColor,
          textStyleDropdown: textStyleDropdown,
          dropdownColor: dropdownColor,
          cameraImageSettings: cameraImageSettings,
          iconCamera: iconCamera,
          loading: loading,
          labels: labels,
          style: style,
        );
      },
    );
    return (result != null && result.isNotEmpty) ? result : [];
  }

  @override
  State<FlutterBetterPicker> createState() => _FlutterBetterPickerState();

  Future<List<String>> instagram(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FlutterBetterPicker(
          maxCount: maxCount,
          requestType: requestType,
          appbarColor: appbarColor,
          backBottomColor: backBottomColor,
          iconCameraColor: iconCameraColor,
          iconGalleryColor: iconGalleryColor,
          iconSelectedListAlbumColor: iconSelectedListAlbumColor,
          textSelectedListAssetColor: textSelectedListAssetColor,
          backgroundDropDownColor: backgroundDropDownColor,
          nullColorText: nullColorText,
          textColor: textColor,
          confirmText: confirmText,
          confirmTextColor: confirmTextColor,
          backgroundColor: backgroundColor,
        ),
      ),
    );
    return (result != null && result.isNotEmpty) ? result : [];
  }
}

class _FlutterBetterPickerState extends State<FlutterBetterPicker> {
  late MediaManager _mediaManager;

  List<String> _allMediaPaths = [];
  Map<String, List<String>> _folderMap = {};
  List<String> _folderNames = [];
  bool _isLoading = true;
  File? _cameraImage;
  bool _showFolderList = false;

  // استفاده از ValueNotifier برای جلوگیری از rebuild کل صفحه
  final ValueNotifier<List<String>> _filteredMediaPathsNotifier =
      ValueNotifier<List<String>>([]);
  final ValueNotifier<Set<String>> _selectedPathsNotifier =
      ValueNotifier<Set<String>>({});
  final ValueNotifier<String?> _selectedFolderNotifier = ValueNotifier<String?>(
    null,
  );

  @override
  void initState() {
    super.initState();
    _mediaManager = MediaManager();
    _loadMedia();
  }

  @override
  void dispose() {
    _filteredMediaPathsNotifier.dispose();
    _selectedPathsNotifier.dispose();
    _selectedFolderNotifier.dispose();
    super.dispose();
  }

  Future<void> _loadMedia() async {
    if (!mounted) return;

    setState(() => _isLoading = true);

    try {
      final mediaTypeStr = FlutterBetterPicker._getMediaTypeString(
        widget.requestType,
      );
      List<String> paths = [];

      switch (mediaTypeStr) {
        case 'image':
          paths = await _mediaManager.getAllImages();
          break;
        case 'video':
          paths = await _mediaManager.getAllVideos();
          break;
        case 'audio':
          paths = await _mediaManager.getAllAudio();
          break;
        default:
          paths = await _mediaManager.getAllImages();
      }

      // Group by folder
      final Map<String, List<String>> grouped = {};
      for (var path in paths) {
        final dir = File(path).parent.path;
        final folderName = dir.split('/').last;
        grouped.putIfAbsent(folderName, () => []).add(path);
      }

      if (mounted) {
        _allMediaPaths = paths;
        _folderMap = grouped;
        _folderNames = ['All Photos', ...grouped.keys];
        _selectedFolderNotifier.value = 'All Photos';
        _filteredMediaPathsNotifier.value = paths;
        setState(() => _isLoading = false);
      }
    } catch (e) {
      debugPrint('Error loading media: $e');
      if (mounted) {
        _allMediaPaths = [];
        _filteredMediaPathsNotifier.value = [];
        setState(() => _isLoading = false);
      }
    }
  }

  void _onFolderChanged(String folder) {
    _selectedFolderNotifier.value = folder;
    _showFolderList = false;
    if (folder == 'All Photos') {
      _filteredMediaPathsNotifier.value = _allMediaPaths;
    } else {
      _filteredMediaPathsNotifier.value = _folderMap[folder] ?? [];
    }
    setState(() {}); // فقط برای بستن لیست پوشه‌ها
  }

  void _toggleSelection(String path) {
    final currentSet = Set<String>.from(_selectedPathsNotifier.value);
    if (currentSet.contains(path)) {
      currentSet.remove(path);
    } else if (currentSet.length < widget.maxCount) {
      currentSet.add(path);
    }
    _selectedPathsNotifier.value = currentSet;
  }

  Future<void> _pickFromCamera() async {
    try {
      final pickedFile = await ImagePicker().pickImage(
        source: ImageSource.camera,
        imageQuality: widget.cameraImageSettings?.imageQuality,
        maxWidth: widget.cameraImageSettings?.maxWidth,
        maxHeight: widget.cameraImageSettings?.maxHeight,
      );

      if (pickedFile != null) {
        final imageFile = File(pickedFile.path);
        setState(() => _cameraImage = imageFile);

        final isSaved = await FlutterSaver.saveImageAndroid(
          fileImage: imageFile,
        );
        if (isSaved) {
          _loadMedia();
        }
      }
    } on PlatformException catch (e) {
      debugPrint('PlatformException: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: widget.backgroundColor,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: widget.appbarColor,
          leading: const BackButton(color: Colors.white),
          centerTitle: true,
          title: widget.title,
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 15.0),
              child: ValueListenableBuilder<Set<String>>(
                valueListenable: _selectedPathsNotifier,
                builder: (context, selectedPaths, child) {
                  return InkResponse(
                    onTap: () {
                      final selectedList = selectedPaths.toList();
                      if (selectedList.isEmpty && _cameraImage != null) {
                        selectedList.add(_cameraImage!.path);
                      }
                      if (selectedList.isNotEmpty) {
                        Navigator.pop(context, selectedList);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: const Color.fromARGB(
                              255,
                              39,
                              36,
                              36,
                            ),
                            margin: const EdgeInsets.all(15.0),
                            behavior: SnackBarBehavior.floating,
                            shape: BeveledRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            content: const Text("No image selected"),
                          ),
                        );
                      }
                    },
                    child: Text(
                      widget.confirmText,
                      style: TextStyle(color: widget.confirmTextColor),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
        body: _isLoading
            ? Center(
                child:
                    widget.loading ??
                    const CircularProgressIndicator.adaptive(),
              )
            : ValueListenableBuilder<List<String>>(
                valueListenable: _filteredMediaPathsNotifier,
                builder: (context, filteredMediaPaths, child) {
                  return CustomScrollView(
                    slivers: [
                      // تصویر ثابت در بالا
                      SliverToBoxAdapter(
                        child: _PreviewImage(
                          cameraImage: _cameraImage,
                          filteredMediaPaths: filteredMediaPaths,
                          requestType: widget.requestType,
                          mediaManager: _mediaManager,
                        ),
                      ),
                      // هدر با انتخاب پوشه و دکمه دوربین
                      ValueListenableBuilder<String?>(
                        valueListenable: _selectedFolderNotifier,
                        builder: (context, selectedFolder, child) {
                          return SliverPersistentHeader(
                            pinned: true,
                            delegate: _HeaderDelegate(
                              selectedFolder: selectedFolder ?? 'Gallery',
                              showFolderList: _showFolderList,
                              onFolderTap: () {
                                setState(() {
                                  _showFolderList = !_showFolderList;
                                });
                              },
                              onCameraTap: _pickFromCamera,
                              textColor: widget.textSelectedListAssetColor,
                              iconCameraColor: widget.iconCameraColor,
                              iconGalleryColor: widget.iconGalleryColor,
                            ),
                          );
                        },
                      ),
                      // لیست پوشه‌ها یا گرید تصاویر
                      if (_showFolderList)
                        _buildSliverFolderList()
                      else if (filteredMediaPaths.isEmpty)
                        SliverFillRemaining(
                          child: Center(
                            child: Text(
                              widget.textEmptyList,
                              style: TextStyle(color: widget.nullColorText),
                            ),
                          ),
                        )
                      else
                        _buildSliverGrid(filteredMediaPaths),
                    ],
                  );
                },
              ),
      ),
    );
  }

  Widget _buildSliverFolderList() {
    return ValueListenableBuilder<String?>(
      valueListenable: _selectedFolderNotifier,
      builder: (context, selectedFolder, child) {
        return SliverList(
          delegate: SliverChildBuilderDelegate((context, index) {
            final folder = _folderNames[index];
            final count = folder == 'All Photos'
                ? _allMediaPaths.length
                : (_folderMap[folder]?.length ?? 0);
            final isSelected = folder == selectedFolder;

            return _FolderListItem(
              folder: folder,
              count: count,
              isSelected: isSelected,
              allMediaPaths: _allMediaPaths,
              folderMap: _folderMap,
              textColor: widget.textColor,
              iconSelectedColor: widget.iconSelectedListAlbumColor,
              requestType: widget.requestType,
              mediaManager: _mediaManager,
              onTap: () => _onFolderChanged(folder),
            );
          }, childCount: _folderNames.length),
        );
      },
    );
  }

  Widget _buildSliverGrid(List<String> filteredMediaPaths) {
    return SliverGrid(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisSpacing: 1,
        crossAxisSpacing: 1,
      ),
      delegate: SliverChildBuilderDelegate((context, index) {
        final path = filteredMediaPaths[index];
        return _GridItem(
          key: ValueKey(path),
          path: path,
          selectedPathsNotifier: _selectedPathsNotifier,
          requestType: widget.requestType,
          mediaManager: _mediaManager,
          onTap: () => _toggleSelection(path),
        );
      }, childCount: filteredMediaPaths.length),
    );
  }
}

// Widget جداگانه برای Preview Image - rebuild نمیشه
class _PreviewImage extends StatelessWidget {
  final File? cameraImage;
  final List<String> filteredMediaPaths;
  final media_services.MyRequestType requestType;
  final MediaManager mediaManager;

  const _PreviewImage({
    required this.cameraImage,
    required this.filteredMediaPaths,
    required this.requestType,
    required this.mediaManager,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return SizedBox(
      height: size.height * 0.40,
      width: size.width,
      child: cameraImage != null
          ? Image.file(cameraImage!, fit: BoxFit.cover, width: size.width)
          : (filteredMediaPaths.isNotEmpty
                ? _MediaPreview(
                    path: filteredMediaPaths.first,
                    requestType: requestType,
                    mediaManager: mediaManager,
                    fit: BoxFit.cover,
                  )
                : const SizedBox.shrink()),
    );
  }
}

// Widget جداگانه برای Header - فقط وقتی تغییر کنه rebuild میشه
class _HeaderDelegate extends SliverPersistentHeaderDelegate {
  final String selectedFolder;
  final bool showFolderList;
  final VoidCallback onFolderTap;
  final VoidCallback onCameraTap;
  final Color textColor;
  final Color iconCameraColor;
  final Color iconGalleryColor;

  _HeaderDelegate({
    required this.selectedFolder,
    required this.showFolderList,
    required this.onFolderTap,
    required this.onCameraTap,
    required this.textColor,
    required this.iconCameraColor,
    required this.iconGalleryColor,
  });

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return DecoratedBox(
      decoration: const BoxDecoration(color: Color(0xFF212332)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
        child: Row(
          children: [
            GestureDetector(
              onTap: onFolderTap,
              child: Row(
                children: [
                  Text(
                    selectedFolder,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 20.0,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    showFolderList
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: iconGalleryColor,
                  ),
                ],
              ),
            ),
            const Spacer(),
            IconButton(
              onPressed: onCameraTap,
              icon: Icon(Icons.camera, color: iconCameraColor),
            ),
          ],
        ),
      ),
    );
  }

  @override
  double get maxExtent => 60.0;

  @override
  double get minExtent => 60.0;

  @override
  bool shouldRebuild(_HeaderDelegate oldDelegate) {
    return selectedFolder != oldDelegate.selectedFolder ||
        showFolderList != oldDelegate.showFolderList;
  }
}

// Widget جداگانه برای هر آیتم پوشه - فقط خودش rebuild میشه
class _FolderListItem extends StatelessWidget {
  final String folder;
  final int count;
  final bool isSelected;
  final List<String> allMediaPaths;
  final Map<String, List<String>> folderMap;
  final Color textColor;
  final Color iconSelectedColor;
  final media_services.MyRequestType requestType;
  final MediaManager mediaManager;
  final VoidCallback onTap;

  const _FolderListItem({
    required this.folder,
    required this.count,
    required this.isSelected,
    required this.allMediaPaths,
    required this.folderMap,
    required this.textColor,
    required this.iconSelectedColor,
    required this.requestType,
    required this.mediaManager,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.grey[800],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: folder == 'All Photos' && allMediaPaths.isNotEmpty
              ? _MediaPreview(
                  path: allMediaPaths.first,
                  requestType: requestType,
                  mediaManager: mediaManager,
                )
              : (folderMap[folder]?.isNotEmpty == true
                    ? _MediaPreview(
                        path: folderMap[folder]!.first,
                        requestType: requestType,
                        mediaManager: mediaManager,
                      )
                    : const Icon(Icons.folder, color: Colors.white)),
        ),
      ),
      title: Text(
        folder,
        style: TextStyle(
          color: textColor,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      subtitle: Text(
        '$count items',
        style: TextStyle(color: textColor.withValues(alpha: 0.7), fontSize: 12),
      ),
      trailing: isSelected ? Icon(Icons.check, color: iconSelectedColor) : null,
      onTap: onTap,
    );
  }
}

// Widget جداگانه برای هر آیتم گرید - فقط خودش rebuild میشه
class _GridItem extends StatelessWidget {
  final String path;
  final ValueNotifier<Set<String>> selectedPathsNotifier;
  final media_services.MyRequestType requestType;
  final MediaManager mediaManager;
  final VoidCallback onTap;

  const _GridItem({
    super.key,
    required this.path,
    required this.selectedPathsNotifier,
    required this.requestType,
    required this.mediaManager,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          Positioned.fill(
            child: _MediaPreview(
              path: path,
              requestType: requestType,
              mediaManager: mediaManager,
            ),
          ),
          ValueListenableBuilder<Set<String>>(
            valueListenable: selectedPathsNotifier,
            builder: (context, selectedPaths, child) {
              final isSelected = selectedPaths.contains(path);
              final selectedIndex = isSelected
                  ? selectedPaths.toList().indexOf(path) + 1
                  : 0;

              return Stack(
                children: [
                  Container(
                    color: isSelected ? Colors.white60 : Colors.transparent,
                  ),
                  if (isSelected)
                    Positioned(
                      top: 5,
                      right: 5,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 1.5),
                        ),
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "$selectedIndex",
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

// Widget جداگانه برای پیش‌نمایش رسانه
class _MediaPreview extends StatefulWidget {
  final String path;
  final media_services.MyRequestType requestType;
  final MediaManager mediaManager;
  final BoxFit fit;

  const _MediaPreview({
    required this.path,
    required this.requestType,
    required this.mediaManager,
    this.fit = BoxFit.cover,
  });

  @override
  State<_MediaPreview> createState() => _MediaPreviewState();
}

class _MediaPreviewState extends State<_MediaPreview> {
  Future<Uint8List?>? _future;

  @override
  void initState() {
    super.initState();
    _initFuture();
  }

  @override
  void didUpdateWidget(_MediaPreview oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.path != widget.path ||
        oldWidget.requestType != widget.requestType) {
      _initFuture();
    }
  }

  void _initFuture() {
    final mediaTypeStr = FlutterBetterPicker._getMediaTypeString(
      widget.requestType,
    );
    if (mediaTypeStr == 'image') {
      _future = widget.mediaManager.getImagePreview(widget.path);
    } else if (mediaTypeStr == 'video') {
      _future = widget.mediaManager.getVideoThumbnail(widget.path);
    }
  }

  @override
  Widget build(BuildContext context) {
    final mediaTypeStr = FlutterBetterPicker._getMediaTypeString(
      widget.requestType,
    );

    return FutureBuilder<Uint8List?>(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting &&
            snapshot.data == null) {
          return Container(
            color: Colors.grey[300],
            child: Icon(
              mediaTypeStr == 'video' ? Icons.video_file : Icons.image,
              color: Colors.grey,
            ),
          );
        }
        if (snapshot.hasData && snapshot.data != null) {
          return Stack(
            fit: StackFit.expand,
            children: [
              Image.memory(
                snapshot.data!,
                fit: widget.fit,
                filterQuality: FilterQuality.low,
              ),
              if (mediaTypeStr == 'video')
                const Positioned(
                  bottom: 4,
                  right: 4,
                  child: Icon(Icons.play_arrow, color: Colors.white, size: 16),
                ),
            ],
          );
        }
        return Container(
          color: Colors.grey[300],
          child: const Icon(Icons.file_present, color: Colors.grey),
        );
      },
    );
  }
}
