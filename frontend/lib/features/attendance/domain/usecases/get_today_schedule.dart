import '../entities/schedule_entity.dart';
import '../repositories/attendance_repository.dart';

class GetTodaySchedule {
  final AttendanceRepository repository;

  GetTodaySchedule(this.repository);

  Future<ScheduleEntity> call() {
    return repository.getTodaySchedule();
  }
}
