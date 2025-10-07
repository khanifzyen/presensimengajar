import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';

import '../../domain/entities/schedule_entity.dart';
import '../../domain/repositories/attendance_repository.dart';
import '../datasources/attendance_remote_datasource.dart';
import '../datasources/live_camera_datasource.dart';
import '../datasources/location_datasource.dart';

class AttendanceRepositoryImpl implements AttendanceRepository {
  final LocationDataSource locationDataSource;
  final LiveCameraDataSource cameraDataSource;
  final AttendanceRemoteDataSource remoteDataSource;
  final FlutterSecureStorage secureStorage;

  static const _activeCheckInIdKey = 'active_check_in_id';

  AttendanceRepositoryImpl({
    required this.locationDataSource,
    required this.cameraDataSource,
    required this.remoteDataSource,
    required this.secureStorage,
  });

  @override
  Future<void> checkIn({required int scheduleId}) async {
    try {
      // 1. Get current location
      final Position position = await locationDataSource.getCurrentPosition();

      // 2. Take a picture
      final XFile photo = await cameraDataSource.takePicture();

      // 3. Send data to the backend
      final response = await remoteDataSource.checkIn(
        position: position,
        photo: photo,
        scheduleId: scheduleId,
      );

      // 4. Save the active check-in ID
      final int newAttendanceId = response['id'];
      await _saveActiveCheckInId(newAttendanceId);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> checkOut() async {
    try {
      // 1. Get active check-in ID
      final activeId = await getActiveCheckInId();
      if (activeId == null) {
        throw Exception('No active check-in found to check out from.');
      }

      // 2. Get current location
      final Position position = await locationDataSource.getCurrentPosition();

      // 3. Take a picture
      final XFile photo = await cameraDataSource.takePicture();

      // 4. Call remote data source
      await remoteDataSource.checkOut(
        attendanceId: activeId,
        position: position,
        photo: photo,
      );

      // 5. Clear the active ID on success
      await clearActiveCheckInId();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<ScheduleEntity> getSchedule(int scheduleId) async {
    try {
      return await remoteDataSource.getSchedule(scheduleId);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<ScheduleEntity> getTodaySchedule() async {
    try {
      return await remoteDataSource.getTodaySchedule();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<int?> getActiveCheckInId() async {
    final idString = await secureStorage.read(key: _activeCheckInIdKey);
    if (idString != null) {
      return int.tryParse(idString);
    }
    return null;
  }

  @override
  Future<void> clearActiveCheckInId() async {
    await secureStorage.delete(key: _activeCheckInIdKey);
  }

  Future<void> _saveActiveCheckInId(int id) async {
    await secureStorage.write(key: _activeCheckInIdKey, value: id.toString());
  }
}