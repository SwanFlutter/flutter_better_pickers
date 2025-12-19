import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_better_pickers/flutter_better_pickers.dart';

/// Optimized cached image widget - uses direct Image.file for images
/// and only uses MediaManager for video thumbnails
class CachedMediaPreview extends StatefulWidget {
  final String path;
  final MyRequestType requestType;
  final BoxFit fit;

  const CachedMediaPreview({
    super.key,
    required this.path,
    required this.requestType,
    this.fit = BoxFit.cover,
  });

  @override
  State<CachedMediaPreview> createState() => _CachedMediaPreviewState();
}

class _CachedMediaPreviewState extends State<CachedMediaPreview>
    with AutomaticKeepAliveClientMixin {
  static final MediaManager _mediaManager = MediaManager();
  static final Map<String, Uint8List> _videoThumbnailCache = {};

  Uint8List? _thumbnailData;
  bool _isLoading = false;
  bool _hasError = false;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    if (widget.requestType == MyRequestType.video) {
      _loadVideoThumbnail();
    }
  }

  @override
  void didUpdateWidget(CachedMediaPreview oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.path != widget.path) {
      if (widget.requestType == MyRequestType.video) {
        _loadVideoThumbnail();
      }
    }
  }

  Future<void> _loadVideoThumbnail() async {
    // Check cache first
    if (_videoThumbnailCache.containsKey(widget.path)) {
      setState(() {
        _thumbnailData = _videoThumbnailCache[widget.path];
      });
      return;
    }

    if (_isLoading) return;

    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    try {
      final data = await _mediaManager.getVideoThumbnail(widget.path);
      if (data != null && mounted) {
        _videoThumbnailCache[widget.path] = data;
        setState(() {
          _thumbnailData = data;
          _isLoading = false;
        });
      } else if (mounted) {
        setState(() {
          _hasError = true;
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Error loading video thumbnail: $e');
      if (mounted) {
        setState(() {
          _hasError = true;
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    // For images, use Image.file directly - it has built-in caching
    if (widget.requestType != MyRequestType.video) {
      return Image.file(
        File(widget.path),
        fit: widget.fit,
        cacheWidth: 200,
        filterQuality: FilterQuality.low,
        errorBuilder: (context, error, stackTrace) {
          return _buildPlaceholder(Icons.broken_image);
        },
      );
    }

    // For videos, use cached thumbnail
    if (_thumbnailData != null) {
      return Image.memory(
        _thumbnailData!,
        fit: widget.fit,
        filterQuality: FilterQuality.low,
      );
    }

    if (_hasError) {
      return _buildPlaceholder(Icons.video_file);
    }

    // Loading state - show video icon, not spinner
    return _buildPlaceholder(Icons.video_file);
  }

  Widget _buildPlaceholder(IconData icon) {
    return Container(
      color: Colors.grey[300],
      child: Center(child: Icon(icon, size: 30, color: Colors.grey[600])),
    );
  }
}
