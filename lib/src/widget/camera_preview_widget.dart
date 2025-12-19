import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CameraPreviewWidget extends StatefulWidget {
  final Future<void> Function(ImageSource source) pickImageCamera;

  const CameraPreviewWidget({super.key, required this.pickImageCamera});

  @override
  State<CameraPreviewWidget> createState() => _CameraPreviewWidgetState();
}

class _CameraPreviewWidgetState extends State<CameraPreviewWidget> {
  CameraController? _cameraController;
  Future<void>? _initializeFuture;
  Object? _initError;

  @override
  void initState() {
    super.initState();
    _initializeFuture = _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    if (kIsWeb) {
      return;
    }

    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) {
        return;
      }

      final camera = cameras.firstWhere(
        (c) => c.lensDirection == CameraLensDirection.back,
        orElse: () => cameras.first,
      );

      final controller = CameraController(
        camera,
        ResolutionPreset.low,
        enableAudio: false,
      );
      _cameraController = controller;
      await controller.initialize();
    } catch (e) {
      _initError = e;
    }
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        widget.pickImageCamera(ImageSource.camera);
      },
      child: Stack(
        children: [
          SizedBox(
            width: 150,
            height: 150,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12.0),
              child: FutureBuilder<void>(
                future: _initializeFuture,
                builder: (context, snapshot) {
                  final controller = _cameraController;

                  if (_initError != null || controller == null) {
                    return Container(color: Colors.black);
                  }

                  if (snapshot.connectionState != ConnectionState.done ||
                      !controller.value.isInitialized) {
                    return Container(color: Colors.black);
                  }

                  return FittedBox(
                    fit: BoxFit.cover,
                    clipBehavior: Clip.hardEdge,
                    child: SizedBox(
                      width: 150,
                      height: 150 / controller.value.aspectRatio,
                      child: CameraPreview(controller),
                    ),
                  );
                },
              ),
            ),
          ),
          Positioned(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12.0),
              child: Container(
                width: 150,
                height: 150,
                color: Colors.black.withValues(alpha: 0.5),
              ),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.044,
            left: MediaQuery.of(context).size.width * 0.098,
            child: const Icon(Icons.camera_alt, color: Colors.white, size: 50),
          ),
        ],
      ),
    );
  }
}

class FackeCameraWidget extends StatelessWidget {
  final Future<void> Function(ImageSource source) pickImageCamera;
  const FackeCameraWidget({super.key, required this.pickImageCamera});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        pickImageCamera(ImageSource.camera);
      },
      child: SizedBox(
        width: 150,
        height: 150,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12.0),
          child: Stack(
            children: [
              Positioned(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12.0),
                  child: Container(
                    width: 150,
                    height: 150,
                    color: Colors.black.withValues(alpha: 0.5),
                  ),
                ),
              ),
              Positioned(
                top: MediaQuery.of(context).size.height * 0.044,
                left: MediaQuery.of(context).size.width * 0.098,
                child: const Icon(
                  Icons.camera_alt,
                  color: Colors.white,
                  size: 50,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
