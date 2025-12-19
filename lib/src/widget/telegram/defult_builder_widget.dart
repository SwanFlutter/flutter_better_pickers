// ignore_for_file: must_be_immutable

import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_better_pickers/flutter_better_pickers.dart';
import 'package:flutter_saver/flutter_saver.dart';
import 'package:image_picker/image_picker.dart';

class DefultBuilderWidget extends StatefulWidget {
  TelegramMediaPickers widget;
  ValueListenable<double> valueListenable;
  bool isLoading;

  ScrollController controller;
  List<String> assetsList;
  String? selectedAlbum;
  String? selectedEntity;
  List<String> albumList;

  List<int> albumFileCounts;
  List<File?> albumFirstImages;

  OnMediaPicked onMediaPicked;
  final OverlayEntry overlayEntry;

  final VoidCallback toggleSheet;
  final VoidCallback loadAlbums;
  final void Function(String) onAlbumChanged;
  final bool isRealCameraView;

  DefultBuilderWidget({
    super.key,
    required this.widget,
    required this.valueListenable,
    required this.isLoading,
    required this.assetsList,
    required this.controller,
    required this.albumList,
    required this.albumFileCounts,
    required this.albumFirstImages,
    required this.selectedAlbum,
    required this.selectedEntity,
    required this.onMediaPicked,
    required this.toggleSheet,
    required this.overlayEntry,
    required this.loadAlbums,
    required this.onAlbumChanged,
    required this.isRealCameraView,
  });

  @override
  State<DefultBuilderWidget> createState() => _DefultBuilderWidgetState();
}

class _DefultBuilderWidgetState extends State<DefultBuilderWidget>
    with AutomaticKeepAliveClientMixin {
  List<String> selectedAssetList = [];
  final ValueNotifier<List<String>> selectedAssetListNotifier =
      ValueNotifier<List<String>>([]);

  PickerLabels get _labels => widget.widget.labels ?? const PickerLabels();
  PickerStyle get _style => widget.widget.style ?? const PickerStyle();

  void _sendSelectedFiles() {
    widget.onMediaPicked(selectedAssetList, null);
    setState(() {});
  }

  void _toggleSelection(String assetPath) {
    setState(() {
      if (selectedAssetList.contains(assetPath)) {
        selectedAssetList.remove(assetPath);
      } else if (selectedAssetList.length < widget.widget.maxCountPickMedia) {
        selectedAssetList.add(assetPath);
      }
      selectedAssetListNotifier.value = List.from(selectedAssetList);
    });
  }

  Future<void> _pickFromCamera() async {
    try {
      final pickedFile = await ImagePicker().pickImage(
        source: ImageSource.camera,
        imageQuality: widget.widget.cameraImageSettings?.imageQuality,
        maxWidth: widget.widget.cameraImageSettings?.maxWidth,
        maxHeight: widget.widget.cameraImageSettings?.maxHeight,
      );

      if (pickedFile != null) {
        final imageFile = File(pickedFile.path);
        final isSaved = await FlutterSaver.saveImageAndroid(
          fileImage: imageFile,
        );
        if (isSaved) {
          widget.loadAlbums();
        }
      }
    } catch (e) {
      debugPrint('Error picking image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Stack(
      children: [
        ValueListenableBuilder<double>(
          valueListenable: widget.valueListenable,
          builder: (context, size, child) {
            final isFullyExpanded = size > 0.9;
            return Container(
              decoration: BoxDecoration(
                color: theme.primaryColor,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(20.0),
                ),
              ),
              child: widget.assetsList.isEmpty
                  ? Center(
                      child: widget.isLoading
                          ? _style.loadingWidget ??
                                const CircularProgressIndicator.adaptive()
                          : Text(
                              _labels.noMediaFound,
                              style:
                                  _style.emptyListTextStyle ??
                                  TextStyle(
                                    color: _style.emptyListTextColor,
                                    fontSize: 18,
                                  ),
                            ),
                    )
                  : Column(
                      children: [
                        // Header - only show when NOT fully expanded
                        // (app bar handles album selection when expanded)
                        if (!isFullyExpanded)
                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 12,
                                    ),
                                    child: Text(
                                      widget.selectedAlbum != null
                                          ? widget.selectedAlbum!
                                                .split('/')
                                                .last
                                          : 'Gallery',
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                IconButton(
                                  onPressed: _pickFromCamera,
                                  icon: const Icon(
                                    Icons.camera_alt,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          )
                        else
                          // Spacer for app bar when fully expanded
                          const SizedBox(height: 65),
                        Expanded(
                          child: GridView.builder(
                            controller: widget.controller,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  crossAxisSpacing: 4,
                                  mainAxisSpacing: 4,
                                ),
                            itemCount:
                                widget.assetsList.length + 1, // +1 for camera
                            itemBuilder: (context, index) {
                              // First item is camera
                              if (index == 0) {
                                return GestureDetector(
                                  onTap: _pickFromCamera,
                                  child: Container(
                                    color: _style.primaryColor.withOpacity(0.3),
                                    child: Center(
                                      child: Icon(
                                        Icons.camera_alt_outlined,
                                        size: 40,
                                        color: theme.colorScheme.onPrimary,
                                      ),
                                    ),
                                  ),
                                );
                              }

                              // Media items (index - 1 because of camera at index 0)
                              final assetPath = widget.assetsList[index - 1];
                              final isSelected = selectedAssetList.contains(
                                assetPath,
                              );

                              return GestureDetector(
                                onTap: () => _toggleSelection(assetPath),
                                child: Stack(
                                  children: [
                                    Positioned.fill(
                                      child: _buildMediaPreview(assetPath),
                                    ),
                                    Container(
                                      color: isSelected
                                          ? Colors.white60
                                          : Colors.transparent,
                                    ),
                                    if (isSelected)
                                      Positioned(
                                        top: 5,
                                        right: 5,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.blue,
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                              color: Colors.white,
                                              width: 2,
                                            ),
                                          ),
                                          padding: const EdgeInsets.all(6),
                                          child: Text(
                                            '${selectedAssetList.indexOf(assetPath) + 1}',
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
            );
          },
        ),
        // دکمه ارسال شناور مثل تلگرام
        ValueListenableBuilder<List<String>>(
          valueListenable: selectedAssetListNotifier,
          builder: (context, selected, child) {
            return selected.isNotEmpty
                ? Positioned(
                    bottom: MediaQuery.of(context).padding.bottom + 100,
                    right: 20,
                    child: Stack(
                      clipBehavior: Clip.none,
                      alignment: Alignment.center,
                      children: [
                        InkResponse(
                          onTap: () {
                            _sendSelectedFiles();
                            widget.toggleSheet();
                          },
                          child: Container(
                            width: 56,
                            height: 56,
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primary,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.3),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Icon(
                              Icons.send,
                              color: theme.colorScheme.onPrimary,
                              size: 24,
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: -5,
                          right: -5,
                          child: Container(
                            alignment: Alignment.center,
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primary,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.black,
                                width: 2.0,
                              ),
                            ),
                            child: Text(
                              '${selected.length}',
                              style: TextStyle(
                                color: theme.colorScheme.onPrimary,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : const SizedBox.shrink();
          },
        ),
      ],
    );
  }

  Widget _buildMediaPreview(String assetPath) {
    return Image.file(
      File(assetPath),
      fit: BoxFit.cover,
      cacheWidth: 200,
      filterQuality: FilterQuality.low,
      errorBuilder: (context, error, stackTrace) {
        debugPrint('Image load error for $assetPath: $error');
        return Container(
          color: Colors.grey[300],
          child: const Icon(Icons.broken_image, color: Colors.grey),
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
