import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:presensimengajar/core/network/dio_interceptor.dart';

import 'package:presensimengajar/features/admin/data/datasources/admin_remote_datasource.dart';
import 'package:presensimengajar/features/admin/data/repositories/admin_repository_impl.dart';
import 'package:presensimengajar/features/admin/domain/repositories/admin_repository.dart';
import 'package:presensimengajar/features/admin/domain/usecases/delete_user.dart';
import 'package:presensimengajar/features/admin/domain/usecases/get_users.dart';
import 'package:presensimengajar/features/admin/presentation/bloc/users_bloc.dart';

import 'package:presensimengajar/features/attendance/data/datasources/attendance_remote_datasource.dart';
import 'package:presensimengajar/features/attendance/data/datasources/live_camera_datasource.dart';
import 'package:presensimengajar/features/attendance/data/datasources/location_datasource.dart';
import 'package:presensimengajar/features/attendance/data/repositories/attendance_repository_impl.dart';
import 'package:presensimengajar/features/attendance/domain/repositories/attendance_repository.dart';
import 'package:presensimengajar/features/attendance/domain/usecases/check_in.dart';
import 'package:presensimengajar/features/attendance/domain/usecases/check_out.dart';
import 'package:presensimengajar/features/attendance/domain/usecases/get_schedule.dart';
import 'package:presensimengajar/features/attendance/domain/usecases/get_today_schedule.dart';
import 'package:presensimengajar/features/attendance/presentation/bloc/attendance_bloc.dart';

import 'package:presensimengajar/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:presensimengajar/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:presensimengajar/features/auth/domain/repositories/auth_repository.dart';
import 'package:presensimengajar/features/auth/domain/usecases/login_user.dart';
import 'package:presensimengajar/features/auth/domain/usecases/signup_user.dart';
import 'package:presensimengajar/features/auth/presentation/bloc/auth_bloc.dart';

final sl = GetIt.instance;

void init() {
  // BLoC
  sl.registerFactory(
    () => AuthBloc(
      loginUser: sl<LoginUser>(),
      signUpUser: sl<SignUpUser>(),
      secureStorage: sl<FlutterSecureStorage>(),
    ),
  );
  sl.registerFactory(
    () => AttendanceBloc(
      checkIn: sl<CheckIn>(),
      checkOut: sl<CheckOut>(),
      getSchedule: sl<GetSchedule>(),
      getTodaySchedule: sl<GetTodaySchedule>(),
      repository: sl<AttendanceRepository>(),
    ),
  );
  sl.registerFactory(
    () => UsersBloc(getUsers: sl<GetUsers>(), deleteUser: sl<DeleteUser>()),
  );

  // Use Cases
  sl.registerLazySingleton(() => LoginUser(sl<AuthRepository>()));
  sl.registerLazySingleton(() => SignUpUser(sl<AuthRepository>()));
  sl.registerLazySingleton(() => CheckIn(sl<AttendanceRepository>()));
  sl.registerLazySingleton(() => CheckOut(sl<AttendanceRepository>()));
  sl.registerLazySingleton(() => GetSchedule(sl<AttendanceRepository>()));
  sl.registerLazySingleton(() => GetTodaySchedule(sl<AttendanceRepository>()));
  sl.registerLazySingleton(() => GetUsers(sl<AdminRepository>()));
  sl.registerLazySingleton(() => DeleteUser(sl<AdminRepository>()));

  // Repository
  sl.registerLazySingleton<AttendanceRepository>(
    () => AttendanceRepositoryImpl(
      remoteDataSource: sl<AttendanceRemoteDataSource>(),
      cameraDataSource: sl<LiveCameraDataSource>(),
      locationDataSource: sl<LocationDataSource>(),
      secureStorage: sl<FlutterSecureStorage>(),
    ),
  );
  sl.registerLazySingleton<AdminRepository>(
    () => AdminRepositoryImpl(remoteDataSource: sl<AdminRemoteDataSource>()),
  );
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteDataSource: sl<AuthRemoteDataSource>()),
  );

  // Data Sources
  sl.registerLazySingleton<AttendanceRemoteDataSource>(
    () => AttendanceRemoteDataSourceImpl(dio: sl<Dio>()),
  );
  sl.registerLazySingleton<LocationDataSource>(() => LocationDataSourceImpl());
  sl.registerLazySingleton<LiveCameraDataSource>(() => LiveCameraDataSource());
  sl.registerLazySingleton<AdminRemoteDataSource>(
    () => AdminRemoteDataSourceImpl(dio: sl<Dio>()),
  );
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(dio: sl<Dio>()),
  );

  // External
  sl.registerLazySingleton(() {
    final dio = Dio();
    dio.options.baseUrl = dotenv.env['BASE_URL']!;
    dio.interceptors.add(JwtInterceptor(secureStorage: sl<FlutterSecureStorage>()));
    return dio;
  });
  sl.registerLazySingleton(() => const FlutterSecureStorage());
}