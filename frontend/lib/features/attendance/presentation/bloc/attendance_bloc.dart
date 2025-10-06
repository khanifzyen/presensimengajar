import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/usecases/check_in.dart';

part 'attendance_event.dart';
part 'attendance_state.dart';

class AttendanceBloc extends Bloc<AttendanceEvent, AttendanceState> {
  final CheckIn _checkIn;

  AttendanceBloc({required CheckIn checkIn}) 
      : _checkIn = checkIn,
        super(AttendanceInitial()) {
    on<CheckInButtonPressed>(_onCheckInButtonPressed);
  }

  Future<void> _onCheckInButtonPressed(
    CheckInButtonPressed event,
    Emitter<AttendanceState> emit,
  ) async {
    emit(AttendanceLoading());
    try {
      await _checkIn();
      emit(const AttendanceSuccess());
    } catch (e) {
      print('Error in _onCheckInButtonPressed: $e'); // Verbose logging
      emit(AttendanceFailure(message: e.toString()));
    }
  }
}
