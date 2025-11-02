import 'package:equatable/equatable.dart';

class ScheduleEntity extends Equatable {
  final int id;
  final String name;
  final double latitude;
  final double longitude;
  final int radius;
  final DateTime? startTime;
  final DateTime? endTime;

  const ScheduleEntity({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.radius,
    this.startTime,
    this.endTime,
  });

  @override
  List<Object?> get props => [id, name, latitude, longitude, radius, startTime, endTime];
}
