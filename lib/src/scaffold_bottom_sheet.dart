// ignore_for_file: unnecessary_import

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_better_pickers/flutter_better_pickers.dart';
import 'package:flutter_better_pickers/src/tools/media_manager_wrapper.dart';
import 'package:flutter_better_pickers/src/widget/global/camera_image_setting.dart';
import 'package:flutter_better_pickers/src/widget/media_preview_widget.dart';
import 'package:flutter_saver/flutter_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

/// A bottom sheet widget for selecting media files with scaffold structure.
///
/// This widget provides a full-screen bottom sheet interface for selecting
/// images, videos, or other media types from device storage.
///
/// Example:
/// ```dart
/// ScaffoldBottomSheet(
///   maxCount: 5,
///   requestType: MyRequestType.image,
///   labels: PickerLabels.english,
///   style: PickerStyle.light,
/// )
/// ```
class ScaffoldBottomSheet extends StatefulWidget {
  /// Maximum number of media items that can be selected
  final int maxCount;

  /// Type of media to display (image, video, audio, etc.)
  final MyRequestType requestType;

  /// @deprecated Use [labels.confirmButtonText] instead
  /// Text for the confirm button
  final String confirmText;

  /// @deprecated Use [labels.noAlbumsFound] instead
  /// Text to display when no media is found
  final String textEmptyList;

  /// @deprecated Use [style.confirmButtonColor] instead
  /// Background color for the confirm button
  final Color? confirmButtonColor;

  /// @deprecated Use [style.confirmTextColor] instead
  /// Text color for the confirm button
  final Color confirmTextColor;

  /// @deprecated Use [style.backgroundColor] instead
  /// Background color of the bottom sheet
  final Color? backgroundColor;

  /// @deprecated Use [style.emptyListTextColor] instead
  /// Text color for empty list message
  final Color? textEmptyListColor;

  /// @deprecated Use [style.snackBarColor] instead
  /// Background color for snackbar messages
  final Color? backgroundSnackBarColor;

  /// Camera image settings for quality and dimensions
  final CameraImageSettings? cameraImageSettings;

  /// Labels for internationalization.
  /// Use predefined labels like [PickerLabels.english], [PickerLabels.persian],
  /// or create custom labels.
  final PickerLabels? labels;

  /// Style configuration for colors, sizes, and widgets.
  /// Use predefined styles like [PickerStyle.light], [PickerStyle.dark],
  /// [PickerStyle.telegram], or create custom styles.
  final PickerStyle? style;

  const ScaffoldBottomSheet({
    super.key,
    required this.maxCount,
    required this.requestType,
    this.confirmText = 'Send',
    this.textEmptyList = 'No albums found.',
    this.confirmButtonColor,
    this.confirmTextColor = Colors.black,
    this.backgroundColor,
    this.textEmptyListColor,
    this.backgroundSnackBarColor,
    this.cameraImageSettings,
    this.labels,
    this.style,
  });

  @override
  State<ScaffoldBottomSheet> createState() => _ScaffoldBottomSheetState();
}

class _ScaffoldBottomSheetState extends State<ScaffoldBottomSheet> {
  List<String> _allMediaPaths = [];
  List<String> _filteredMediaPaths = [];
  final ValueNotifier<List<String>> _selectedPathsNotifier =
      ValueNotifier<List<String>>([]);
  Map<String, List<String>> _folderMap = {};
  List<String> _folderNames = [];
  String? _selectedFolder;
  bool _isLoading = true;
  File? _cameraImage;

  PickerLabels get _labels => widget.labels ?? const PickerLabels();
  PickerStyle get _style => widget.style ?? const PickerStyle();

  @override
  void initState() {
    super.initState();
    _loadMedia();
  }

  @override
  void dispose() {
    _selectedPathsNotifier.dispose();
    super.dispose();
  }

  Future<void> _loadMedia() async {
    if (!mounted) return;

    setState(() => _isLoading = true);

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

      // Group by folder
      final Map<String, List<String>> grouped = {};
      for (var path in paths) {
        final dir = File(path).parent.path;
        final folderName = dir.split('/').last;
        grouped.putIfAbsent(folderName, () => []).add(path);
      }

      if (mounted) {
        setState(() {
          _allMediaPaths = paths;
          _folderMap = grouped;
          _folderNames = [_labels.allPhotos, ...grouped.keys];
          _selectedFolder = _labels.allPhotos;
          _filteredMediaPaths = paths;
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Error loading media: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
          _allMediaPaths = [];
          _filteredMediaPaths = [];
        });
      }
    }
  }

  void _onFolderChanged(String? folder) {
    if (folder == null) return;
    setState(() {
      _selectedFolder = folder;
      if (folder == _labels.allPhotos) {
        _filteredMediaPaths = _allMediaPaths;
      } else {
        _filteredMediaPaths = _folderMap[folder] ?? [];
      }
    });
  }

  void _toggleSelection(String path) {
    final currentList = List<String>.from(_selectedPathsNotifier.value);
    if (currentList.contains(path)) {
      currentList.remove(path);
    } else if (currentList.length < widget.maxCount) {
      currentList.add(path);
    }
    _selectedPathsNotifier.value = currentList;
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
    } catch (e) {
      debugPrint('Error picking image: $e');
    }
  }

  void _confirmSelection() {
    List<String> selectedPaths = _selectedPathsNotifier.value;
    if (selectedPaths.isEmpty && _cameraImage != null) {
      selectedPaths = [_cameraImage!.path];
    }

    if (selectedPaths.isNotEmpty) {
      Navigator.pop(context, selectedPaths);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('No media selected'),
          backgroundColor: widget.backgroundSnackBarColor ?? Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final bgColor = widget.backgroundColor ?? _style.backgroundColor;
    final textColor = widget.textEmptyListColor ?? _style.textColor;
    final buttonColor = widget.confirmButtonColor ?? _style.confirmButtonColor;

    return SafeArea(
      top: false,
      child: Container(
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(_style.bottomSheetBorderRadius),
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Row(
                children: [
                  // Folder dropdown
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: _style.dropdownColor,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _selectedFolder,
                          isExpanded: true,
                          icon: Icon(
                            Icons.keyboard_arrow_down,
                            color: textColor,
                          ),
                          dropdownColor: _style.dropdownColor,
                          style: TextStyle(fontSize: 16, color: textColor),
                          hint: Text(
                            _labels.selectMedia,
                            style: TextStyle(color: textColor),
                          ),
                          items: _folderNames.map((folder) {
                            final count = folder == _labels.allPhotos
                                ? _allMediaPaths.length
                                : (_folderMap[folder]?.length ?? 0);
                            return DropdownMenuItem<String>(
                              value: folder,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      folder,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Text(
                                    '($count)',
                                    style: TextStyle(
                                      color: _style.secondaryTextColor,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                          onChanged: _onFolderChanged,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    onPressed: _pickFromCamera,
                    icon:
                        _style.cameraIcon ??
                        Icon(Icons.camera_alt, color: _style.iconColor),
                  ),
                ],
              ),
            ),
            Expanded(
              child: _isLoading
                  ? Center(
                      child:
                          _style.loadingWidget ??
                          LoadingAnimationWidget.staggeredDotsWave(
                            color: _style.primaryColor,
                            size: 50,
                          ),
                    )
                  : (_filteredMediaPaths.isEmpty
                        ? Center(
                            child: Text(
                              widget.textEmptyList,
                              style:
                                  _style.emptyListTextStyle ??
                                  TextStyle(
                                    color: _style.emptyListTextColor,
                                    fontSize: 16,
                                  ),
                            ),
                          )
                        : GridView.builder(
                            padding: _style.gridPadding,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: _style.gridCrossAxisCount,
                                  crossAxisSpacing: _style.gridSpacing,
                                  mainAxisSpacing: _style.gridSpacing,
                                ),
                            itemCount: _filteredMediaPaths.length,
                            itemBuilder: (context, index) {
                              final path = _filteredMediaPaths[index];

                              return _GridItem(
                                path: path,
                                requestType: widget.requestType,
                                selectedPathsNotifier: _selectedPathsNotifier,
                                style: _style,
                                onTap: () => _toggleSelection(path),
                              );
                            },
                          )),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: SizedBox(
                width: double.infinity,
                child: ValueListenableBuilder<List<String>>(
                  valueListenable: _selectedPathsNotifier,
                  builder: (context, selectedPaths, child) {
                    return ElevatedButton(
                      onPressed: _confirmSelection,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: buttonColor,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            _style.buttonBorderRadius,
                          ),
                        ),
                      ),
                      child: Text(
                        selectedPaths.isEmpty
                            ? _labels.confirmButtonText
                            : '${_labels.confirmButtonText} (${selectedPaths.length})',
                        style:
                            _style.buttonTextStyle ??
                            TextStyle(
                              color: widget.confirmTextColor,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GridItem extends StatelessWidget {
  final String path;
  final MyRequestType requestType;
  final ValueNotifier<List<String>> selectedPathsNotifier;
  final PickerStyle style;
  final VoidCallback onTap;

  const _GridItem({
    required this.path,
    required this.requestType,
    required this.selectedPathsNotifier,
    required this.style,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(style.gridItemBorderRadius),
              child: CachedMediaPreview(path: path, requestType: requestType),
            ),
          ),
          if (requestType == MyRequestType.video)
            const Positioned(
              bottom: 5,
              right: 5,
              child: Icon(
                Icons.play_circle_outline,
                color: Colors.white,
                size: 20,
              ),
            ),
          ValueListenableBuilder<List<String>>(
            valueListenable: selectedPathsNotifier,
            builder: (context, selectedPaths, child) {
              final isSelected = selectedPaths.contains(path);
              if (!isSelected) return const SizedBox.shrink();

              return Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: style.selectionOverlayColor,
                      borderRadius: BorderRadius.circular(
                        style.gridItemBorderRadius,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 5,
                    right: 5,
                    child: Container(
                      decoration: BoxDecoration(
                        color: style.selectionBadgeColor,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      padding: const EdgeInsets.all(6),
                      child: Text(
                        '${selectedPaths.indexOf(path) + 1}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
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
