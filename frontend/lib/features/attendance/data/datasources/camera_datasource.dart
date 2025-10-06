import 'package:image_picker/image_picker.dart';

abstract class CameraDataSource {
  Future<XFile?> takePicture();
}

class CameraDataSourceImpl implements CameraDataSource {
  final ImagePicker _picker;

  // Allow injecting a mock picker for testing
  CameraDataSourceImpl({ImagePicker? picker}) : _picker = picker ?? ImagePicker();

  @override
  Future<XFile?> takePicture() async {
    try {
      final XFile? photo = await _picker.pickImage(
        source: ImageSource.camera,
        preferredCameraDevice: CameraDevice.front, // Prefer front camera for selfies
        imageQuality: 80, // Compress image slightly
      );
      return photo;
    } catch (e) {
      // Handle exceptions, e.g., if the user denies camera access at the native prompt
      throw Exception('Gagal mengambil gambar: $e');
    }
  }
}
