**TIMELINE PEKERJAAN: APLIKASI PRESENSI GURU**
*Dibuat berdasarkan PRD*
*Tanggal: 24 September 2025*
*Versi: 1.0*

---

## **FASE 1: SETUP PROYEK & ARSITEKTUR (Minggu 1-2)**

### **1.1 Inisialisasi Proyek Flutter**
- **Task**: Setup Flutter project dengan struktur folder Feature-First Clean Architecture
- **Output**: Struktur folder lengkap dengan features/, core/, dan clean architecture layers
- **Estimasi**: 2 hari

### **1.2 Konfigurasi Dependencies**
- **Task**: Install dan konfigurasi semua dependencies menggunakan flutter pub add
- **Output**: pubspec.yaml dengan semua dependencies yang dibutuhkan
- **Estimasi**: 1 hari

### **1.3 Setup Backend & Database**
- **Task**: Inisialisasi proyek backend NestJS, koneksikan ke database Neon, dan siapkan akun Cloudinary.
- **Output**: Proyek backend API siap untuk pengembangan, terkoneksi dengan database, dan siap untuk upload file.
- **Estimasi**: 3 hari

---

## **FASE 2: AUTENTIKASI & MANAJEMEN PENGGUNA (Minggu 3-4)**

### **2.1 Implementasi Authentication System**
- **Task**: Login/Logout untuk Guru dan Admin
- **Output**: Sistem auth dengan session management
- **Estimasi**: 3 hari

### **2.2 User Management Screens**
- **Task**: Halaman login, register, dan profil
- **Output**: UI lengkap untuk autentikasi dan profil
- **Estimasi**: 2 hari

### **2.3 Admin User Management**
- **Task**: Dashboard admin untuk manajemen pengguna
- **Output**: CRUD guru dan admin management
- **Estimasi**: 3 hari

---

## **FASE 3: CORE PRESENSI FEATURES (Minggu 5-8)**

### **3.1 Location Services**
- **Task**: Implementasi geolocator dan deteksi mock location
- **Output**: Service untuk validasi lokasi dengan radius
- **Estimasi**: 3 hari

### **3.2 Camera Integration**
- **Task**: Implementasi pengambilan foto untuk presensi
- **Output**: Camera service dengan storage ke Cloudinary
- **Estimasi**: 2 hari

### **3.3 Attendance Logic**
- **Task**: Business logic untuk dua mode presensi
- **Output**: Service untuk hitung status presensi (hadir/terlambat)
- **Estimasi**: 3 hari

### **3.4 Presensi Screens**
- **Task**: UI untuk check-in/out dengan peta dan kamera
- **Output**: Halaman presensi lengkap dengan validasi
- **Estimasi**: 4 hari

---

## **FASE 4: SCHEDULE MANAGEMENT (Minggu 9-10)**

### **4.1 Schedule System**
- **Task**: Implementasi manajemen jadwal dinamis
- **Output**: Schedule service dengan shift berbeda per hari
- **Estimasi**: 3 hari

### **4.2 Admin Schedule Management**
- **Task**: Dashboard admin untuk atur jadwal dan radius
- **Output**: CRUD jadwal dengan visualisasi peta
- **Estimasi**: 3 hari

### **4.3 Tolerance Settings**
- **Task**: Sistem pengaturan toleransi waktu
- **Output**: Settings page untuk admin konfigurasi toleransi
- **Estimasi**: 2 hari

---

## **FASE 5: MONITORING & LAPORAN (Minggu 11-12)**

### **5.1 Attendance History**
- **Task**: Halaman riwayat presensi untuk guru
- **Output**: History screen dengan filter dan status
- **Estimasi**: 3 hari

### **5.2 Admin Dashboard**
- **Task**: Dashboard admin dengan grafik kehadiran
- **Output**: Analytics dengan Chart.js
- **Estimasi**: 3 hari

### **5.3 Report Generation**
- **Task**: Export data ke PDF/Excel
- **Output**: Report service dengan file generation
- **Estimasi**: 2 hari

### **5.4 Exception Handling**
- **Task**: Sistem izin/cuti dan presensi manual
- **Output**: Management system untuk exceptions
- **Estimasi**: 3 hari

---

## **FASE 6: TESTING & OPTIMIZATION (Minggu 13-14)**

### **6.1 Unit Testing**
- **Task**: Test untuk business logic (use cases) dan services
- **Output**: Test coverage minimal 80% untuk domain layer
- **Estimasi**: 3 hari

### **6.2 Integration Testing**
- **Task**: Test untuk integrasi dengan Appwrite dan feature modules
- **Output**: End-to-end testing scenarios per feature
- **Estimasi**: 2 hari

### **6.3 Performance Optimization**
- **Task**: Optimasi loading time dan memory usage
- **Output**: Aplikasi responsif dengan <3s loading
- **Estimasi**: 2 hari

### **6.4 Final Testing & Bug Fixing**
- **Task**: Comprehensive testing semua fitur
- **Output**: Aplikasi production-ready
- **Estimasi**: 3 hari

---

## **DEPENDENCIES CRITICAL PATH**

### **Installation Commands**
```bash
# Core Flutter Dependencies
flutter pub add flutter_bloc
flutter pub add dio
flutter pub add go_router
flutter pub add flutter_dotenv
flutter pub add freezed_annotation
flutter pub add geolocator
flutter pub add google_maps_flutter
flutter pub add intl
flutter pub add image_picker
flutter pub add permission_handler
flutter pub add flutter_secure_storage
flutter pub add logger

# Development Dependencies
flutter pub add --dev build_runner
flutter pub add --dev freezed
flutter pub add --dev json_serializable
flutter pub add --dev mocktail
flutter pub add --dev bloc_test
flutter pub add --dev very_good_analysis
```

### **Key Technologies**
- **State Management**: BLoC / flutter_bloc
- **Backend**: NestJS on Render.com
- **ORM**: Prisma
- **Database**: Neon (Postgres)
- **Storage**: Cloudinary
- **Architecture**: Feature-First Clean Architecture (Flutter) + Modular REST API (NestJS)
- **Error Handling**: Sealed Class for BLoC states
- **Location**: Geolocator + Google Maps Flutter

---

## **MILESTONES**

### **Milestone 1 (Minggu 2)**: Base App Ready
- Setup project dengan Feature-First Clean Architecture selesai
- Dependencies terinstall dan konfigurasi
- Koneksi ke database Neon dan setup backend awal selesai
- Autentikasi basic working

### **Milestone 2 (Minggu 4)**: User Management Complete
- Sistem auth lengkap
- Profil guru siap
- Admin dashboard basic

### **Milestone 3 (Minggu 8)**: Core Attendance Working
- Presensi dengan validasi lokasi
- Camera integration
- Attendance logic siap

### **Milestone 4 (Minggu 10)**: Schedule Management Ready
- Jadwal dinamis implementasi
- Radius dan tolerance settings
- Admin schedule management

### **Milestone 5 (Minggu 12)**: Reporting Complete
- History dan analytics siap
- Export functionality
- Exception handling

### **Milestone 6 (Minggu 14)**: Production Ready
- Testing selesai (unit, integration, E2E)
- Performance optimized
- Clean Architecture implementation verified
- Documentation complete

---

## **RESOURCE REQUIREMENTS**

### **Development Team**
- 1 Flutter Developer (Full-time)
- 1 Backend Developer (Part-time, untuk setup awal dan maintenance)
- 1 UI/UX Designer (Part-time)

### **Infrastructure**
- Render account
- Neon account
- Cloudinary account
- Google Maps API key
- Test devices (Android/iOS)

---

**Total Estimasi Waktu: 14 Minggu**
**Status Dokumen: Draft**
**Update Terakhir: 24 September 2025**