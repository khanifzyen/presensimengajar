import '../repositories/attendance_repository.dart';

class CheckIn {
  final AttendanceRepository repository;

  CheckIn(this.repository);

  Future<void> call({required int scheduleId}) {
    return repository.checkIn(scheduleId: scheduleId);
  }
}