import 'package:dio/dio.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';

abstract class AttendanceRemoteDataSource {
  Future<void> checkIn({
    required Position position,
    required XFile photo,
    int? scheduleId,
  });
}

class AttendanceRemoteDataSourceImpl implements AttendanceRemoteDataSource {
  final Dio dio;

  AttendanceRemoteDataSourceImpl({required this.dio});

  @override
  Future<void> checkIn({
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

    await dio.post('/attendance/check-in', data: formData);
    } on DioException catch (e) {
      throw Exception(
          'Failed to check in: ${e.response?.data['message'] ?? e.message}');
    }
  }
}
