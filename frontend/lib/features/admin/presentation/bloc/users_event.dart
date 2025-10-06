part of 'users_bloc.dart';

abstract class UsersEvent extends Equatable {
  const UsersEvent();

  @override
  List<Object> get props => [];
}

class FetchUsers extends UsersEvent {}

class DeleteUserRequested extends UsersEvent {
  final int userId;

  const DeleteUserRequested({required this.userId});

  @override
  List<Object> get props => [userId];
}
