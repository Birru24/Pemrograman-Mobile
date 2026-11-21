# secure_http (Praktikum 5 dan 6)

Aplikasi Flutter untuk mata kuliah Pemrograman Mobile (ST407). Praktikum 5 membuat fitur secure storage dan HTTP request ke JSONPlaceholder. Praktikum 6 merapikan kode itu ke pola Repository, memindahkan base URL dan API key ke file `.env`, menambah validasi input, dan menulis dokumentasi dartdoc.

## Menjalankan

```bash
cp .env.example .env   # lalu isi BASE_URL dan API_KEY
flutter pub get
flutter run
flutter test
```

File `.env` tidak ikut masuk Git (lihat `.gitignore`). Tanpa file itu build akan gagal karena `.env` terdaftar sebagai asset di `pubspec.yaml`.

## Struktur

```
lib/
├── main.dart                        memuat .env, memasang DependencyProvider
├── config/
│   ├── app_config.dart              BASE_URL, API_KEY, timeout dari .env
│   └── dependency_injector.dart     singleton ApiService + repository (Latihan 2)
├── models/                          user.dart, post.dart
├── repositories/
│   ├── user_repository.dart         abstraksi
│   ├── user_repository_impl.dart
│   ├── post_repository.dart         abstraksi (Latihan 1)
│   └── post_repository_impl.dart
├── services/
│   ├── api_service.dart             HTTP + ApiException
│   ├── app_logger.dart              log debug/info/warning/error (Latihan 4)
│   └── secure_storage_service.dart
├── utils/validators.dart            validasi dan sanitasi (Latihan 3)
├── screens/                         login, home, user_list, post_list
└── widgets/user_card.dart
test/utils/validators_test.dart      unit test Validators (Latihan 5)
```

## Penerapan prinsip SOLID

Setiap class punya satu tugas: `ApiService` hanya mengurus HTTP, repository menjadi perantara data, dan screen hanya menampilkan UI (SRP). Screen bergantung pada `UserRepository` dan `PostRepository` yang abstrak, bukan pada `ApiService` (DIP). Sumber data baru, misalnya cache lokal, cukup dibuat sebagai implementasi baru tanpa mengubah screen (OCP). Repository pengguna dan post dipisah supaya interface tetap kecil (ISP). Semua implementasi bisa menggantikan abstraksinya, termasuk mock saat test, karena screen menerima parameter `repository` opsional (LSP).

## Git

```bash
git checkout -b fitur-rpl-keamanan
git add .
git commit -m "Refactoring ke Repository pattern, .env, dan validasi input"
```
