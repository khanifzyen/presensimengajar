import 'package:image_picker/image_picker.dart';
import '../entities/schedule_entity.dart';

abstract class AttendanceRepository {
  Future<void> checkIn({required int scheduleId});
  Future<void> checkOut();
  Future<ScheduleEntity> getSchedule(int scheduleId);
  Future<ScheduleEntity> getTodaySchedule();
  Future<int?> getActiveCheckInId();
  Future<void> clearActiveCheckInId();
}