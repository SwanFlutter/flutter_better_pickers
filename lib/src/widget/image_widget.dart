// ignore_for_file: must_be_immutable

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_better_pickers/flutter_better_pickers.dart';

class ImageWidget extends StatefulWidget {
  /// The size of the image widget.
  final Size size;

  /// The instance of CustomPicker used within this widget.
  final CustomPicker widget;

  /// The currently selected asset path (can be null).
  String? selectedEntity;

  /// The list of all available asset paths.
  final List<String> assetsList;

  /// The list of selected asset paths.
  final List<String> selectedAssetList;

  /// Indicates whether a loading process is in progress.
  bool loading;

  /// Constructor for the ImageWidget class.
  ImageWidget({
    super.key,
    required this.size,
    required this.widget,
    required this.assetsList,
    required this.selectedAssetList,
    required this.selectedEntity,
    required this.loading,
  });

  @override
  State<ImageWidget> createState() => _ImageWidgetState();
}

class _ImageWidgetState extends State<ImageWidget> {
  PickerLabels get _labels => widget.widget.labels ?? const PickerLabels();
  PickerStyle get _style => widget.widget.style ?? const PickerStyle();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 5.0),
        child: SizedBox(
          width: widget.size.width,
          height: double.maxFinite,
          child: widget.widget.showOnlyImage
              ? Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5.0),
                  child: widget.assetsList.isEmpty
                      ? Center(
                          child: widget.loading
                              ? _style.loadingWidget ??
                                    const CircularProgressIndicator.adaptive()
                              : Text(
                                  _labels.noImagesFound,
                                  style:
                                      _style.emptyListTextStyle ??
                                      TextStyle(
                                        color: _style.emptyListTextColor,
                                        fontSize: 20,
                                      ),
                                ),
                        )
                      : GridView.builder(
                          physics: const BouncingScrollPhysics(),
                          itemCount: widget.assetsList.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                crossAxisSpacing: 3,
                                mainAxisSpacing: 3,
                                mainAxisExtent: 115,
                                childAspectRatio: 5.0,
                              ),
                          itemBuilder: (context, index) {
                            String assetPath = widget.assetsList[index];
                            return assetWidget(
                              assetPath,
                              widget.widget.maxCount,
                            );
                          },
                        ),
                )
              : Center(
                  child: Text(
                    _labels.noImagesFound,
                    style:
                        _style.emptyListTextStyle ??
                        TextStyle(
                          color: _style.emptyListTextColor,
                          fontSize: 20,
                        ),
                  ),
                ),
        ),
      ),
    );
  }

  Widget assetWidget(String assetPath, int maxCount) {
    bool isSelected = widget.selectedAssetList.contains(assetPath);

    return GestureDetector(
      onTap: () {
        setState(() {
          if (isSelected) {
            widget.selectedAssetList.remove(assetPath);
          } else if (widget.selectedAssetList.length < maxCount) {
            widget.selectedAssetList.add(assetPath);
          }
        });
      },
      child: Stack(
        children: [
          Positioned.fill(child: _buildImagePreview(assetPath)),
          if (isSelected)
            Positioned.fill(
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.black54,
                  border: Border.all(width: 8, color: Colors.white70),
                ),
                child: const Icon(Icons.check, color: Colors.white, size: 30),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildImagePreview(String assetPath) {
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

  void selectedAsset({required String assetPath, required int maxCount}) {
    if (widget.selectedAssetList.contains(assetPath)) {
      setState(() {
        widget.selectedAssetList.remove(assetPath);
      });
    } else if (widget.selectedAssetList.length < maxCount) {
      setState(() {
        widget.selectedAssetList.add(assetPath);
      });
    }
  }
}
