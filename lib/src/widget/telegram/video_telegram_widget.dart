import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_better_pickers/flutter_better_pickers.dart';
import 'package:flutter_better_pickers/src/telegram_media_picker.dart';
import 'package:flutter_better_pickers/src/tools/media_manager_wrapper.dart';

class VideoOnlyPage extends StatefulWidget {
  final TelegramMediaPickers widget;
  final int maxCountPickFiles;
  final OnMediaPicked onFilesSelected;
  final ScrollController controller;
  final List<String> assetsList;
  final String? selectedAlbum;
  final String? selectedEntity;
  final OverlayEntry overlayEntry;
  final VoidCallback toggleSheet;

  const VideoOnlyPage({
    super.key,
    required this.maxCountPickFiles,
    required this.onFilesSelected,
    required this.controller,
    required this.assetsList,
    required this.selectedAlbum,
    required this.selectedEntity,
    required this.overlayEntry,
    required this.toggleSheet,
    required this.widget,
  });

  @override
  State<VideoOnlyPage> createState() => _VideoOnlyPageState();
}

class _VideoOnlyPageState extends State<VideoOnlyPage> {
  final ValueNotifier<List<String>> selectedAssetListNotifier =
      ValueNotifier<List<String>>([]);
  List<String> selectedAssetList = [];
  List<String> _videoPaths = [];
  bool _isLoading = true;

  final Map<String, Future<Uint8List?>> _thumbnailFutures = {};
  
  PickerLabels get _labels => widget.widget.labels ?? const PickerLabels();
  PickerStyle get _style => widget.widget.style ?? const PickerStyle();

  @override
  void initState() {
    super.initState();
    _loadVideos();
  }

  Future<void> _loadVideos() async {
    setState(() => _isLoading = true);
    try {
      final videos = await MediaManagerWrapper.getAllVideos();
      if (mounted) {
        setState(() {
          _videoPaths = videos;
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Error loading videos: $e');
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _sendSelectedFiles() {
    widget.onFilesSelected(null, selectedAssetList);
    setState(() {});
  }

  void _toggleSelection(String videoPath) {
    setState(() {
      if (selectedAssetList.contains(videoPath)) {
        selectedAssetList.remove(videoPath);
      } else if (selectedAssetList.length < widget.maxCountPickFiles) {
        selectedAssetList.add(videoPath);
      }
    });
    selectedAssetListNotifier.value = List.from(selectedAssetList);
  }

  @override
  Widget build(BuildContext context) {
    final videoAssets = _videoPaths;

    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            color: theme.primaryColor,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(20.0),
            ),
          ),
          child: _isLoading
              ? const Center(child: CircularProgressIndicator.adaptive())
              : videoAssets.isEmpty
                  ? Center(
                      child: Text(
                        _labels.noVideosFound,
                        style: _style.emptyListTextStyle ?? TextStyle(
                          color: _style.emptyListTextColor,
                          fontSize: 18,
                        ),
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.only(top: 15, right: 10, left: 10),
                      child: Column(
                        children: [
                          Container(
                            height: 7,
                            width: 60,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Flexible(
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: GridView.builder(
                                  shrinkWrap: true,
                                  controller: widget.controller,
                                  physics: const BouncingScrollPhysics(),
                                  itemCount: videoAssets.length,
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3,
                                    crossAxisSpacing: 3,
                                    mainAxisSpacing: 3,
                                    mainAxisExtent: 115,
                                  ),
                                  itemBuilder: (context, index) {
                                    final videoPath = videoAssets[index];
                                    return _buildVideoTile(videoPath);
                                  },
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
        ),
        ValueListenableBuilder<List<String>>(
          valueListenable: selectedAssetListNotifier,
          builder: (context, selectedAssetList, child) {
            return selectedAssetList.isNotEmpty
                ? Positioned(
                    bottom: MediaQuery.of(context).padding.bottom +
                        MediaQuery.of(context).size.height * 0.10,
                    right: 30,
                    child: Stack(
                      clipBehavior: Clip.none,
                      alignment: Alignment.center,
                      children: [
                        InkResponse(
                          onTap: () {
                            debugPrint(
                                'Selected files: ${selectedAssetList.length}');
                            _sendSelectedFiles();
                            widget.toggleSheet();
                          },
                          child: CircleAvatar(
                            radius: 40,
                            backgroundColor: theme.colorScheme.primary,
                            child: Icon(
                              Icons.send,
                              color: theme.colorScheme.onPrimary,
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: -5,
                          right: -5,
                          child: Container(
                            alignment: Alignment.center,
                            width: 35.0,
                            height: 35.0,
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primary,
                              shape: BoxShape.circle,
                              border:
                                  Border.all(color: Colors.black, width: 2.0),
                            ),
                            child: Text(
                              '${selectedAssetList.length}',
                              style:
                                  TextStyle(color: theme.colorScheme.onPrimary),
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

  Widget _buildVideoTile(String videoPath) {
    return ValueListenableBuilder<List<String>>(
      valueListenable: selectedAssetListNotifier,
      builder: (context, selectedAssetList, child) {
        bool isSelected = selectedAssetList.contains(videoPath);
        return GestureDetector(
          onTap: () {
            _toggleSelection(videoPath);
          },
          child: Stack(
            children: [
              Positioned.fill(
                child: FutureBuilder<Uint8List?>(
                  future: _thumbnailFutures.putIfAbsent(
                    videoPath,
                    () => MediaManagerWrapper.getVideoThumbnail(videoPath),
                  ),
                  builder: (context, snapshot) {
                    if (snapshot.hasData && snapshot.data != null) {
                      return Image.memory(
                        snapshot.data!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const Center(
                            child: Icon(Icons.error, color: Colors.red),
                          );
                        },
                      );
                    }
                    return Container(color: Colors.grey[300]);
                  },
                ),
              ),
              Positioned(
                bottom: 4,
                right: 4,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Icon(
                    Icons.play_arrow,
                    color: Colors.white,
                    size: 12,
                  ),
                ),
              ),
              if (isSelected)
                Positioned.fill(
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      border: Border.all(
                        width: 8,
                        color: Colors.white70,
                      ),
                    ),
                    child:
                        const Icon(Icons.check, color: Colors.white, size: 30),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
