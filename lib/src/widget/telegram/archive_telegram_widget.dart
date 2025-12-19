import 'package:flutter/material.dart';
import 'package:flutter_better_pickers/src/tools/media_manager_wrapper.dart';

class ArchiveTelegramWidget extends StatefulWidget {
  final ScrollController scrollController;
  final int maxCountPickFiles;
  final OverlayEntry overlayEntry;
  final String textEmptyListArchive;
  final TextStyle textStyleEmptyListText;
  final VoidCallback toggleSheet;
  final Function(List<String>?, List<String>?) onFilesSelected;

  const ArchiveTelegramWidget({
    super.key,
    required this.scrollController,
    required this.maxCountPickFiles,
    required this.overlayEntry,
    required this.textEmptyListArchive,
    required this.textStyleEmptyListText,
    required this.toggleSheet,
    required this.onFilesSelected,
  });

  @override
  State<ArchiveTelegramWidget> createState() => _ArchiveTelegramWidgetState();
}

class _ArchiveTelegramWidgetState extends State<ArchiveTelegramWidget> {
  List<String> archiveFiles = [];
  List<String> selectedArchiveFiles = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadArchiveFiles();
  }

  Future<void> _loadArchiveFiles() async {
    try {
      final files = await MediaManagerWrapper.getAllZipFiles();
      setState(() {
        archiveFiles = files;
        isLoading = false;
      });
    } catch (e) {
      debugPrint('Error loading archive files: $e');
      setState(() {
        archiveFiles = [];
        isLoading = false;
      });
    }
  }

  void _toggleSelection(String archivePath) {
    setState(() {
      if (selectedArchiveFiles.contains(archivePath)) {
        selectedArchiveFiles.remove(archivePath);
      } else if (selectedArchiveFiles.length < widget.maxCountPickFiles) {
        selectedArchiveFiles.add(archivePath);
      }
    });
  }

  void _sendSelectedFiles() {
    widget.onFilesSelected(null, selectedArchiveFiles);
    widget.toggleSheet();
  }

  String _getArchiveIcon(String fileName) {
    final ext = fileName.split('.').last.toLowerCase();
    switch (ext) {
      case 'zip':
        return '🗜️';
      case 'rar':
        return '📦';
      case '7z':
        return '📦';
      case 'tar':
        return '📦';
      case 'gz':
        return '📦';
      case 'bz2':
        return '📦';
      default:
        return '📦';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.grey[900],
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(20.0),
            ),
          ),
          child: archiveFiles.isEmpty
              ? Center(
                  child: isLoading
                      ? const CircularProgressIndicator()
                      : Text(
                          widget.textEmptyListArchive,
                          style: widget.textStyleEmptyListText,
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
                          itemCount: archiveFiles.length,
                          itemBuilder: (context, index) {
                            final archivePath = archiveFiles[index];
                            final fileName = archivePath.split('/').last;
                            final isSelected =
                                selectedArchiveFiles.contains(archivePath);

                            return Container(
                              margin: const EdgeInsets.symmetric(
                                vertical: 4,
                                horizontal: 8,
                              ),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? Colors.purple.withValues(alpha: 0.3)
                                    : Colors.grey[800],
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: isSelected
                                      ? Colors.purple
                                      : Colors.transparent,
                                  width: 2,
                                ),
                              ),
                              child: ListTile(
                                leading: Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    color: Colors.purple,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Center(
                                    child: Text(
                                      _getArchiveIcon(fileName),
                                      style: const TextStyle(fontSize: 24),
                                    ),
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
                                subtitle: Text(
                                  archivePath,
                                  style: TextStyle(
                                    color: Colors.grey[400],
                                    fontSize: 12,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                trailing: GestureDetector(
                                  onTap: () => _toggleSelection(archivePath),
                                  child: Container(
                                    width: 30,
                                    height: 30,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: isSelected
                                          ? Colors.purple
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
                                onTap: () => _toggleSelection(archivePath),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
        ),
        if (selectedArchiveFiles.isNotEmpty)
          Positioned(
            bottom: 30,
            right: 30,
            child: Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: [
                InkResponse(
                  onTap: _sendSelectedFiles,
                  child: CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.purple,
                    child: const Icon(
                      Icons.send,
                      color: Colors.white,
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
                      color: Colors.purple,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2.0),
                    ),
                    child: Text(
                      '${selectedArchiveFiles.length}',
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
