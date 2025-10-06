part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

// Initial state, app is starting, maybe checking for an existing token
class AuthInitial extends AuthState {}

// Loading state, for when we are performing an async operation like login/signup
class AuthLoading extends AuthState {}

// State when the user is successfully authenticated
class AuthAuthenticated extends AuthState {
  // In a real app, you might hold user data or a token here
  const AuthAuthenticated();

  @override
  List<Object> get props => [];
}

// State when the user is not authenticated
class AuthUnauthenticated extends AuthState {}

// State for any authentication failures
class AuthFailure extends AuthState {
  final String message;

  const AuthFailure({required this.message});

  @override
  List<Object> get props => [message];
}
