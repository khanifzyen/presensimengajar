enum Role {
  // ignore: constant_identifier_names
  TEACHER,
  // ignore: constant_identifier_names
  ADMIN,
}

enum AttendanceCategory {
  // ignore: constant_identifier_names
  PENGAJARAN,
  // ignore: constant_identifier_names
  KEHADIRAN_KERJA,
}

class User {
  final int id;
  final String email;
  final String name;
  final String? profilePhotoUrl;
  final Role role;
  final AttendanceCategory attendanceCategory;

  User({
    required this.id,
    required this.email,
    required this.name,
    this.profilePhotoUrl,
    required this.role,
    required this.attendanceCategory,
  });
}
