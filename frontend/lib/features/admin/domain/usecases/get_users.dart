import 'package:presensimengajar/features/auth/domain/entities/user.dart';

import '../repositories/admin_repository.dart';

class GetUsers {
  final AdminRepository repository;

  GetUsers(this.repository);

  Future<List<User>> call() {
    return repository.getUsers();
  }
}
