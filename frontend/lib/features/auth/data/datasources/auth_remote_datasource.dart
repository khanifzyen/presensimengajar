import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

abstract class AuthRemoteDataSource {
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

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio dio;
  final String _baseUrl = dotenv.env['BASE_URL']!;

  AuthRemoteDataSourceImpl({required this.dio});

  @override
  Future<void> signUp({
    required String email,
    required String password,
    required String name,
    required String attendanceCategory,
  }) async {
    try {
      await dio.post(
        '$_baseUrl/auth/signup',
        data: {
          'email': email,
          'password': password,
          'name': name,
          'attendanceCategory': attendanceCategory,
        },
      );
      // Backend returns the created user, but for the sign-up flow, we don't need to return anything.
    } on DioException catch (e) {
      // TODO: Implement proper error handling
      throw Exception('Failed to sign up: ${e.response?.data['message'] ?? e.message}');
    }
  }

  @override
  Future<String> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await dio.post(
        '$_baseUrl/auth/login',
        data: {
          'email': email,
          'password': password,
        },
      );

      if (response.statusCode == 200 && response.data['access_token'] != null) {
        return response.data['access_token'];
      } else {
        throw Exception('Login failed: Invalid response from server');
      }
    } on DioException catch (e) {
      // TODO: Implement proper error handling
      throw Exception('Failed to login: ${e.response?.data['message'] ?? e.message}');
    }
  }
}
