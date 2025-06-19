import 'package:travvie/features/auth/domain/entity/user_entity.dart';
import 'package:travvie/features/auth/domain/repository/auth_local_repository.dart';

class LoginUser {
  final AuthLocalRepository repository;

  LoginUser(this.repository);

  Future<UserEntity?> call(String email, String password) {
    return repository.login(email, password);
  }
}
