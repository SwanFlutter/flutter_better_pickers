import 'package:flutter/material.dart';
import 'package:flutter_better_pickers/flutter_better_pickers.dart';
import 'package:flutter_better_pickers/src/tools/media_manager_wrapper.dart';

class FileListScreen extends StatefulWidget {
  final ScrollController scrollController;
  final int maxCountPickFiles;
  final OverlayEntry overlayEntry;
  final VoidCallback toggleSheet;
  final Function(List<String>?, List<String>?) onFilesSelected;
  final PickerLabels? labels;
  final PickerStyle? style;

  const FileListScreen({
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
  State<FileListScreen> createState() => _FileListScreenState();
}

class _FileListScreenState extends State<FileListScreen> {
  List<String> documentFiles = [];
  List<String> selectedDocumentFiles = [];
  bool isLoading = true;

  PickerLabels get _labels => widget.labels ?? const PickerLabels();
  PickerStyle get _style => widget.style ?? const PickerStyle();

  @override
  void initState() {
    super.initState();
    _loadDocumentFiles();
  }

  Future<void> _loadDocumentFiles() async {
    try {
      final files = await MediaManagerWrapper.getAllDocuments();
      setState(() {
        documentFiles = files;
        isLoading = false;
      });
    } catch (e) {
      debugPrint('Error loading document files: $e');
      setState(() {
        documentFiles = [];
        isLoading = false;
      });
    }
  }

  void _toggleSelection(String filePath) {
    setState(() {
      if (selectedDocumentFiles.contains(filePath)) {
        selectedDocumentFiles.remove(filePath);
      } else if (selectedDocumentFiles.length < widget.maxCountPickFiles) {
        selectedDocumentFiles.add(filePath);
      }
    });
  }

  void _sendSelectedFiles() {
    widget.onFilesSelected(null, selectedDocumentFiles);
    widget.toggleSheet();
  }

  String _getFileIcon(String fileName) {
    final ext = fileName.split('.').last.toLowerCase();
    switch (ext) {
      case 'pdf':
        return '📄';
      case 'doc':
      case 'docx':
        return '📝';
      case 'xls':
      case 'xlsx':
        return '📊';
      case 'ppt':
      case 'pptx':
        return '📈';
      case 'zip':
      case 'rar':
      case '7z':
        return '📦';
      case 'txt':
        return '📃';
      default:
        return '📄';
    }
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
          child: documentFiles.isEmpty
              ? Center(
                  child: isLoading
                      ? _style.loadingWidget ??
                            const CircularProgressIndicator()
                      : Text(
                          _labels.noFilesFound,
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
                          itemCount: documentFiles.length,
                          itemBuilder: (context, index) {
                            final filePath = documentFiles[index];
                            final fileName = filePath.split('/').last;
                            final isSelected = selectedDocumentFiles.contains(
                              filePath,
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
                                    color: Colors.orange,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Center(
                                    child: Text(
                                      _getFileIcon(fileName),
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
                                  filePath,
                                  style: TextStyle(
                                    color: Colors.grey[400],
                                    fontSize: 12,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                trailing: GestureDetector(
                                  onTap: () => _toggleSelection(filePath),
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
                                onTap: () => _toggleSelection(filePath),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
        ),
        if (selectedDocumentFiles.isNotEmpty)
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
                      '${selectedDocumentFiles.length}',
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
