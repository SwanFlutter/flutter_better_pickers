// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_better_pickers/flutter_better_pickers.dart';
import 'package:flutter_better_pickers/src/tools/media_manager_wrapper.dart';
import 'package:flutter_better_pickers/src/tools/theme_generator.dart';
import 'package:flutter_better_pickers/src/widget/telegram/audio_telegram_widget.dart';
import 'package:flutter_better_pickers/src/widget/telegram/defult_builder_widget.dart';
import 'package:flutter_better_pickers/src/widget/telegram/file_device_widget.dart';
import 'package:flutter_better_pickers/src/widget/telegram/video_telegram_widget.dart';

late ThemeData theme;

typedef OnMediaPicked =
    void Function(List<String>? assets, List<String>? files);

class TelegramMediaPickers extends StatefulWidget {
  final int maxCountPickMedia;
  final MyRequestType requestType;
  final bool isRealCameraView;
  final OnMediaPicked? onMediaPicked;
  final int maxCountPickFiles;
  final CameraImageSettings? cameraImageSettings;

  /// Labels for internationalization
  final PickerLabels? labels;

  /// Style configuration
  final PickerStyle? style;

  const TelegramMediaPickers({
    super.key,
    required this.maxCountPickMedia,
    this.requestType = MyRequestType.all,
    this.isRealCameraView = true,
    this.onMediaPicked,
    this.maxCountPickFiles = 5,
    this.cameraImageSettings,
    this.labels,
    this.style,
  });

  @override
  State<TelegramMediaPickers> createState() => TelegramMediaPickersState();
}

class TelegramMediaPickersState extends State<TelegramMediaPickers>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  late Color primaryColor;

  PickerLabels get _labels => widget.labels ?? const PickerLabels();
  PickerStyle get _style => widget.style ?? const PickerStyle();

  bool isDraggableOpen = false;
  late DraggableScrollableController _controller;
  final ValueNotifier<double> _sizeNotifier = ValueNotifier<double>(0.5);
  final ValueNotifier<List<String>> selectedAssetListNotifier =
      ValueNotifier<List<String>>([]);
  OverlayEntry? _overlayEntry;

  String? selectedAlbumPath;
  String? selectedEntityPath;
  List<String> albumPaths = [];
  List<String> assetsPaths = [];
  List<int> albumFileCounts = [];
  List<File?> albumFirstImageFiles = [];
  List<String> selectedAssetList = [];

  bool isLoading = true;
  bool isVideo = false;
  bool isAudio = false;
  bool isFile = false;

  @override
  void initState() {
    super.initState();
    _controller = DraggableScrollableController();
    loadAlbums();
    _startLoading();
    primaryColor = _style.primaryColor;
    theme = ThemeGenerator.generateTheme(primaryColor: primaryColor);
  }

  @override
  void dispose() {
    _controller.dispose();
    _overlayEntry?.remove();
    selectedAssetListNotifier.dispose();
    _sizeNotifier.dispose();
    super.dispose();
  }

  Widget _buildBottomBarItem({
    required IconData icon,
    required String label,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Container(
          height: 56,
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  color: isActive
                      ? _style.primaryColor
                      : theme.colorScheme.onPrimary,
                  size: 20,
                ),
                const SizedBox(height: 2),
                Text(
                  label,
                  style: TextStyle(
                    color: isActive
                        ? _style.primaryColor
                        : theme.colorScheme.onPrimary,
                    fontSize: 9.0,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void toggleSheet(BuildContext context) {
    if (isDraggableOpen) {
      _overlayEntry?.remove();
      _overlayEntry = null;
      isFile = false;
      isVideo = false;
    } else {
      _overlayEntry = _createOverlayEntry();
      Overlay.of(context).insert(_overlayEntry!);
    }
    setState(() {
      isDraggableOpen = !isDraggableOpen;
    });
  }

  void _startLoading() {
    setState(() {
      isLoading = true;
    });
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    });
  }

  Future<void> loadAlbums({BuildContext? context}) async {
    try {
      List<String> paths = [];
      List<int> fileCounts = [];
      List<File?> firstImageFiles = [];

      switch (widget.requestType) {
        case MyRequestType.image:
          paths = await MediaManagerWrapper.getAllImages();
          break;
        case MyRequestType.video:
          paths = await MediaManagerWrapper.getAllVideos();
          break;
        case MyRequestType.audio:
          paths = await MediaManagerWrapper.getAllAudio();
          break;
        case MyRequestType.common:
        case MyRequestType.all:
          paths = await MediaManagerWrapper.getAllImages();
      }

      // Group by directory
      final Map<String, List<String>> grouped = {};
      for (var path in paths) {
        final dir = File(path).parent.path;
        grouped.putIfAbsent(dir, () => []).add(path);
      }

      for (var entry in grouped.entries) {
        fileCounts.add(entry.value.length);
        if (entry.value.isNotEmpty) {
          firstImageFiles.add(File(entry.value.first));
        } else {
          firstImageFiles.add(null);
        }
      }

      setState(() {
        albumPaths = grouped.keys.toList();
        albumFileCounts = fileCounts;
        albumFirstImageFiles = firstImageFiles;
        if (albumPaths.isNotEmpty) {
          selectedAlbumPath = albumPaths[0];
          loadAssets(albumPaths[0]);
        }
      });
    } catch (e) {
      debugPrint('Error loading albums: $e');
      if (context != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading albums: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> loadAssets(String albumPath) async {
    try {
      List<String> paths = [];

      switch (widget.requestType) {
        case MyRequestType.image:
          paths = await MediaManagerWrapper.getAllImages();
          break;
        case MyRequestType.video:
          paths = await MediaManagerWrapper.getAllVideos();
          break;
        case MyRequestType.audio:
          paths = await MediaManagerWrapper.getAllAudio();
          break;
        case MyRequestType.common:
        case MyRequestType.all:
          paths = await MediaManagerWrapper.getAllImages();
      }

      // Filter by album path
      final filtered = paths
          .where((p) => File(p).parent.path == albumPath)
          .toList();

      setState(() {
        selectedEntityPath = filtered.isNotEmpty ? filtered[0] : null;
        assetsPaths = filtered;
      });
    } catch (e) {
      debugPrint('Error loading assets: $e');
    }
  }

  OverlayEntry _createOverlayEntry() {
    return OverlayEntry(
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: MediaQuery.of(context).size.height,
            child: Material(
              color: Colors.transparent,
              child: GestureDetector(
                onTap: () {
                  toggleSheet(context);
                },
                child: Stack(
                  children: [
                    BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0),
                      child: Container(
                        color: Colors.black.withValues(alpha: 0.3),
                      ),
                    ),
                    SafeArea(
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          return Builder(
                            builder: (context) {
                              return Stack(
                                children: [
                                  DraggableScrollableSheet(
                                    controller: _controller,
                                    initialChildSize: 0.5,
                                    minChildSize: 0.2,
                                    maxChildSize: 1.0,
                                    builder: (context, scrollController) {
                                      _controller.addListener(() {
                                        _sizeNotifier.value = _controller.size;
                                      });

                                      if (isFile) {
                                        return FileListScreen(
                                          scrollController: scrollController,
                                          overlayEntry: _overlayEntry!,
                                          maxCountPickFiles:
                                              widget.maxCountPickFiles,
                                          labels: _labels,
                                          style: _style,
                                          toggleSheet: () {
                                            toggleSheet(context);
                                          },
                                          onFilesSelected:
                                              (assets, selectedFiles) {
                                                widget.onMediaPicked?.call(
                                                  null,
                                                  selectedFiles,
                                                );
                                                setState(() {});
                                              },
                                        );
                                      } else if (isVideo) {
                                        return VideoOnlyPage(
                                          widget: widget,
                                          controller: scrollController,
                                          maxCountPickFiles:
                                              widget.maxCountPickFiles,
                                          overlayEntry: _overlayEntry!,
                                          assetsList: assetsPaths,
                                          selectedAlbum:
                                              selectedAlbumPath ?? '',
                                          selectedEntity: selectedEntityPath,
                                          toggleSheet: () {
                                            toggleSheet(context);
                                          },
                                          onFilesSelected:
                                              (assets, selectedFiles) {
                                                widget.onMediaPicked?.call(
                                                  null,
                                                  selectedFiles,
                                                );
                                                setState(() {});
                                              },
                                        );
                                      } else if (isAudio) {
                                        return AudioTelegramWidget(
                                          scrollController: scrollController,
                                          maxCountPickFiles:
                                              widget.maxCountPickFiles,
                                          overlayEntry: _overlayEntry!,
                                          labels: _labels,
                                          style: _style,
                                          toggleSheet: () {
                                            toggleSheet(context);
                                          },
                                          onFilesSelected:
                                              (assets, selectedFiles) {
                                                widget.onMediaPicked?.call(
                                                  null,
                                                  selectedFiles,
                                                );
                                                setState(() {});
                                              },
                                        );
                                      } else {
                                        return DefultBuilderWidget(
                                          widget: widget,
                                          valueListenable: _sizeNotifier,
                                          toggleSheet: () {
                                            toggleSheet(context);
                                          },
                                          loadAlbums: loadAlbums,
                                          onAlbumChanged: (folder) {
                                            selectedAlbumPath = folder;
                                            loadAssets(folder);
                                          },
                                          overlayEntry: _overlayEntry!,
                                          isLoading: isLoading,
                                          isRealCameraView:
                                              widget.isRealCameraView,
                                          assetsList: assetsPaths,
                                          controller: scrollController,
                                          albumFileCounts: albumFileCounts,
                                          albumFirstImages:
                                              albumFirstImageFiles,
                                          albumList: albumPaths,
                                          selectedAlbum: selectedAlbumPath,
                                          selectedEntity: selectedEntityPath,
                                          onMediaPicked: (assets, files) {
                                            widget.onMediaPicked?.call(
                                              assets,
                                              null,
                                            );
                                            setState(() {});
                                          },
                                        );
                                      }
                                    },
                                  ),
                                  ValueListenableBuilder<double>(
                                    valueListenable: _sizeNotifier,
                                    builder: (context, size, child) {
                                      final showAppBar = size > 0.9;
                                      return Positioned(
                                        top: 0,
                                        right: 0,
                                        left: 0,
                                        child: Theme(
                                          data: theme,
                                          child: AnimatedOpacity(
                                            opacity: showAppBar ? 1.0 : 0.0,
                                            duration: const Duration(
                                              milliseconds: 400,
                                            ),
                                            child: AnimatedContainer(
                                              duration: const Duration(
                                                milliseconds: 400,
                                              ),
                                              height: showAppBar
                                                  ? MediaQuery.of(
                                                          context,
                                                        ).size.height *
                                                        0.075
                                                  : 0,
                                              color: theme.primaryColor,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 15.0,
                                                    ),
                                                child: Row(
                                                  children: [
                                                    IconButton(
                                                      onPressed: () {
                                                        toggleSheet(context);
                                                      },
                                                      icon: Icon(
                                                        Icons
                                                            .arrow_back_ios_new,
                                                        color: theme
                                                            .colorScheme
                                                            .onPrimary,
                                                      ),
                                                    ),
                                                    const SizedBox(width: 15),
                                                    InkWell(
                                                      onTap: () {
                                                        _showAlbumDialog(
                                                          context,
                                                        );
                                                      },
                                                      child: Row(
                                                        children: [
                                                          Text(
                                                            selectedAlbumPath !=
                                                                    null
                                                                ? selectedAlbumPath!
                                                                      .split(
                                                                        '/',
                                                                      )
                                                                      .last
                                                                : 'Gallery',
                                                            style:
                                                                const TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize:
                                                                      22.0,
                                                                ),
                                                          ),
                                                          const SizedBox(
                                                            width: 5,
                                                          ),
                                                          Icon(
                                                            Icons
                                                                .keyboard_arrow_down_sharp,
                                                            color: theme
                                                                .colorScheme
                                                                .onPrimary,
                                                            size: 28,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                  ValueListenableBuilder<double>(
                                    valueListenable: _sizeNotifier,
                                    builder: (context, size, child) {
                                      final showBottomBar = size < 0.9;
                                      return Positioned(
                                        bottom: 0,
                                        right: 0,
                                        left: 0,
                                        child: AnimatedOpacity(
                                          opacity: showBottomBar ? 1.0 : 0.0,
                                          duration: const Duration(
                                            milliseconds: 300,
                                          ),
                                          child: ClipRect(
                                            child: AnimatedContainer(
                                              duration: const Duration(
                                                milliseconds: 300,
                                              ),
                                              height: showBottomBar ? 56 : 0,
                                              color: theme.primaryColor,
                                              child: showBottomBar
                                                  ? Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceEvenly,
                                                      children: [
                                                        _buildBottomBarItem(
                                                          icon: CupertinoIcons
                                                              .doc,
                                                          label:
                                                              _labels.filesTab,
                                                          isActive: isFile,
                                                          onTap: () {
                                                            setState(() {
                                                              isFile = !isFile;
                                                              if (isFile) {
                                                                isVideo = false;
                                                                isAudio = false;
                                                              }
                                                            });
                                                            // Force overlay rebuild
                                                            this.setState(
                                                              () {},
                                                            );
                                                          },
                                                        ),
                                                        _buildBottomBarItem(
                                                          icon: CupertinoIcons
                                                              .video_camera,
                                                          label:
                                                              _labels.videosTab,
                                                          isActive: isVideo,
                                                          onTap: () {
                                                            setState(() {
                                                              isVideo =
                                                                  !isVideo;
                                                              if (isVideo) {
                                                                isFile = false;
                                                                isAudio = false;
                                                              }
                                                            });
                                                            // Force overlay rebuild
                                                            this.setState(
                                                              () {},
                                                            );
                                                          },
                                                        ),
                                                        _buildBottomBarItem(
                                                          icon: CupertinoIcons
                                                              .music_note,
                                                          label:
                                                              _labels.audioTab,
                                                          isActive: isAudio,
                                                          onTap: () {
                                                            setState(() {
                                                              isAudio =
                                                                  !isAudio;
                                                              if (isAudio) {
                                                                isFile = false;
                                                                isVideo = false;
                                                              }
                                                            });
                                                            // Force overlay rebuild
                                                            this.setState(
                                                              () {},
                                                            );
                                                          },
                                                        ),
                                                      ],
                                                    )
                                                  : const SizedBox.shrink(),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _showAlbumDialog(BuildContext context) {
    OverlayEntry? albumOverlay;

    albumOverlay = OverlayEntry(
      builder: (ctx) => GestureDetector(
        onTap: () {
          albumOverlay?.remove();
        },
        child: Material(
          color: Colors.black54,
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: GestureDetector(
                onTap: () {}, // Prevent closing when tapping inside
                child: Container(
                  decoration: BoxDecoration(
                    color: theme.primaryColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _labels.selectAlbum,
                              style: TextStyle(
                                color: theme.colorScheme.onPrimary,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.close,
                                color: theme.colorScheme.onPrimary,
                              ),
                              onPressed: () {
                                albumOverlay?.remove();
                              },
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: albumPaths.length,
                          itemBuilder: (context, index) {
                            final albumName = albumPaths[index].split('/').last;
                            final isSelected =
                                albumPaths[index] == selectedAlbumPath;

                            return ListTile(
                              leading: ClipRRect(
                                borderRadius: BorderRadius.circular(6),
                                child: albumFirstImageFiles[index] != null
                                    ? Image.file(
                                        albumFirstImageFiles[index]!,
                                        width: 50,
                                        height: 50,
                                        fit: BoxFit.cover,
                                      )
                                    : Container(
                                        width: 50,
                                        height: 50,
                                        color: Colors.grey,
                                        child: const Icon(Icons.folder),
                                      ),
                              ),
                              title: Text(
                                albumName,
                                style: TextStyle(
                                  color: theme.colorScheme.onPrimary,
                                  fontWeight: isSelected
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                ),
                              ),
                              subtitle: Text(
                                '${albumFileCounts[index]} ${_labels.imagesTab}',
                                style: TextStyle(
                                  color: theme.colorScheme.onPrimary.withValues(
                                    alpha: 0.7,
                                  ),
                                ),
                              ),
                              trailing: isSelected
                                  ? Icon(
                                      Icons.check_circle,
                                      color: _style.primaryColor,
                                    )
                                  : null,
                              onTap: () {
                                setState(() {
                                  selectedAlbumPath = albumPaths[index];
                                  loadAssets(albumPaths[index]);
                                });
                                albumOverlay?.remove();
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(albumOverlay);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return const SizedBox.shrink();
  }

  @override
  bool get wantKeepAlive => true;
}
