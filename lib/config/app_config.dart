import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Konfigurasi aplikasi yang dibaca dari file `.env`.
///
/// Semua nilai sensitif (base URL, API key) diambil dari sini,
/// jadi tidak ada credential yang ditulis langsung di kode sumber.
class AppConfig {
  AppConfig._();

  /// Base URL REST API, dari variabel `BASE_URL`.
  static String get baseUrl => _read('BASE_URL');

  /// API key untuk header request, dari variabel `API_KEY`.
  static String get apiKey => _read('API_KEY');

  /// Batas waktu request HTTP dalam detik.
  static const int timeoutSeconds = 10;

  /// [timeoutSeconds] dalam bentuk [Duration].
  static const Duration timeout = Duration(seconds: timeoutSeconds);

  /// `true` jika `BASE_URL` dan `API_KEY` sudah terisi.
  static bool isConfigured() => baseUrl.isNotEmpty && apiKey.isNotEmpty;

  // dotenv.env melempar error kalau .env belum dimuat (misalnya saat unit test).
  static String _read(String key) =>
      dotenv.isInitialized ? (dotenv.env[key] ?? '') : '';
}
