import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:media_manager/media_manager.dart';

class VideoWidget extends StatefulWidget {
  final String videoPath;
  final MediaManager mediaManager;
  final bool isSelected;
  final VoidCallback onTap;

  const VideoWidget({
    super.key,
    required this.videoPath,
    required this.mediaManager,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<VideoWidget> createState() => _VideoWidgetState();
}

class _VideoWidgetState extends State<VideoWidget> {
  Future<Uint8List?>? _thumbnailFuture;

  @override
  void initState() {
    super.initState();
    _thumbnailFuture = widget.mediaManager.getVideoThumbnail(widget.videoPath);
  }

  @override
  void didUpdateWidget(covariant VideoWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.videoPath != widget.videoPath ||
        oldWidget.mediaManager != widget.mediaManager) {
      _thumbnailFuture = widget.mediaManager.getVideoThumbnail(widget.videoPath);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Stack(
        children: [
          Positioned.fill(child: _buildVideoThumbnail()),
          Container(
            color: widget.isSelected ? Colors.white60 : Colors.transparent,
          ),
          if (widget.isSelected)
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
                child: const Icon(Icons.check, color: Colors.white, size: 16),
              ),
            ),
          Positioned(
            bottom: 4,
            right: 4,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Icon(
                Icons.play_arrow,
                color: Colors.white,
                size: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVideoThumbnail() {
    return FutureBuilder<Uint8List?>(
      future: _thumbnailFuture,
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data != null) {
          return Image.memory(
            snapshot.data!,
            fit: BoxFit.cover,
            filterQuality: FilterQuality.low,
          );
        }
        return Container(
          color: Colors.grey[300],
          child: const Icon(Icons.video_file, color: Colors.grey),
        );
      },
    );
  }
}
