part of 'attendance_bloc.dart';

abstract class AttendanceState extends Equatable {
  const AttendanceState();

  @override
  List<Object> get props => [];
}

class AttendanceInitial extends AttendanceState {}

class AttendanceLoading extends AttendanceState {}

class AttendanceSuccess extends AttendanceState {
  final String message;

  const AttendanceSuccess({this.message = 'Check-in successful!'});

  @override
  List<Object> get props => [message];
}

class AttendanceFailure extends AttendanceState {
  final String message;

  const AttendanceFailure({required this.message});

  @override
  List<Object> get props => [message];
}

class AttendanceScheduleLoaded extends AttendanceState {
  final ScheduleEntity schedule;

  const AttendanceScheduleLoaded(this.schedule);

  @override
  List<Object> get props => [schedule];
}

class ActiveCheckInFound extends AttendanceState {
  final int attendanceId;

  const ActiveCheckInFound(this.attendanceId);

  @override
  List<Object> get props => [attendanceId];
}

class NoActiveCheckIn extends AttendanceState {}

class CheckOutSuccess extends AttendanceState {
  final String message;

  const CheckOutSuccess({this.message = 'Check-out successful!'});

  @override
  List<Object> get props => [message];
}
