import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';

import '../network/dio_interceptor.dart';
import '../../features/admin/data/datasources/admin_remote_datasource.dart';
import '../../features/admin/data/repositories/admin_repository_impl.dart';
import '../../features/admin/domain/repositories/admin_repository.dart';
import '../../features/admin/domain/usecases/delete_user.dart';
import '../../features/admin/domain/usecases/get_users.dart';
import '../../features/admin/presentation/bloc/users_bloc.dart';
import '../../features/auth/data/datasources/auth_remote_datasource.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/login_user.dart';
import '../../features/auth/domain/usecases/signup_user.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final sl = GetIt.instance;

void init() {
  // BLoC
  sl.registerFactory(
    () => AuthBloc(
      loginUser: sl(),
      signUpUser: sl(),
      secureStorage: sl(), // Akan kita tambahkan
    ),
  );

sl.registerFactory(
    () => UsersBloc(getUsers: sl(), deleteUser: sl()),
  );

  // Use Cases
  sl.registerLazySingleton(() => LoginUser(sl()));
  sl.registerLazySingleton(() => SignUpUser(sl()));

  sl.registerLazySingleton(() => GetUsers(sl()));
  sl.registerLazySingleton(() => DeleteUser(sl()));

  // Repository
  sl.registerLazySingleton<AdminRepository>(
    () => AdminRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteDataSource: sl()),
  );

  // Data Sources
  sl.registerLazySingleton<AdminRemoteDataSource>(
    () => AdminRemoteDataSourceImpl(dio: sl()),
  );
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(dio: sl()),
  );

  // External
  sl.registerLazySingleton(() {
    final dio = Dio();
    dio.options.baseUrl = dotenv.env['BASE_URL']!;
    dio.interceptors.add(JwtInterceptor(secureStorage: sl()));
    return dio;
  });
  sl.registerLazySingleton(() => const FlutterSecureStorage());
}
