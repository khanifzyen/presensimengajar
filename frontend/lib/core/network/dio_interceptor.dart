import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class JwtInterceptor extends Interceptor {
  final FlutterSecureStorage secureStorage;

  JwtInterceptor({required this.secureStorage});

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Do not add token for auth endpoints
    if (options.path.contains('/auth/')) {
      return handler.next(options);
    }

    final token = await secureStorage.read(key: 'jwt_token');

    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    return handler.next(options);
  }
}
