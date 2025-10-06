import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../auth/domain/entities/user.dart';
import '../../domain/usecases/get_users.dart';
import '../../domain/usecases/delete_user.dart';

part 'users_event.dart';
part 'users_state.dart';

class UsersBloc extends Bloc<UsersEvent, UsersState> {
  final GetUsers _getUsers;
  final DeleteUser _deleteUser;

  UsersBloc({
    required GetUsers getUsers,
    required DeleteUser deleteUser,
  })  : _getUsers = getUsers,
        _deleteUser = deleteUser,
        super(UsersInitial()) {
    on<FetchUsers>(_onFetchUsers);
    on<DeleteUserRequested>(_onDeleteUserRequested);
  }

  Future<void> _onFetchUsers(
    FetchUsers event,
    Emitter<UsersState> emit,
  ) async {
    emit(UsersLoading());
    try {
      final users = await _getUsers();
      emit(UsersLoaded(users: users));
    } catch (e) {
      emit(UsersError(message: e.toString()));
    }
  }

  Future<void> _onDeleteUserRequested(
    DeleteUserRequested event,
    Emitter<UsersState> emit,
  ) async {
    try {
      await _deleteUser(event.userId);
      // After deleting, refresh the user list
      add(FetchUsers());
    } catch (e) {
      // Optionally, emit a specific error state for deletion failure
      emit(UsersError(message: e.toString()));
    }
  }
}
