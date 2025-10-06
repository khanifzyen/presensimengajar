import '../repositories/admin_repository.dart';

class DeleteUser {
  final AdminRepository repository;

  DeleteUser(this.repository);

  Future<void> call(int userId) {
    return repository.deleteUser(userId);
  }
}
