// This file defines the contract for the authentication feature.

abstract class AuthRepository {
  Future<void> signUp({
    required String email,
    required String password,
    required String name,
    required String attendanceCategory,
  });

  Future<String> login({
    required String email,
    required String password,
  });
}