import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../domain/usecases/login_user.dart';
import '../../domain/usecases/signup_user.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUser _loginUser;
  final SignUpUser _signUpUser;
  final FlutterSecureStorage _secureStorage;

  AuthBloc({
    required LoginUser loginUser,
    required SignUpUser signUpUser,
    required FlutterSecureStorage secureStorage,
  })  : _loginUser = loginUser,
        _signUpUser = signUpUser,
        _secureStorage = secureStorage,
        super(AuthInitial()) {
    on<AuthLoginSubmitted>(_onLoginSubmitted);
    on<AuthSignUpSubmitted>(_onSignUpSubmitted);
  }

  Future<void> _onLoginSubmitted(
    AuthLoginSubmitted event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final token = await _loginUser(email: event.email, password: event.password);
      await _secureStorage.write(key: 'jwt_token', value: token);
      emit(const AuthAuthenticated());
    } catch (e) {
      emit(AuthFailure(message: e.toString()));
    }
  }

  Future<void> _onSignUpSubmitted(
    AuthSignUpSubmitted event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      await _signUpUser(
        email: event.email,
        password: event.password,
        name: event.name,
        attendanceCategory: event.attendanceCategory,
      );
      emit(AuthUnauthenticated());
    } catch (e) {
      emit(AuthFailure(message: e.toString()));
    }
  }
}