# 🌴 RINGKASAN PROYEK NYAWIT: PALM OIL AI DETECTION

Berkas ini berisi rangkuman fitur, arsitektur, teknologi, dan semua modul yang telah diimplementasikan dalam pengembangan sistem cerdas **Nyawit** (Aplikasi Pemantauan & Deteksi Tandan Buah Segar Kelapa Sawit).

---

## 🚀 Fitur Utama yang Telah Diimplementasikan

### 1. Sistem Autentikasi & Keamanan (Auth & Security)
*   **Registrasi & Login Akun**: Pendaftaran user baru dengan verifikasi input Zod di sisi backend dan penyimpanan kata sandi terenkripsi menggunakan `bcrypt`.
*   **JWT Token Session**: Mengamankan endpoint API dengan middleware autentikasi berbasis JWT (JSON Web Tokens).
*   **Auto Login (Flutter)**: Menyimpan JWT secara aman di HP menggunakan `shared_preferences` untuk autentikasi otomatis saat aplikasi dibuka kembali.
*   **Logout Sesi**: Membersihkan token sesi secara aman dari HP fisik dan mengalihkan pengguna kembali ke halaman Login.

### 2. Personalisasi Akun Premium (Forest Green Aesthetic)
*   **Tab Navigasi Akun**: Tab ke-4 baru yang terintegrasi secara minimalis dan bersih di navigasi utama `MainPage`.
*   **Ubah Data Diri**: Pembaruan Nama Lengkap dan Nama Panggilan kustom bergaya `@username` sosial media.
*   **Preset Avatar Premium**: Pilihan gambar profil bawaan bertema alam kelapa sawit (*Daun*, *Kecambah*, *Kelapa Sawit*, *Petani*).
*   **Ubah Sandi Keamanan**: Bottom sheet kustom untuk memperbarui password akun dengan validasi berlapis (minimal 6 karakter & konfirmasi kecocokan).

### 3. Sistem Deteksi AI Berbasis Gambar (Image AI Detection)
*   **Deteksi Gambar**: Pengambilan gambar dari Kamera atau Galeri ponsel yang diproses oleh AI untuk menghitung jumlah tandan kelapa sawit.
*   **Simpan Riwayat Deteksi**: Pencatatan data deteksi AI mencakup total hitungan, label dominan, detail koordinat bounding box, dan timestamp presisi ke MySQL.
*   **Hapus Riwayat**: Kemudahan menghapus catatan deteksi lama secara permanen langsung dari UI riwayat.

### 4. Deteksi Real-Time Kamera Live (Live Camera Detection) — *⭐ Fitur Performa Tinggi*
*   **Live Frame Stream**: Menangkap aliran bingkai (frame) video langsung dari kamera ponsel menggunakan `camera` package secara real-time.
*   **Detektor Tandan Buah Segar**: Memanfaatkan `PalmDetector` untuk menganalisis setiap frame gambar `CameraImage` yang masuk secara asinkron tanpa memblokir thread UI utama.
*   **Bounding Box Canvas Overlay**: Menggambar kotak koordinat deteksi (`x1`, `y1`, `x2`, `y2`) secara dinamis tepat di atas preview kamera menggunakan `CustomPaint` dengan `DetectionBoxPainter`.
*   **Kategori Kematangan Sawit**: Melacak dan menghitung kategori buah sawit dalam waktu nyata, yaitu:
    *   *Janjang kosong*
    *   *Kurang masak*
    *   *TBS abnormal*
    *   *TBS masak*
    *   *TBS mentah*
    *   *Terlalu masak*

### 5. Penyimpanan Gambar Hybrid (Hybrid Image Storage) — *⭐ Fitur Unggulan*
*   **Zero-Overhead JSON Upload**: Ponsel mengirim gambar kustom (foto profil / foto hasil deteksi) sebagai string Base64 dalam payload JSON standar.
*   **Auto Filesystem Writer**: Backend secara otomatis mendekode Base64 menjadi berkas gambar fisik `.jpg`, lalu menyimpannya di folder komputer lokal Anda (`nyawit-api/uploads/`).
*   **MySQL Path Pointer**: Database MySQL phpMyAdmin Anda tetap **sangat ringan dan cepat** karena hanya mencatat teks alamat relatifnya saja (contoh: `/uploads/profile_1716301293.jpg`).
*   **Visual History Preview**: Panel riwayat di ponsel kini otomatis menampilkan **Preview Gambar Sawit Asli** secara visual sebagai thumbnail di sisi kiri, memberikan pengalaman pengguna yang sangat premium!

---

## 🛠️ Arsitektur & Teknologi Stack

Proyek ini dibangun menggunakan arsitektur **Full-Stack Hybrid** yang memisahkan sisi Client (Mobile) dan API Server (Backend) secara modular.

| Layer | Teknologi | Library / Package Utama | Kegunaan |
| :--- | :--- | :--- | :--- |
| **Frontend (Mobile)** | **Flutter (Dart)** | `camera`, `http`, `shared_preferences`, `intl`, `image_picker` | UI Mobile bertema Forest Green premium, pengambilan kamera live real-time stream, request API, dan penyimpanan sesi lokal. |
| **Backend (API)** | **Node.js (TypeScript)** | `express`, `cors`, `dotenv`, `tsx` | Penyedia RESTful API berkinerja tinggi, penanganan static static asset, dan bisnis logika. |
| **Database & ORM** | **MySQL (phpMyAdmin)** & **Prisma** | `@prisma/client`, `prisma-client-js` | Penyimpanan data terstruktur (tabel `user` & `detection`) serta manipulasi database type-safe. |
| **Validasi & Keamanan**| **Zod** & **Cryptographic Tools**| `zod`, `bcrypt`, `jsonwebtoken` | Keamanan input schema validation, hashing password, dan otorisasi bearer JWT token. |
| **Media Storage** | **Hybrid Base64 & FS** | `fs` (Node.js File System) | Konversi biner bertenaga tinggi, penulisan file fisik lokal, dan penyajian static Express. |

---

## 📁 Struktur Berkas Utama yang Dikembangkan/Dimodifikasi

### 📱 Sisi Frontend (Flutter - `/lib`)
*   [`lib/pages/ai/live_detection_page.dart`](file:///d:/usaha/nyawit/lib/pages/ai/live_detection_page.dart) - Halaman deteksi video kamera langsung dengan performa tinggi dan rendering overlay bounding box.
*   [`lib/pages/ai/image_detection_page.dart`](file:///d:/usaha/nyawit/lib/pages/ai/image_detection_page.dart) - Halaman deteksi foto statik kamera/galeri terintegrasi konversi Base64 sebelum diunggah.
*   [`lib/pages/ai/ai_page.dart`](file:///d:/usaha/nyawit/lib/pages/ai/ai_page.dart) - Menu utama pemilih jenis analisis kecerdasan buatan (Live Camera vs Image Static).
*   [`lib/pages/profile_page.dart`](file:///d:/usaha/nyawit/lib/pages/profile_page.dart) - Halaman profil interaktif dengan tema Forest Green, preset avatar premium, dan upload Base64.
*   [`lib/pages/main_page.dart`](file:///d:/usaha/nyawit/lib/pages/main_page.dart) - BottomNavigationBar terupdate dengan tambahan Tab Akun.
*   [`lib/pages/history_page.dart`](file:///d:/usaha/nyawit/lib/pages/history_page.dart) - Tampilan Riwayat yang disempurnakan dengan preview gambar sawit online statik.
*   [`lib/services/palm_detector.dart`](file:///d:/usaha/nyawit/lib/services/palm_detector.dart) - Detektor cerdas kelapa sawit yang memproses stream byte gambar biner dari kamera/file ke format AI.
*   [`lib/utils/box_painter.dart`](file:///d:/usaha/nyawit/lib/utils/box_painter.dart) - Utility custom painter untuk menggambar frame visual bounding box di canvas layar secara real-time.
*   [`lib/services/api_client.dart`](file:///d:/usaha/nyawit/lib/services/api_client.dart) - Client jaringan dengan log request HTTP PUT baru yang terperinci.
*   [`lib/services/auth_service.dart`](file:///d:/usaha/nyawit/lib/services/auth_service.dart) - Service pemicu API ubah profil dan verifikasi akun ke backend.

### 💻 Sisi Backend (Node.js - `/nyawit-api`)
*   [`nyawit-api/prisma/schema.prisma`](file:///d:/usaha/nyawit/nyawit-api/prisma/schema.prisma) - Skema database terupdate dengan kolom `nickname` dan `photoProfile`.
*   [`nyawit-api/src/index.ts`](file:///d:/usaha/nyawit/nyawit-api/src/index.ts) - Konfigurasi static assets `/uploads` dan optimasi limit payload Express sebesar **50mb**.
*   [`nyawit-api/src/utils/file.ts`](file:///d:/usaha/nyawit/nyawit-api/src/utils/file.ts) - Util penanganan decode base64 dan otomatisasi pembuatan folder fisik lokal.
*   [`nyawit-api/src/validators/auth.validator.ts`](file:///d:/usaha/nyawit/nyawit-api/src/validators/auth.validator.ts) - Schema Zod validator untuk verifikasi input modifikasi data profil.
*   [`nyawit-api/src/controllers/auth.controller.ts`](file:///d:/usaha/nyawit/nyawit-api/src/controllers/auth.controller.ts) - Endpoint logika edit profil (nama, nama panggilan, password, dan foto kustom).
*   [`nyawit-api/src/controllers/detection.controller.ts`](file:///d:/usaha/nyawit/nyawit-api/src/controllers/detection.controller.ts) - Endpoint logika deteksi yang otomatis memicu dekoder file base64 ke folder lokal.

---

## 📈 Perkembangan Struktur Kode (Graphify watch)
Semua dependensi dan topologi berkas kode di atas telah dipetakan secara real-time ke dalam sistem grafik navigasi **Graphify** pada direktori `graphify-out/` dengan ringkasan status saat ini:
*   **Total Node Kode**: 325 berkas/kelas modular terdeteksi.
*   **Total Relasi Hubungan**: 359 garis dependensi (Client API -> Server Router -> Controller -> ORM -> DB).

---
*Nyawit - Dikembangkan dengan dedikasi tinggi untuk modernisasi industri kelapa sawit berbasis AI.*
