import '../repositories/auth_repository.dart';

class SignUpUser {
  final AuthRepository repository;

  SignUpUser(this.repository);

  Future<void> call({
    required String email,
    required String password,
    required String name,
    required String attendanceCategory,
  }) {
    return repository.signUp(
      email: email,
      password: password,
      name: name,
      attendanceCategory: attendanceCategory,
    );
  }
}
