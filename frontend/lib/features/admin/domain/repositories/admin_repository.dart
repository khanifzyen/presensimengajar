import 'package:presensimengajar/features/auth/domain/entities/user.dart';

abstract class AdminRepository {
  Future<List<User>> getUsers();
  Future<void> deleteUser(int userId);
}
