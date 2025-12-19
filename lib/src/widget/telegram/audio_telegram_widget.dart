import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_better_pickers/flutter_better_pickers.dart';
import 'package:flutter_better_pickers/src/tools/media_manager_wrapper.dart';

class AudioTelegramWidget extends StatefulWidget {
  final ScrollController scrollController;
  final int maxCountPickFiles;
  final OverlayEntry overlayEntry;
  final VoidCallback toggleSheet;
  final Function(List<String>?, List<String>?) onFilesSelected;
  final PickerLabels? labels;
  final PickerStyle? style;

  const AudioTelegramWidget({
    super.key,
    required this.scrollController,
    required this.maxCountPickFiles,
    required this.overlayEntry,
    required this.toggleSheet,
    required this.onFilesSelected,
    this.labels,
    this.style,
  });

  @override
  State<AudioTelegramWidget> createState() => _AudioTelegramWidgetState();
}

class _AudioTelegramWidgetState extends State<AudioTelegramWidget> {
  List<String> audioFiles = [];
  List<String> selectedAudioFiles = [];
  bool isLoading = true;

  final Map<String, Future<Uint8List?>> _previewFutures = {};

  PickerLabels get _labels => widget.labels ?? const PickerLabels();
  PickerStyle get _style => widget.style ?? const PickerStyle();

  @override
  void initState() {
    super.initState();
    _loadAudioFiles();
  }

  Future<void> _loadAudioFiles() async {
    try {
      final files = await MediaManagerWrapper.getAllAudio();
      setState(() {
        audioFiles = files;
        isLoading = false;
      });
    } catch (e) {
      debugPrint('Error loading audio files: $e');
      setState(() {
        audioFiles = [];
        isLoading = false;
      });
    }
  }

  void _toggleSelection(String audioPath) {
    setState(() {
      if (selectedAudioFiles.contains(audioPath)) {
        selectedAudioFiles.remove(audioPath);
      } else if (selectedAudioFiles.length < widget.maxCountPickFiles) {
        selectedAudioFiles.add(audioPath);
      }
    });
  }

  void _sendSelectedFiles() {
    widget.onFilesSelected(null, selectedAudioFiles);
    widget.toggleSheet();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            color: theme.primaryColor,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(20.0),
            ),
          ),
          child: audioFiles.isEmpty
              ? Center(
                  child: isLoading
                      ? _style.loadingWidget ??
                            const CircularProgressIndicator()
                      : Text(
                          _labels.noAudioFound,
                          style:
                              _style.emptyListTextStyle ??
                              TextStyle(
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
                        child: ListView.builder(
                          controller: widget.scrollController,
                          physics: const BouncingScrollPhysics(),
                          itemCount: audioFiles.length,
                          itemBuilder: (context, index) {
                            final audioPath = audioFiles[index];
                            final fileName = audioPath.split('/').last;
                            final isSelected = selectedAudioFiles.contains(
                              audioPath,
                            );

                            return Container(
                              margin: const EdgeInsets.symmetric(
                                vertical: 4,
                                horizontal: 8,
                              ),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? Colors.blue.withValues(alpha: 0.3)
                                    : Colors.grey[800],
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: isSelected
                                      ? Colors.blue
                                      : Colors.transparent,
                                  width: 2,
                                ),
                              ),
                              child: ListTile(
                                leading: Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    color: Colors.blue,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: FutureBuilder<Uint8List?>(
                                    future: _previewFutures.putIfAbsent(
                                      audioPath,
                                      () => MediaManagerWrapper.getImagePreview(
                                        audioPath,
                                      ),
                                    ),
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData &&
                                          snapshot.data != null) {
                                        return ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                          child: Image.memory(
                                            snapshot.data!,
                                            fit: BoxFit.cover,
                                          ),
                                        );
                                      }
                                      return const Icon(
                                        Icons.music_note,
                                        color: Colors.white,
                                      );
                                    },
                                  ),
                                ),
                                title: Text(
                                  fileName,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                trailing: GestureDetector(
                                  onTap: () => _toggleSelection(audioPath),
                                  child: Container(
                                    width: 30,
                                    height: 30,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: isSelected
                                          ? Colors.blue
                                          : Colors.grey[700],
                                      border: Border.all(
                                        color: Colors.white,
                                        width: 1,
                                      ),
                                    ),
                                    child: isSelected
                                        ? const Icon(
                                            Icons.check,
                                            color: Colors.white,
                                            size: 16,
                                          )
                                        : null,
                                  ),
                                ),
                                onTap: () => _toggleSelection(audioPath),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
        ),
        if (selectedAudioFiles.isNotEmpty)
          Positioned(
            bottom: MediaQuery.of(context).padding.bottom + 30,
            right: 30,
            child: Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: [
                InkResponse(
                  onTap: _sendSelectedFiles,
                  child: CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.blue,
                    child: const Icon(Icons.send, color: Colors.white),
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
                      color: Colors.blue,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2.0),
                    ),
                    child: Text(
                      '${selectedAudioFiles.length}',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
