import '../core/api/api_service.dart';
import '../models/user.dart';

class UserRepository {
  Future<User> register(String name, String phone, String password) async {
    final data = await ApiService.register(name, phone, password);
    return User.fromJson(data!);
  }

  Future<User> login(String phone, String password) async {
    final data = await ApiService.login(phone, password);
    return User.fromJson(data);
  }
}
