import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/schedule_entity.dart';
import '../../domain/repositories/attendance_repository.dart';
import '../../domain/usecases/check_in.dart';
import '../../domain/usecases/check_out.dart';
import '../../domain/usecases/get_schedule.dart';
import '../../domain/usecases/get_today_schedule.dart';

part 'attendance_event.dart';
part 'attendance_state.dart';

class AttendanceBloc extends Bloc<AttendanceEvent, AttendanceState> {
  final CheckIn _checkIn;
  final CheckOut _checkOut;
  final GetSchedule _getSchedule;
  final GetTodaySchedule _getTodaySchedule;
  final AttendanceRepository _repository; // For local storage access

  AttendanceBloc({
    required CheckIn checkIn,
    required CheckOut checkOut,
    required GetSchedule getSchedule,
    required GetTodaySchedule getTodaySchedule,
    required AttendanceRepository repository,
  })  : _checkIn = checkIn,
        _checkOut = checkOut,
        _getSchedule = getSchedule,
        _getTodaySchedule = getTodaySchedule,
        _repository = repository,
        super(AttendanceInitial()) {
    on<CheckForActiveCheckIn>(_onCheckForActiveCheckIn);
    on<FetchScheduleDetails>(_onFetchScheduleDetails);
    on<FetchTodaySchedule>(_onFetchTodaySchedule);
    on<CheckInButtonPressed>(_onCheckInButtonPressed);
    on<CheckOutButtonPressed>(_onCheckOutButtonPressed);
  }

  Future<void> _onCheckForActiveCheckIn(
    CheckForActiveCheckIn event,
    Emitter<AttendanceState> emit,
  ) async {
    emit(AttendanceLoading());
    try {
      final activeId = await _repository.getActiveCheckInId();
      if (activeId != null) {
        emit(ActiveCheckInFound(activeId));
      } else {
        emit(NoActiveCheckIn());
      }
    } catch (e) {
      emit(AttendanceFailure(message: e.toString()));
    }
  }

  Future<void> _onFetchScheduleDetails(
    FetchScheduleDetails event,
    Emitter<AttendanceState> emit,
  ) async {
    emit(AttendanceLoading());
    try {
      final schedule = await _getSchedule(event.scheduleId);
      emit(AttendanceScheduleLoaded(schedule));
    } catch (e) {
      emit(AttendanceFailure(message: e.toString()));
    }
  }

  Future<void> _onFetchTodaySchedule(
    FetchTodaySchedule event,
    Emitter<AttendanceState> emit,
  ) async {
    emit(AttendanceLoading());
    try {
      final schedule = await _getTodaySchedule();
      emit(AttendanceScheduleLoaded(schedule));
    } catch (e) {
      emit(AttendanceFailure(message: e.toString()));
    }
  }

  Future<void> _onCheckInButtonPressed(
    CheckInButtonPressed event,
    Emitter<AttendanceState> emit,
  ) async {
    emit(AttendanceLoading());
    try {
      await _checkIn(scheduleId: event.scheduleId);
      emit(const AttendanceSuccess());
      add(CheckForActiveCheckIn());
    } catch (e) {
      emit(AttendanceFailure(message: e.toString()));
    }
  }

  Future<void> _onCheckOutButtonPressed(
    CheckOutButtonPressed event,
    Emitter<AttendanceState> emit,
  ) async {
    emit(AttendanceLoading());
    try {
      await _checkOut();
      emit(const CheckOutSuccess());
      add(CheckForActiveCheckIn());
    } catch (e) {
      emit(AttendanceFailure(message: e.toString()));
    }
  }
}