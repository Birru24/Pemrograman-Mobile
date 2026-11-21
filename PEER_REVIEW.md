# Catatan peer review keamanan (Praktikum 6)

Reviewer: review mandiri (Quhadja Afafa Birru Auliya)  Tanggal: 21 November 2026

Review dilakukan secara mandiri dengan memeriksa kode sendiri memakai enam aspek dari modul.

| No | Aspek | Hasil cek mandiri | Catatan reviewer |
|----|-------|-------------------|------------------|
| 1 | Hardcoded credential | Base URL dan API key dipindah ke `.env` dan dibaca lewat `AppConfig`. `.env` masuk `.gitignore`, yang di-commit hanya `.env.example`. | Aman. .env tetap ikut masuk APK, jadi key asli sebaiknya di server. |
| 2 | Validasi input | Login memakai `Validators.validateEmail` dan `validatePassword` (min. 8 karakter, huruf kapital, angka, simbol). Input token dibatasi 1 sampai 200 karakter. Kolom cari dibatasi 50 karakter. `getUserById` menolak id ≤ 0. | Aman. Validasi server tetap diperlukan. |
| 3 | Sanitasi output | Token disanitasi dengan `Validators.sanitize` sebelum disimpan. Token yang tampil di layar disamarkan (`abc123••••••`). | Aman. |
| 4 | Error handling | Semua error HTTP diubah menjadi `ApiException` dengan pesan ramah pengguna. Stack trace, URL lengkap, dan isi response tidak ditampilkan. | Aman. |
| 5 | Logging | Log hanya muncul di mode debug (`kDebugMode`). Yang dicatat hanya path, status code, dan jenis error. Token, password, email, dan API key tidak pernah dicetak. | Aman. |
| 6 | Dependency | `http ^1.1.0`, `flutter_secure_storage ^9.0.0`, `flutter_dotenv ^5.1.0`. Jalankan `flutter pub outdated` untuk cek versi terbaru. | Ada 20 package dengan versi lebih baru, perlu dicek dengan `flutter pub outdated`. |

## Kekurangan yang masih ada

File `.env` dibundel sebagai asset, sehingga isinya tetap bisa dibaca dari APK yang dibongkar. `.env` mencegah credential bocor ke GitHub, tetapi tidak melindunginya dari orang yang memegang APK. Untuk API key sungguhan, key sebaiknya disimpan di server (backend proxy) dan aplikasi hanya memegang token sesi pengguna.

Login masih simulasi dan token dibuat di aplikasi. Validasi sisi klien juga tetap harus diulang di server, karena request bisa dikirim tanpa melewati aplikasi.

## Tindak lanjut

1. Pindahkan API key asli ke server (backend proxy) bila nanti memakai API berbayar.
2. Cek versi package dengan `flutter pub outdated` dan perbarui yang aman.
