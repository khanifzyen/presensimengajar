# Aplikasi Presensi Guru

Solusi digital berbasis Flutter untuk mengelola kehadiran guru dengan validasi lokasi, pengambilan foto, dan dua mode presensi: **Pengajaran** (multi-sesi per hari) dan **Kehadiran Kerja** (sekali check-in/out per hari).

## 🏗️ Arsitektur

- **Frontend**: Flutter dengan Feature-First Clean Architecture
- **State Management**: Riverpod Generator
- **Backend**: Appwrite (Serverless)
- **Database**: Appwrite Collections
- **Server Setup**: Pure Dart CLI Tool dengan Migration System

## 📁 Struktur Project

```
presensimengajar/
├── lib/                          # Flutter mobile app
│   ├── features/                 # Feature-first modules
│   │   ├── auth/                 # Authentication
│   │   ├── attendance/          # Core presensi
│   │   └── admin/                # Admin features
│   └── core/                     # Shared logic
├── bin/                          # Server setup tool
│   ├── server_setup.dart         # CLI entry point
│   ├── migrations/               # Database migrations
│   └── seeds/                    # Sample data
├── docs/                         # Documentation
│   ├── PRD.md                   # Product requirements
│   └── TIMELINE.md              # Project timeline
└── pubspec.yaml                  # Flutter dependencies
```

## 🚀 Quick Start

### Prerequisites
- Flutter SDK (3.16+)
- Dart SDK
- Appwrite account
- Google Maps API key

### 1. Clone Repository
```bash
git clone https://github.com/khanifzyen/presensimengajar.git
cd presensimengajar
```

### 2. Setup Server
```bash
# Install server dependencies
dart pub get

# Copy environment template
cp .env.example .env

# Edit .env dengan Appwrite credentials Anda
nano .env

# Jalankan server setup
dart bin/server_setup.dart init
dart bin/server_setup.dart migrate up
dart bin/server_setup.dart seed dev
```

### 3. Setup Mobile App
```bash
# Install Flutter dependencies
flutter pub get

# Generate code
flutter pub run build_runner build

# Run app
flutter run
```

## 🔧 Development

### Server Setup Tool
CLI tool untuk manajemen Appwrite collections:

```bash
# Setup awal database
dart bin/server_setup.dart init

# Run migrations
dart bin/server_setup.dart migrate up
dart bin/server_setup.dart migrate down

# Seed data
dart bin/server_setup.dart seed dev
dart bin/server_setup.dart seed prod

# Validate schema
dart bin/server_setup.dart validate

# Environment spesifik
dart bin/server_setup.dart --env staging migrate up
```

### Environment Variables
Buat file `.env` di root project:
```bash
# Appwrite Configuration
APPWRITE_ENDPOINT=https://cloud.appwrite.io/v1
APPWRITE_PROJECT_ID=your_project_id
APPWRITE_API_KEY=your_api_key
APPWRITE_DATABASE_ID=your_database_id

# Environment
ENVIRONMENT=dev

# Google Maps
GOOGLE_MAPS_API_KEY=your_maps_api_key
```

### Feature-First Architecture
Setiap fitur memiliki struktur tersendiri:
```
features/attendance/
├── data/          # Data sources & repositories
├── domain/        # Business logic & entities
└── presentation/  # UI, providers, routes
```

## 📱 Fitur Utama

### Guru
- ✅ Login dengan email/password
- ✅ Check-in/out dengan validasi lokasi
- ✅ Pengambilan foto sebagai bukti
- ✅ Dua mode presensi: Pengajaran & Kehadiran Kerja
- ✅ Riwayat presensi dengan filter
- ✅ Profil management

### Admin
- ✅ Dashboard analytics
- ✅ Manajemen guru
- ✅ Setup jadwal & radius
- ✅ Konfigurasi toleransi waktu
- ✅ Manajemen izin/cuti
- ✅ Presensi manual
- ✅ Export laporan (PDF/Excel)

## 🛠️ Teknologi

### Mobile App
- **Flutter**: Cross-platform UI framework
- **Riverpod**: State management
- **Go Router**: Navigation
- **Appwrite**: Backend & database
- **Google Maps**: Location visualization
- **Geolocator**: Location services
- **Sealed Classes**: Error handling

### Server Setup
- **Pure Dart**: CLI tool independence
- **Appwrite SDK**: Server integration
- **Dotenv**: Environment management
- **Migration System**: Version control

## 📖 Dokumentasi

- [Product Requirements (PRD)](docs/PRD.md)
- [Project Timeline (TIMELINE)](docs/TIMELINE.md)

## 🤝 Contributing

1. Fork repository
2. Buat feature branch (`git checkout -b feature/amazing-feature`)
3. Commit changes (`git commit -m 'Add amazing feature'`)
4. Push ke branch (`git push origin feature/amazing-feature`)
5. Buka Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- [Flutter](https://flutter.dev/) for the amazing framework
- [Appwrite](https://appwrite.io/) for the backend solution
- [Riverpod](https://riverpod.dev/) for state management

---

**Dikembangkan oleh:** Akhmad Khanif Zyen
**Versi:** 1.0.0
**Terakhir diupdate:** 24 September 2025
