✦ Tentu. Anda bisa mengetes fungsionalitas yang baru saja saya selesaikan dengan mengikuti langkah-langkah berikut.

  Proses ini membutuhkan data jadwal di database. Karena UI untuk membuat jadwal ada di Fase 4, pastikan Anda sudah memiliki setidaknya satu `Schedule` di database Anda yang `startTime`-nya adalah untuk hari ini 
  dan `assignedToId`-nya adalah ID user yang akan Anda gunakan untuk login.

  Langkah 1: Jalankan Backend

   1. Buka terminal baru.
   2. Masuk ke direktori backend: cd backend
   3. Install dependensi jika belum: npm install
   4. Jalankan server: npm run start:dev
      Server akan berjalan di http://localhost:3000.

  Langkah 2: Jalankan Aplikasi Frontend

   1. Buka terminal baru.
   2. Masuk ke direktori frontend: cd frontend
   3. Install dependensi jika belum: flutter pub get
   4. Jalankan aplikasi di emulator atau perangkat fisik: flutter run

  Langkah 3: Skenario Pengujian

  Skenario A: Alur Check-in & Check-out Normal

   1. Login: Buka aplikasi dan login dengan akun user yang sudah Anda siapkan jadwalnya.
   2. Halaman Presensi: Anda akan otomatis diarahkan ke halaman presensi.
   3. Verifikasi Tampilan Check-in:
       * Peta: Di bagian atas, Anda akan melihat peta yang terpusat di lokasi jadwal, dengan lingkaran biru menunjukkan radius presensi.
       * Kamera: Di bawah peta, Anda akan melihat pratinjau kamera depan secara live.
       * Tombol: Di bagian bawah, ada tombol hijau "Check In Sekarang".
   4. Lakukan Check-in: Tekan tombol "Check In Sekarang".
       * Hasil yang Diharapkan: Proses berjalan, UI refresh, dan sekarang Anda melihat tampilan check-out. Muncul notifikasi hijau "Check-in successful!".
   5. Verifikasi Tampilan Check-out:
       * Kamera: UI sekarang hanya menampilkan pratinjau kamera live.
       * Tombol: Di bagian bawah, ada tombol merah "Check Out Sekarang".
   6. Lakukan Check-out: Tekan tombol "Check Out Sekarang".
       * Hasil yang Diharapkan: Proses berjalan, UI refresh kembali ke tampilan check-in awal (peta + kamera). Muncul notifikasi hijau "Check-out successful!".

  Skenario B: Uji Validasi (Gagal Presensi)

   1. Uji Validasi Lokasi:
       * Di emulator, gunakan fitur "Set location" untuk memindahkan lokasi Anda ke luar lingkaran biru di peta.
       * Tekan tombol "Check In Sekarang".
       * Hasil yang Diharapkan: Muncul notifikasi merah berisi pesan error, contoh: Error: You are 1234 meters away. Please move within the 500m radius to check in.
   2. Uji Status `TERLAMBAT`:
       * Ubah data startTime di database untuk jadwal hari ini menjadi waktu yang sudah lewat (misal, 2 jam yang lalu).
       * Lakukan check-in seperti biasa.
       * Hasil yang Diharapkan: Check-in berhasil, tapi jika Anda periksa di tabel AttendanceRecord database, status untuk data tersebut akan menjadi TERLAMBAT.
   3. Uji Status `PULANG_CEPAT`:
       * Pastikan endTime jadwal Anda adalah waktu di masa depan (misal, 2 jam dari sekarang).
       * Lakukan check-in, lalu langsung lakukan check-out.
       * Hasil yang Diharapkan: Check-out berhasil, tapi jika Anda periksa di tabel AttendanceRecord database, statusnya akan diperbarui menjadi PULANG_CEPAT.

  Dengan mengikuti skenario ini, Anda dapat memverifikasi semua logika dan alur UI yang telah saya implementasikan untuk Fase 3.
