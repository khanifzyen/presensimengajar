import 'package:camera/camera.dart';

class LiveCameraDataSource {
  CameraController? _controller;

  CameraController? get controller => _controller;

  Future<void> initialize() async {
    // Ensure that the controller is not already initialized
    if (_controller != null) {
      return;
    }
    try {
      final cameras = await availableCameras();
      // Get a specific camera from the list of available cameras.
      // We'll use the front camera for selfies.
      final frontCamera = cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.front,
        orElse: () => cameras.first, // Fallback to the first camera if no front camera is available
      );

      _controller = CameraController(
        frontCamera,
        ResolutionPreset.medium,
        enableAudio: false,
      );

      await _controller!.initialize();
    } catch (e) {
      // If an error occurs, log the error and rethrow.
      print('Error initializing camera: $e');
      rethrow;
    }
  }

  Future<XFile> takePicture() async {
    if (_controller == null || !_controller!.value.isInitialized) {
      throw Exception('Camera not initialized');
    }
    if (_controller!.value.isTakingPicture) {
      // A capture is already pending, do nothing.
      throw Exception('A capture is already pending');
    }
    try {
      final XFile file = await _controller!.takePicture();
      return file;
    } catch (e) {
      print('Error taking picture: $e');
      rethrow;
    }
  }

  void dispose() {
    _controller?.dispose();
    _controller = null;
  }
}
