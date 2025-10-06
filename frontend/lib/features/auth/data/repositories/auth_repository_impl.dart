import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl({required this.remoteDataSource});

  @override
  Future<String> login({required String email, required String password}) {
    // For now, we directly forward the call to the data source.
    // In the future, we could add logic here to check for internet connectivity.
    return remoteDataSource.login(email: email, password: password);
  }

  @override
  Future<void> signUp({
    required String email,
    required String password,
    required String name,
    required String attendanceCategory,
  }) {
    return remoteDataSource.signUp(
      email: email,
      password: password,
      name: name,
      attendanceCategory: attendanceCategory,
    );
  }
}
