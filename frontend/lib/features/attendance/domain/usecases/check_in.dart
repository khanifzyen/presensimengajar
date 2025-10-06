import '../repositories/attendance_repository.dart';

class CheckIn {
  final AttendanceRepository repository;

  CheckIn(this.repository);

  Future<void> call() {
    return repository.checkIn();
  }
}
