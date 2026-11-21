import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../config/app_config.dart';
import '../models/post.dart';
import '../models/user.dart';
import 'app_logger.dart';

/// Exception dengan pesan yang aman ditampilkan ke pengguna.
///
/// Pesan tidak berisi stack trace, URL lengkap, atau detail internal.
class ApiException implements Exception {
  /// Pesan error untuk pengguna.
  final String message;

  ApiException(this.message);

  @override
  String toString() => message;
}

/// Service untuk komunikasi HTTP dengan REST API.
///
/// Base URL dan API key dibaca dari [AppConfig] (file `.env`).
/// [client] dan [baseUrl] bisa diisi dari luar agar mudah diuji.
class ApiService {
  /// Timeout bawaan untuk setiap request.
  static const Duration defaultTimeout = AppConfig.timeout;

  final http.Client _client;
  final String _baseUrl;

  ApiService({http.Client? client, String? baseUrl})
      : _client = client ?? http.Client(),
        _baseUrl = baseUrl ?? AppConfig.baseUrl;

  /// Header request. API key berasal dari `.env`, tidak di-hardcode.
  Map<String, String> _buildHeaders() => {
        'Accept': 'application/json',
        if (AppConfig.apiKey.isNotEmpty) 'X-API-Key': AppConfig.apiKey,
      };

  /// GET ke [path] lalu decode JSON, dengan penanganan error terpusat.
  ///
  /// Melempar [ApiException] untuk semua jenis kegagalan.
  Future<dynamic> _getJson(String path, Duration timeout) async {
    try {
      // Logging aman: hanya method dan path, tanpa header/API key
      AppLogger.debug('Request GET $path');
      final response = await _client
          .get(Uri.parse('$_baseUrl$path'), headers: _buildHeaders())
          .timeout(timeout);
      AppLogger.debug('Response status: ${response.statusCode}');

      if (response.statusCode == 200) return jsonDecode(response.body);
      throw ApiException('Gagal memuat data. Status: ${response.statusCode}');
    } on ApiException {
      rethrow;
    } on TimeoutException {
      AppLogger.warning('Timeout pada $path');
      throw ApiException(
        'Request timeout (${timeout.inSeconds} detik). Periksa koneksi internet Anda.',
      );
    } on SocketException {
      throw ApiException('Tidak ada koneksi internet. Periksa jaringan Anda.');
    } on http.ClientException {
      throw ApiException('Tidak dapat terhubung ke server.');
    } on FormatException {
      throw ApiException('Format data tidak valid.');
    } catch (e) {
      AppLogger.error('Error tak terduga: ${e.runtimeType}');
      throw ApiException('Terjadi kesalahan yang tidak terduga.');
    }
  }

  /// Mengambil semua pengguna (`GET /users`).
  Future<List<User>> getUsers({Duration timeout = defaultTimeout}) async {
    final data = await _getJson('/users', timeout) as List<dynamic>;
    return data
        .map((json) => User.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  /// Mengambil satu pengguna berdasarkan [id] (`GET /users/{id}`).
  Future<User> getUserById(int id, {Duration timeout = defaultTimeout}) async {
    final data = await _getJson('/users/$id', timeout) as Map<String, dynamic>;
    return User.fromJson(data);
  }

  /// Mengambil semua post (`GET /posts`).
  Future<List<Post>> getPosts({Duration timeout = defaultTimeout}) async {
    final data = await _getJson('/posts', timeout) as List<dynamic>;
    return data
        .map((json) => Post.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  /// Simulasi login. Mengembalikan token dummy jika input tidak kosong.
  ///
  /// Di aplikasi nyata token berasal dari server.
  Future<String> login(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1));

    if (email.trim().isEmpty || password.isEmpty) {
      throw ApiException('Email dan password tidak boleh kosong');
    }

    final token = 'dummy_token_${DateTime.now().millisecondsSinceEpoch}';
    // Tidak mencetak token maupun email
    AppLogger.info('Login berhasil');
    return token;
  }

  /// Menutup koneksi HTTP.
  void dispose() => _client.close();
}
