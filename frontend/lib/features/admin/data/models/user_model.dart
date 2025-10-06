import 'package:presensimengajar/features/auth/domain/entities/user.dart';

class UserModel extends User {
  UserModel({
    required super.id,
    required super.email,
    required super.name,
    required super.role,
    required super.attendanceCategory,
    super.profilePhotoUrl,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      email: json['email'],
      name: json['name'],
      role: Role.values.firstWhere((e) => e.name == json['role']),
      attendanceCategory: AttendanceCategory.values
          .firstWhere((e) => e.name == json['attendanceCategory']),
      profilePhotoUrl: json['profilePhotoUrl'],
    );
  }
}
