part of 'attendance_bloc.dart';

abstract class AttendanceEvent extends Equatable {
  const AttendanceEvent();

  @override
  List<Object> get props => [];
}

class CheckInButtonPressed extends AttendanceEvent {
  final int scheduleId;

  const CheckInButtonPressed(this.scheduleId);

  @override
  List<Object> get props => [scheduleId];
}

class CheckOutButtonPressed extends AttendanceEvent {}

class FetchScheduleDetails extends AttendanceEvent {
  final int scheduleId;

  const FetchScheduleDetails(this.scheduleId);

  @override
  List<Object> get props => [scheduleId];
}

class FetchTodaySchedule extends AttendanceEvent {}

class CheckForActiveCheckIn extends AttendanceEvent {}