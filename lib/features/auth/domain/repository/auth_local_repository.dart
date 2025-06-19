import '../entity/user_entity.dart';

abstract class AuthLocalRepository {
  Future<void> register(UserEntity user);
  Future<UserEntity?> login(String email, String password);
}
