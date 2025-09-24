
class ProdSeeds {
  static Map<String, dynamic> getSettings() {
    return {
      'documents': [
        {
          'key': 'tolerance_late_arrival',
          'value': '15',
          'description': 'Toleransi keterlambatan dalam menit',
          'type': 'integer',
          'updatedAt': DateTime.now().toIso8601String(),
        },
        {
          'key': 'tolerance_early_departure',
          'value': '15',
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
          'value': 'Sekolah Produksi',
          'description': 'Nama sekolah',
          'type': 'string',
          'updatedAt': DateTime.now().toIso8601String(),
        },
      ],
    };
  }

  static Map<String, dynamic> getAdminAccount() {
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
      ],
    };
  }
}