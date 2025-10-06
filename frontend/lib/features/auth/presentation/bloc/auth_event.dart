part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class AuthLoginSubmitted extends AuthEvent {
  final String email;
  final String password;

  const AuthLoginSubmitted({required this.email, required this.password});

  @override
  List<Object> get props => [email, password];
}

class AuthSignUpSubmitted extends AuthEvent {
  final String email;
  final String password;
  final String name;
  final String attendanceCategory;

  const AuthSignUpSubmitted({
    required this.email,
    required this.password,
    required this.name,
    required this.attendanceCategory,
  });

  @override
  List<Object> get props => [email, password, name, attendanceCategory];
}
