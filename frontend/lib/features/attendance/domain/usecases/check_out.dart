import '../repositories/attendance_repository.dart';

class CheckOut {
  final AttendanceRepository repository;

  CheckOut(this.repository);

  Future<void> call() {
    return repository.checkOut();
  }
}
