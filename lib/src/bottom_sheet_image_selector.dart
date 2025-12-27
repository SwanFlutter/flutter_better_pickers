import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_better_pickers/flutter_better_pickers.dart';
import 'package:flutter_better_pickers/src/tools/media_manager_wrapper.dart';
import 'package:flutter_saver/flutter_saver.dart';
import 'package:image_picker/image_picker.dart';

/// A bottom sheet widget for selecting images with preview functionality.
///
/// This widget displays a large preview of the selected image at the top,
/// with a grid of thumbnails below for selection. Ideal for Instagram-style
/// image selection interfaces.
///
/// Example:
/// ```dart
/// BottomSheetImageSelector(
///   maxCount: 10,
///   requestType: MyRequestType.image,
///   labels: PickerLabels.spanish,
///   style: PickerStyle.instagram,
/// )
/// ```
class BottomSheetImageSelector extends StatefulWidget {
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

  /// @deprecated Use [style.dropdownColor] instead
  /// Background color for the dropdown
  final Color? dropdownColor;

  /// @deprecated Use [style.dropdownTextStyle] instead
  /// Text style for dropdown items
  final TextStyle textStyleDropdown;

  /// @deprecated Use [style.cameraIcon] instead
  /// Custom icon widget for camera button
  final Widget iconCamera;

  /// @deprecated Use [style.loadingWidget] instead
  /// Custom loading widget
  final Widget? loading;

  /// Camera image settings for quality and dimensions
  final CameraImageSettings? cameraImageSettings;

  /// Labels for internationalization.
  /// Use predefined labels like [PickerLabels.italian], [PickerLabels.russian],
  /// [PickerLabels.turkish], [PickerLabels.japanese], [PickerLabels.korean],
  /// [PickerLabels.hindi], or create custom labels.
  final PickerLabels? labels;

  /// Style configuration for colors, sizes, and widgets.
  /// Use predefined styles like [PickerStyle.telegram], [PickerStyle.whatsapp],
  /// or create custom styles.
  final PickerStyle? style;

  const BottomSheetImageSelector({
    super.key,
    required this.maxCount,
    required this.requestType,
    this.confirmText = "Send",
    this.textEmptyList = "No albums found.",
    this.confirmTextColor = Colors.black,
    this.backgroundColor,
    this.confirmButtonColor,
    this.textEmptyListColor,
    this.backgroundSnackBarColor,
    this.dropdownColor,
    this.cameraImageSettings,
    this.iconCamera = const Icon(Icons.camera, color: Colors.black),
    this.textStyleDropdown = const TextStyle(fontSize: 18, color: Colors.black),
    this.loading,
    this.labels,
    this.style,
  });

  @override
  State<BottomSheetImageSelector> createState() =>
      _BottomSheetImageSelectorState();
}

class _BottomSheetImageSelectorState extends State<BottomSheetImageSelector>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  List<String> _allImagePaths = [];
  List<String> _filteredImagePaths = [];
  final ValueNotifier<List<String>> _selectedPathsNotifier =
      ValueNotifier<List<String>>([]);
  final ValueNotifier<String?> _previewPathNotifier = ValueNotifier<String?>(
    null,
  );
  Map<String, List<String>> _folderMap = {};
  List<String> _folderNames = [];
  String? _selectedFolder;
  bool isLoading = true;

  PickerLabels get _labels => widget.labels ?? const PickerLabels();
  PickerStyle get _style => widget.style ?? const PickerStyle();

  @override
  void initState() {
    super.initState();
    _startLoading();
    _loadImages();
  }

  @override
  void dispose() {
    _selectedPathsNotifier.dispose();
    _previewPathNotifier.dispose();
    super.dispose();
  }

  Future<void> _loadImages() async {
    try {
      final images = await MediaManagerWrapper.getAllImages();

      // Group by folder
      final Map<String, List<String>> grouped = {};
      for (var path in images) {
        final dir = File(path).parent.path;
        final folderName = dir.split('/').last;
        grouped.putIfAbsent(folderName, () => []).add(path);
      }

      setState(() {
        _allImagePaths = images;
        _folderMap = grouped;
        _folderNames = [_labels.allPhotos, ...grouped.keys];
        _selectedFolder = _labels.allPhotos;
        _filteredImagePaths = images;
        if (images.isNotEmpty) {
          _previewPathNotifier.value = images[0];
        }
      });
    } catch (e) {
      debugPrint('Error loading images: $e');
      setState(() {
        _allImagePaths = [];
        _filteredImagePaths = [];
      });
    }
  }

  void _onFolderChanged(String? folder) {
    if (folder == null) return;
    setState(() {
      _selectedFolder = folder;
      if (folder == _labels.allPhotos) {
        _filteredImagePaths = _allImagePaths;
      } else {
        _filteredImagePaths = _folderMap[folder] ?? [];
      }
      if (_filteredImagePaths.isNotEmpty) {
        _previewPathNotifier.value = _filteredImagePaths[0];
      }
    });
  }

  void _startLoading() {
    setState(() {
      isLoading = true;
    });
    Future.delayed(const Duration(seconds: 10), () {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final size = MediaQuery.of(context).size;
    return SafeArea(
      top: false,
      child: SizedBox(
        height: size.height * 0.95,
        child: Scaffold(
          backgroundColor: widget.backgroundColor ?? _style.backgroundColor,
          appBar: AppBar(
            backgroundColor: _style.appBarColor,
            elevation: 0,
            actions: [
              ValueListenableBuilder<List<String>>(
                valueListenable: _selectedPathsNotifier,
                builder: (context, selectedPaths, child) {
                  return TextButton(
                    onPressed: () {
                      if (selectedPaths.isNotEmpty) {
                        Navigator.pop(context, selectedPaths);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor:
                                widget.backgroundSnackBarColor ??
                                _style.snackBarColor,
                            margin: const EdgeInsets.all(15.0),
                            behavior: SnackBarBehavior.floating,
                            shape: BeveledRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            content: Text(_labels.noMediaSelected),
                          ),
                        );
                      }
                    },
                    child: Text(
                      _labels.confirmButtonText,
                      style:
                          _style.buttonTextStyle ??
                          TextStyle(
                            color: _style.confirmTextColor,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  );
                },
              ),
            ],
          ),
          body: SafeArea(
            child: SizedBox(
              height: size.height * 0.40,
              child: ValueListenableBuilder<String?>(
                valueListenable: _previewPathNotifier,
                builder: (context, previewPath, child) {
                  if (previewPath == null) return const SizedBox.shrink();
                  return Image.file(
                    File(previewPath),
                    fit: BoxFit.cover,
                    height: size.height,
                    width: size.width,
                    errorBuilder: (context, error, stackTrace) {
                      return const Center(
                        child: Icon(Icons.broken_image, size: 50),
                      );
                    },
                  );
                },
              ),
            ),
          ),
          bottomSheet: SafeArea(
            top: false,
            child: SingleChildScrollView(
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.6,
                child: Column(
                  children: [
                    SizedBox(
                      height: 50.0,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        child: Row(
                          children: [
                            // Folder dropdown
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                ),
                                decoration: BoxDecoration(
                                  color:
                                      widget.dropdownColor ??
                                      _style.dropdownColor,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: Colors.grey.shade300,
                                  ),
                                ),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    value: _selectedFolder,
                                    isExpanded: true,
                                    icon: Icon(
                                      Icons.keyboard_arrow_down,
                                      color: _style.textColor,
                                    ),
                                    dropdownColor:
                                        widget.dropdownColor ??
                                        _style.dropdownColor,
                                    style: widget.textStyleDropdown,
                                    hint: Text(_labels.gallery),
                                    items: _folderNames.map((folder) {
                                      final count = folder == _labels.allPhotos
                                          ? _allImagePaths.length
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
                                                color:
                                                    _style.secondaryTextColor,
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
                              onPressed: () =>
                                  _pickImageCamera(ImageSource.camera),
                              icon: widget.iconCamera,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Divider(),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5.0),
                        child: _filteredImagePaths.isEmpty
                            ? Center(
                                child: isLoading
                                    ? widget.loading ??
                                          _style.loadingWidget ??
                                          const CircularProgressIndicator.adaptive()
                                    : Text(
                                        widget.textEmptyList,
                                        style:
                                            _style.emptyListTextStyle ??
                                            TextStyle(
                                              color:
                                                  widget.textEmptyListColor ??
                                                  _style.emptyListTextColor,
                                              fontSize: 16,
                                            ),
                                      ),
                              )
                            : GridView.builder(
                                physics: const BouncingScrollPhysics(),
                                itemCount: _filteredImagePaths.length,
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount:
                                          _style.gridCrossAxisCount + 1,
                                      crossAxisSpacing: _style.gridSpacing,
                                      mainAxisSpacing: _style.gridSpacing,
                                      mainAxisExtent: 100,
                                      childAspectRatio: 5.0,
                                    ),
                                itemBuilder: (context, index) {
                                  final path = _filteredImagePaths[index];
                                  return _GridItem(
                                    path: path,
                                    selectedPathsNotifier:
                                        _selectedPathsNotifier,
                                    previewPathNotifier: _previewPathNotifier,
                                    style: _style,
                                    maxCount: widget.maxCount,
                                  );
                                },
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _pickImageCamera(ImageSource source) async {
    final myFile = await ImagePicker().pickImage(
      source: source,
      imageQuality: widget.cameraImageSettings?.imageQuality,
      maxWidth: widget.cameraImageSettings?.maxWidth,
      maxHeight: widget.cameraImageSettings?.maxHeight,
    );

    bool isSaved = false;
    if (myFile != null) {
      File image = File(myFile.path);
      if (Platform.isAndroid) {
        isSaved = await FlutterSaver.saveImageAndroid(fileImage: image);
      } else {
        isSaved = await FlutterSaver.saveImageIos(fileImage: image);
      }

      if (isSaved) {
        _loadImages();
      }
    }
  }
}

class _GridItem extends StatelessWidget {
  final String path;
  final ValueNotifier<List<String>> selectedPathsNotifier;
  final ValueNotifier<String?> previewPathNotifier;
  final PickerStyle style;
  final int maxCount;

  const _GridItem({
    required this.path,
    required this.selectedPathsNotifier,
    required this.previewPathNotifier,
    required this.style,
    required this.maxCount,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        previewPathNotifier.value = path;
      },
      child: Stack(
        children: [
          Positioned.fill(
            child: Image.file(
              File(path),
              fit: BoxFit.cover,
              cacheWidth: 200,
              filterQuality: FilterQuality.low,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Colors.grey[300],
                  child: const Icon(Icons.broken_image, color: Colors.grey),
                );
              },
            ),
          ),
          ValueListenableBuilder2<List<String>, String?>(
            first: selectedPathsNotifier,
            second: previewPathNotifier,
            builder: (context, selectedPaths, previewPath, child) {
              final isSelected = selectedPaths.contains(path);
              final isShowingPreview = path == previewPath;

              return Stack(
                children: [
                  Positioned.fill(
                    child: Container(
                      color: isShowingPreview
                          ? Colors.white60
                          : Colors.transparent,
                    ),
                  ),
                  Positioned.fill(
                    child: GestureDetector(
                      onTap: () {
                        final currentList = List<String>.from(
                          selectedPathsNotifier.value,
                        );
                        if (isSelected) {
                          currentList.remove(path);
                        } else if (currentList.length < maxCount) {
                          currentList.add(path);
                        }
                        selectedPathsNotifier.value = currentList;
                        previewPathNotifier.value = path;
                      },
                      child: Align(
                        alignment: Alignment.topRight,
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? style.selectionBadgeColor
                                  : Colors.white12,
                              shape: BoxShape.circle,
                              border: Border.all(
                                width: 1.5,
                                color: Colors.white,
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Text(
                                "${selectedPaths.indexOf(path) + 1}",
                                style: TextStyle(
                                  color: isSelected
                                      ? Colors.white
                                      : Colors.transparent,
                                ),
                              ),
                            ),
                          ),
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

class ValueListenableBuilder2<A, B> extends StatelessWidget {
  final ValueListenable<A> first;
  final ValueListenable<B> second;
  final Widget Function(BuildContext context, A a, B b, Widget? child) builder;
  final Widget? child;

  const ValueListenableBuilder2({
    super.key,
    required this.first,
    required this.second,
    required this.builder,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<A>(
      valueListenable: first,
      builder: (context, a, child) {
        return ValueListenableBuilder<B>(
          valueListenable: second,
          builder: (context, b, child) {
            return builder(context, a, b, child);
          },
        );
      },
    );
  }
}
