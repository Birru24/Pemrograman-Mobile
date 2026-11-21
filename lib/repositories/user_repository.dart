import '../config/app_config.dart';
import '../models/user.dart';

/// Kontrak akses data pengguna.
///
/// UI hanya bergantung pada abstraksi ini, bukan pada [ApiService].
/// Implementasinya ada di [UserRepositoryImpl].
abstract class UserRepository {
  /// Mengambil daftar semua pengguna.
  ///
  /// Melempar [ApiException] jika gagal.
  Future<List<User>> getUsers({Duration timeout = AppConfig.timeout});

  /// Mengambil pengguna berdasarkan [id]. [id] harus bilangan positif.
  Future<User> getUserById(int id);
}
