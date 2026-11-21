import 'package:flutter/widgets.dart';
import '../repositories/post_repository.dart';
import '../repositories/post_repository_impl.dart';
import '../repositories/user_repository.dart';
import '../repositories/user_repository_impl.dart';
import '../services/api_service.dart';

/// Penyedia dependency aplikasi (singleton).
///
/// Satu [ApiService] dipakai bersama oleh semua repository.
/// Instance dibuat saat pertama kali diakses, setelah `.env` dimuat.
class DependencyInjector {
  DependencyInjector._();

  /// Instance tunggal.
  static final DependencyInjector instance = DependencyInjector._();

  /// Service HTTP bersama.
  late final ApiService apiService = ApiService();

  /// Repository pengguna.
  late final UserRepository userRepository =
      UserRepositoryImpl(apiService: apiService);

  /// Repository post.
  late final PostRepository postRepository =
      PostRepositoryImpl(apiService: apiService);
}

/// Menyediakan [DependencyInjector] ke seluruh widget tree.
///
/// Ambil dengan `DependencyProvider.of(context)`.
class DependencyProvider extends InheritedWidget {
  /// Dependency yang disediakan.
  final DependencyInjector injector;

  const DependencyProvider({
    super.key,
    required this.injector,
    required super.child,
  });

  /// Mengambil injector terdekat; kembali ke [DependencyInjector.instance]
  /// jika widget dipakai di luar [DependencyProvider] (misalnya di test).
  ///
  /// Aman dipanggil dari `initState` karena tidak mendaftarkan dependency.
  static DependencyInjector of(BuildContext context) =>
      context.getInheritedWidgetOfExactType<DependencyProvider>()?.injector ??
      DependencyInjector.instance;

  // Injector tidak pernah berganti, jadi tidak perlu rebuild.
  @override
  bool updateShouldNotify(DependencyProvider oldWidget) => false;
}
