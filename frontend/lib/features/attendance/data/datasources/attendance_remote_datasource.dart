import 'package:dio/dio.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';

import '../models/schedule_model.dart';

abstract class AttendanceRemoteDataSource {
  Future<Map<String, dynamic>> checkIn({
    required Position position,
    required XFile photo,
    int? scheduleId,
  });

  Future<ScheduleModel> getSchedule(int scheduleId);

  Future<ScheduleModel> getTodaySchedule();

  Future<void> checkOut({
    required int attendanceId,
    required Position position,
    required XFile photo,
  });
}

class AttendanceRemoteDataSourceImpl implements AttendanceRemoteDataSource {
  final Dio dio;

  AttendanceRemoteDataSourceImpl({required this.dio});

  @override
  Future<Map<String, dynamic>> checkIn({
    required Position position,
    required XFile photo,
    int? scheduleId,
  }) async {
    try {
      final fileName = photo.path.split('/').last;

      final Map<String, dynamic> dataMap = {
        'latitude': position.latitude,
        'longitude': position.longitude,
        'photo': await MultipartFile.fromFile(photo.path, filename: fileName),
      };

      if (scheduleId != null) {
        dataMap['scheduleId'] = scheduleId;
      }

      final formData = FormData.fromMap(dataMap);

      final response = await dio.post('/attendance/check-in', data: formData);
      return response.data;
    } on DioException catch (e) {
      throw Exception(
          'Failed to check in: ${e.response?.data['message'] ?? e.message}');
    }
  }

  @override
  Future<ScheduleModel> getSchedule(int scheduleId) async {
    try {
      final response = await dio.get('/schedules/$scheduleId');
      return ScheduleModel.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(
          'Failed to get schedule: ${e.response?.data['message'] ?? e.message}');
    }
  }

  @override
  Future<ScheduleModel> getTodaySchedule() async {
    try {
      final response = await dio.get('/schedules/today');
      return ScheduleModel.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(
          'Failed to get today\'s schedule: ${e.response?.data['message'] ?? e.message}');
    }
  }

  @override
  Future<void> checkOut({
    required int attendanceId,
    required Position position,
    required XFile photo,
  }) async {
    try {
      final fileName = photo.path.split('/').last;
      final formData = FormData.fromMap({
        'latitude': position.latitude,
        'longitude': position.longitude,
        'photo': await MultipartFile.fromFile(photo.path, filename: fileName),
      });

      await dio.post('/attendance/check-out/$attendanceId', data: formData);
    } on DioException catch (e) {
      throw Exception(
          'Failed to check out: ${e.response?.data['message'] ?? e.message}');
    }
  }
}