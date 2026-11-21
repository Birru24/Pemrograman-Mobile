import '../models/post.dart';

/// Kontrak akses data post. Implementasinya ada di [PostRepositoryImpl].
abstract class PostRepository {
  /// Mengambil daftar semua post.
  ///
  /// Melempar [ApiException] jika gagal.
  Future<List<Post>> getPosts();
}
