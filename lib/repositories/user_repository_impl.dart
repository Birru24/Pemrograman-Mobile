import '../config/app_config.dart';
import '../models/user.dart';
import '../services/api_service.dart';
import 'user_repository.dart';

/// Implementasi [UserRepository] yang mengambil data lewat [ApiService].
class UserRepositoryImpl implements UserRepository {
  final ApiService _apiService;

  UserRepositoryImpl({ApiService? apiService})
      : _apiService = apiService ?? ApiService();

  @override
  Future<List<User>> getUsers({Duration timeout = AppConfig.timeout}) {
    return _apiService.getUsers(timeout: timeout);
  }

  @override
  Future<User> getUserById(int id) {
    if (id <= 0) throw ApiException('ID pengguna tidak valid');
    return _apiService.getUserById(id);
  }
}
