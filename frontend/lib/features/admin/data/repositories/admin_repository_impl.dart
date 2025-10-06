import '../../domain/repositories/admin_repository.dart';
import '../datasources/admin_remote_datasource.dart';
import 'package:presensimengajar/features/auth/domain/entities/user.dart';

class AdminRepositoryImpl implements AdminRepository {
  final AdminRemoteDataSource remoteDataSource;

  AdminRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<User>> getUsers() {
    return remoteDataSource.getUsers();
  }

  @override
  Future<void> deleteUser(int userId) {
    return remoteDataSource.deleteUser(userId);
  }
}
