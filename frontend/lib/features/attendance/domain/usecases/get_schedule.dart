import '../entities/schedule_entity.dart';
import '../repositories/attendance_repository.dart';

class GetSchedule {
  final AttendanceRepository repository;

  GetSchedule(this.repository);

  Future<ScheduleEntity> call(int scheduleId) {
    return repository.getSchedule(scheduleId);
  }
}
