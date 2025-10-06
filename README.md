# Aplikasi Presensi Guru

Aplikasi presensi guru berbasis Flutter dengan backend NestJS untuk mengelola kehadiran guru secara digital.

## 🚀 Struktur Monorepo

Proyek ini dikelola sebagai monorepo yang terdiri dari dua bagian utama:

-   `/frontend`: Aplikasi mobile yang dibuat dengan **Flutter**.
-   `/backend`: Server API yang dibuat dengan **NestJS**.

## 🛠️ Stack Teknologi

| Komponen          | Teknologi                               |
| ----------------- | --------------------------------------- |
| **Frontend**      | Flutter (State Management: BLoC)        |
| **Backend**       | NestJS (Node.js)                        |
| **Database**      | Neon (Postgres)                         |
| **ORM**           | Prisma                                  |
| **File Storage**  | Cloudinary                              |
| **Hosting**       | Render.com                              |

## 🏁 Panduan Memulai

### Persyaratan

-   Flutter SDK
-   Node.js & NPM
-   Akun Neon & Cloudinary

### Backend

1.  **Masuk ke direktori backend:**
    ```bash
    cd backend
    ```
2.  **Install dependensi:**
    ```bash
    npm install
    ```
3.  **Setup Environment Variables:**
    Buat file `.env` baru di dalam folder `backend` dan isi `DATABASE_URL`, kredensial Cloudinary, dan `JWT_SECRET` sesuai dengan template yang ada.

4.  **Jalankan server pengembangan:**
    ```bash
    npm run start:dev
    ```
    Server akan berjalan di `http://localhost:3000`.

### Frontend

1.  **Masuk ke direktori frontend:**
    ```bash
    cd frontend
    ```
2.  **Install dependensi Flutter:**
    ```bash
    flutter pub get
    ```
3.  **Jalankan aplikasi:**
    ```bash
    flutter run
    ```

## 📝 Status Proyek

Saat ini, **Fase 2: Autentikasi & Manajemen Pengguna** telah selesai. Fondasi untuk frontend dan backend, beserta alur registrasi, login, dan manajemen pengguna oleh admin telah selesai diimplementasikan.
