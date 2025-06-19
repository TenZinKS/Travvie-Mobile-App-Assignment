import 'package:travvie/features/auth/domain/entity/user_entity.dart';
import 'package:travvie/features/auth/domain/repository/auth_local_repository.dart';


class RegisterUser {
  final AuthLocalRepository repository;

  RegisterUser(this.repository);

  Future<void> call(UserEntity user) {
    return repository.register(user);
  }
}
