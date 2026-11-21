import 'package:flutter/foundation.dart';

/// Tingkat keparahan pesan log.
enum LogLevel { debug, info, warning, error }

/// Logger terstruktur yang hanya mencetak di mode debug ([kDebugMode]).
///
/// Di build release semua log dimatikan. Jangan pernah memasukkan
/// token, password, PIN, API key, atau email ke dalam pesan log.
class AppLogger {
  AppLogger._();

  /// Detail teknis untuk proses debugging.
  static void debug(String message) => _log(LogLevel.debug, message);

  /// Kejadian normal, misalnya login berhasil.
  static void info(String message) => _log(LogLevel.info, message);

  /// Kondisi tidak normal yang belum menjadi error.
  static void warning(String message) => _log(LogLevel.warning, message);

  /// Error yang perlu diperhatikan.
  static void error(String message) => _log(LogLevel.error, message);

  static void _log(LogLevel level, String message) {
    if (!kDebugMode) return;
    final time = DateTime.now().toIso8601String().substring(11, 19);
    debugPrint('[$time] [${level.name.toUpperCase()}] $message');
  }
}
