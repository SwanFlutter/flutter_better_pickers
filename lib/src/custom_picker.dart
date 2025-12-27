// ignore_for_file: unnecessary_import

import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_better_pickers/flutter_better_pickers.dart';
import 'package:flutter_better_pickers/src/config/media_manager_config.dart';
import 'package:flutter_better_pickers/src/tools/media_manager_wrapper.dart';
import 'package:media_manager/media_manager.dart';

/// A custom media picker widget with tabbed interface.
///
/// This widget provides a tabbed interface for selecting images and videos
/// separately, with customizable labels and styling.
///
/// Example:
/// ```dart
/// CustomPicker(
///   maxCount: 10,
///   requestType: MyRequestType.all,
///   showOnlyImage: true,
///   showOnlyVideo: true,
///   labels: PickerLabels.persian,
///   style: PickerStyle.telegram,
/// )
/// ```
class CustomPicker extends StatefulWidget {
  /// Maximum number of media items that can be selected
  final int maxCount;

  /// Type of media to display (image, video, audio, etc.)
  final MyRequestType requestType;

  /// Whether to show video tab (default: true)
  final bool showOnlyVideo;

  /// Whether to show image tab (default: true)
  final bool showOnlyImage;

  /// Camera image settings for quality and dimensions
  final CameraImageSettings? cameraImageSettings;

  /// Labels for internationalization.
  /// Use predefined labels like [PickerLabels.english], [PickerLabels.chinese],
  /// or create custom labels.
  final PickerLabels? labels;

  /// Style configuration for colors, sizes, and widgets.
  /// Use predefined styles like [PickerStyle.instagram], [PickerStyle.whatsapp],
  /// or create custom styles.
  final PickerStyle? style;

  const CustomPicker({
    super.key,
    required this.maxCount,
    required this.requestType,
    this.showOnlyVideo = true,
    this.showOnlyImage = true,
    this.cameraImageSettings,
    this.labels,
    this.style,
  });

  @override
  State<CustomPicker> createState() => _CustomPickerState();
}

class _CustomPickerState extends State<CustomPicker>
    with TickerProviderStateMixin {
  late TabController _tabController;
  List<String> _imagePaths = [];
  List<String> _videoPaths = [];
  final ValueNotifier<List<String>> _selectedPathsNotifier =
      ValueNotifier<List<String>>([]);
  bool _isLoading = true;
  File? _cameraImage;

  PickerLabels get _labels => widget.labels ?? const PickerLabels();
  PickerStyle get _style => widget.style ?? const PickerStyle();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    // Enable isolates for better performance
    MediaManagerConfig.configurePerformance(useIsolates: true);
    _loadMedia();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _selectedPathsNotifier.dispose();
    super.dispose();
  }

  Future<void> _loadMedia() async {
    if (!mounted) return;

    setState(() => _isLoading = true);

    try {
      final images = await MediaManagerWrapper.getAllImages();
      final videos = await MediaManagerWrapper.getAllVideos();

      if (mounted) {
        setState(() {
          _imagePaths = images;
          _videoPaths = videos;
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Error loading media: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
          _imagePaths = [];
          _videoPaths = [];
        });
      }
    }
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

  void _confirmSelection() {
    List<String> selectedPaths = _selectedPathsNotifier.value;
    if (selectedPaths.isEmpty && _cameraImage != null) {
      selectedPaths = [_cameraImage!.path];
    }

    if (selectedPaths.isNotEmpty) {
      Navigator.pop(context, selectedPaths);
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('No media selected')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: _style.backgroundColor,
        appBar: AppBar(
          backgroundColor: _style.appBarColor,
          title: Text(
            _labels.title,
            style:
                _style.titleTextStyle ??
                const TextStyle(fontSize: 22, color: Colors.white),
          ),
          centerTitle: true,
          elevation: 0,
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 15.0),
              child: ValueListenableBuilder<List<String>>(
                valueListenable: _selectedPathsNotifier,
                builder: (context, selectedPaths, child) {
                  return InkResponse(
                    onTap: _confirmSelection,
                    child: Center(
                      child: Text(
                        _labels.confirmButtonText,
                        style: TextStyle(
                          color: _style.confirmTextColor,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
        body: Column(
          children: [
            TabBar(
              controller: _tabController,
              indicatorColor: _style.tabIndicatorColor,
              labelColor: _style.textColor,
              unselectedLabelColor: _style.unselectedTabColor,
              tabs: [
                Tab(text: _labels.imagesTab),
                Tab(text: _labels.videosTab),
              ],
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildMediaGrid(_imagePaths, MyRequestType.image),
                  _buildMediaGrid(_videoPaths, MyRequestType.video),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMediaGrid(List<String> paths, MyRequestType type) {
    return _MediaGridPage(
      paths: paths,
      type: type,
      isLoading: _isLoading,
      style: _style,
      labels: _labels,
      selectedPathsNotifier: _selectedPathsNotifier,
      onToggle: _toggleSelection,
    );
  }
}

class _MediaGridPage extends StatefulWidget {
  final List<String> paths;
  final MyRequestType type;
  final bool isLoading;
  final PickerStyle style;
  final PickerLabels labels;
  final ValueNotifier<List<String>> selectedPathsNotifier;
  final Function(String) onToggle;

  const _MediaGridPage({
    required this.paths,
    required this.type,
    required this.isLoading,
    required this.style,
    required this.labels,
    required this.selectedPathsNotifier,
    required this.onToggle,
  });

  @override
  State<_MediaGridPage> createState() => _MediaGridPageState();
}

class _MediaGridPageState extends State<_MediaGridPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    if (widget.isLoading) {
      return Center(
        child:
            widget.style.loadingWidget ??
            const CircularProgressIndicator.adaptive(),
      );
    }

    if (widget.paths.isEmpty) {
      return Center(
        child: Text(
          widget.labels.noMediaFound,
          style:
              widget.style.emptyListTextStyle ??
              TextStyle(color: widget.style.emptyListTextColor),
        ),
      );
    }

    return GridView.builder(
      padding: widget.style.gridPadding,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: widget.style.gridCrossAxisCount,
        crossAxisSpacing: widget.style.gridSpacing,
        mainAxisSpacing: widget.style.gridSpacing,
      ),
      itemCount: widget.paths.length,
      itemBuilder: (context, index) {
        final path = widget.paths[index];

        return _GridItem(
          path: path,
          type: widget.type,
          selectedPathsNotifier: widget.selectedPathsNotifier,
          onTap: () => widget.onToggle(path),
        );
      },
    );
  }
}

class _GridItem extends StatelessWidget {
  final String path;
  final MyRequestType type;
  final ValueNotifier<List<String>> selectedPathsNotifier;
  final VoidCallback onTap;

  const _GridItem({
    required this.path,
    required this.type,
    required this.selectedPathsNotifier,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          Positioned.fill(
            child: type == MyRequestType.video
                ? _VideoThumbnail(path: path)
                : Image.file(
                    File(path),
                    fit: BoxFit.cover,
                    cacheWidth: 200,
                    filterQuality: FilterQuality.low,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey[300],
                        child: const Icon(
                          Icons.broken_image,
                          color: Colors.grey,
                        ),
                      );
                    },
                  ),
          ),
          if (type == MyRequestType.video)
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
                  Container(color: Colors.white60),
                  Positioned(
                    top: 5,
                    right: 5,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.blue,
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

/// Video thumbnail widget with caching
class _VideoThumbnail extends StatefulWidget {
  final String path;

  const _VideoThumbnail({required this.path});

  @override
  State<_VideoThumbnail> createState() => _VideoThumbnailState();
}

class _VideoThumbnailState extends State<_VideoThumbnail>
    with AutomaticKeepAliveClientMixin {
  static final Map<String, Uint8List> _cache = {};
  static final MediaManager _mediaManager = MediaManager();

  Uint8List? _data;
  bool _loading = false;
  bool _error = false;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void didUpdateWidget(_VideoThumbnail old) {
    super.didUpdateWidget(old);
    if (old.path != widget.path) _load();
  }

  Future<void> _load() async {
    if (_cache.containsKey(widget.path)) {
      setState(() => _data = _cache[widget.path]);
      return;
    }
    if (_loading) return;
    setState(() => _loading = true);
    try {
      final data = await _mediaManager.getVideoThumbnail(widget.path);
      if (data != null && mounted) {
        _cache[widget.path] = data;
        setState(() {
          _data = data;
          _loading = false;
        });
      } else if (mounted) {
        setState(() {
          _error = true;
          _loading = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _error = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (_data != null) {
      return Image.memory(
        _data!,
        fit: BoxFit.cover,
        filterQuality: FilterQuality.low,
      );
    }
    if (_error) {
      return Container(
        color: Colors.grey[300],
        child: const Center(
          child: Icon(Icons.videocam_off, color: Colors.grey),
        ),
      );
    }
    return Container(
      color: Colors.grey[300],
      child: const Center(child: Icon(Icons.video_file, color: Colors.grey)),
    );
  }
}
