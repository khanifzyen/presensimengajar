
class DevSeeds {
  static Map<String, dynamic> getSettings() {
    return {
      'documents': [
        {
          'key': 'tolerance_late_arrival',
          'value': '10',
          'description': 'Toleransi keterlambatan dalam menit',
          'type': 'integer',
          'updatedAt': DateTime.now().toIso8601String(),
        },
        {
          'key': 'tolerance_early_departure',
          'value': '10',
          'description': 'Toleransi pulang cepat dalam menit',
          'type': 'integer',
          'updatedAt': DateTime.now().toIso8601String(),
        },
        {
          'key': 'mock_location_detection',
          'value': 'true',
          'description': 'Deteksi lokasi palsu',
          'type': 'boolean',
          'updatedAt': DateTime.now().toIso8601String(),
        },
        {
          'key': 'photo_required',
          'value': 'true',
          'description': 'Wajib foto saat presensi',
          'type': 'boolean',
          'updatedAt': DateTime.now().toIso8601String(),
        },
        {
          'key': 'school_name',
          'value': 'Sekolah Demo',
          'description': 'Nama sekolah',
          'type': 'string',
          'updatedAt': DateTime.now().toIso8601String(),
        },
      ],
    };
  }

  static Map<String, dynamic> getSampleUsers() {
    return {
      'documents': [
        {
          'email': 'admin@sekolah.sch.id',
          'name': 'Admin Sekolah',
          'role': 'admin',
          'phone': '081234567890',
          'isActive': true,
          'attendanceCategory': 'admin',
          'createdAt': DateTime.now().toIso8601String(),
          'updatedAt': DateTime.now().toIso8601String(),
        },
        {
          'email': 'guru1@sekolah.sch.id',
          'name': 'Ahmad Khanif',
          'role': 'teacher',
          'phone': '081234567891',
          'isActive': true,
          'attendanceCategory': 'teaching',
          'createdAt': DateTime.now().toIso8601String(),
          'updatedAt': DateTime.now().toIso8601String(),
        },
        {
          'email': 'guru2@sekolah.sch.id',
          'name': 'Siti Nurhaliza',
          'role': 'teacher',
          'phone': '081234567892',
          'isActive': true,
          'attendanceCategory': 'work',
          'createdAt': DateTime.now().toIso8601String(),
          'updatedAt': DateTime.now().toIso8601String(),
        },
      ],
    };
  }

  static Map<String, dynamic> getSampleSchedules() {
    return {
      'documents': [
        {
          'teacherId': 'guru1@sekolah.sch.id',
          'title': 'Matematika Kelas VII',
          'dayOfWeek': 1, // Senin
          'startTime': '07:00',
          'endTime': '08:30',
          'location': 'Ruang 201',
          'latitude': -6.2088,
          'longitude': 106.8456,
          'radius': 500,
          'isActive': true,
          'createdAt': DateTime.now().toIso8601String(),
          'updatedAt': DateTime.now().toIso8601String(),
        },
        {
          'teacherId': 'guru1@sekolah.sch.id',
          'title': 'Matematika Kelas VIII',
          'dayOfWeek': 2, // Selasa
          'startTime': '08:30',
          'endTime': '10:00',
          'location': 'Ruang 201',
          'latitude': -6.2088,
          'longitude': 106.8456,
          'radius': 500,
          'isActive': true,
          'createdAt': DateTime.now().toIso8601String(),
          'updatedAt': DateTime.now().toIso8601String(),
        },
        {
          'teacherId': 'guru2@sekolah.sch.id',
          'title': 'Shift Pagi',
          'dayOfWeek': 1, // Senin
          'startTime': '07:30',
          'endTime': '15:00',
          'location': 'Kantor Guru',
          'latitude': -6.2088,
          'longitude': 106.8456,
          'radius': 500,
          'isActive': true,
          'createdAt': DateTime.now().toIso8601String(),
          'updatedAt': DateTime.now().toIso8601String(),
        },
      ],
    };
  }
}