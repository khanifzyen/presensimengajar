import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';

import '../../domain/repositories/attendance_repository.dart';
import '../datasources/attendance_remote_datasource.dart';
import '../datasources/camera_datasource.dart';
import '../datasources/location_datasource.dart';

class AttendanceRepositoryImpl implements AttendanceRepository {
  final LocationDataSource locationDataSource;
  final CameraDataSource cameraDataSource;
  final AttendanceRemoteDataSource remoteDataSource;

  AttendanceRepositoryImpl({
    required this.locationDataSource,
    required this.cameraDataSource,
    required this.remoteDataSource,
  });

  @override
  Future<void> checkIn() async {
    try {
      // 1. Get current location (includes permission checks)
      final Position position = await locationDataSource.getCurrentPosition();

      // 2. Take a picture
      final XFile? photo = await cameraDataSource.takePicture();

      if (photo == null) {
        // User cancelled the camera, do nothing.
        // An alternative would be to throw a specific exception.
        return;
      }

      // 3. Send data to the backend
      await remoteDataSource.checkIn(position: position, photo: photo);
    } catch (e) {
      // Re-throw the exception to be handled by the BLoC in the presentation layer
      rethrow;
    }
  }
}
