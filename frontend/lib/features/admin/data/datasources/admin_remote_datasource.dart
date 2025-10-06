import 'package:dio/dio.dart';
import '../models/user_model.dart';

abstract class AdminRemoteDataSource {
  Future<List<UserModel>> getUsers();
  Future<void> deleteUser(int userId);
}

class AdminRemoteDataSourceImpl implements AdminRemoteDataSource {
  final Dio dio;

  AdminRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<UserModel>> getUsers() async {
    try {
      final response = await dio.get('/users');
      if (response.statusCode == 200) {
        final users = (response.data as List)
            .map((userJson) => UserModel.fromJson(userJson))
            .toList();
        return users;
      } else {
        throw Exception('Failed to load users');
      }
    } on DioException catch (e) {
      throw Exception('Failed to load users: ${e.message}');
    }
  }

  @override
  Future<void> deleteUser(int userId) async {
    try {
      await dio.delete('/users/$userId');
    } on DioException catch (e) {
      throw Exception('Failed to delete user: ${e.message}');
    }
  }
}
