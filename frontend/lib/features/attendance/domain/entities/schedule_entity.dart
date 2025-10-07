import 'package:equatable/equatable.dart';

class ScheduleEntity extends Equatable {
  final int id;
  final String name;
  final double latitude;
  final double longitude;
  final int radius;

  const ScheduleEntity({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.radius,
  });

  @override
  List<Object?> get props => [id, name, latitude, longitude, radius];
}
