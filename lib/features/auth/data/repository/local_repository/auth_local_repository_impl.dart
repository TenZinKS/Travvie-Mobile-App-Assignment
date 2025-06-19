import '../../../domain/entity/user_entity.dart';
import '../../../domain/repository/auth_local_repository.dart';
import '../../data_source/local_datasource/auth_local_datasource.dart';
import '../../model/user_model.dart';

class AuthLocalRepositoryImpl implements AuthLocalRepository {
  final AuthLocalDataSource local;

  AuthLocalRepositoryImpl(this.local);

  @override
  Future<void> register(UserEntity user) {
    return local.registerUser(UserModel(
      email: user.email,
      password: user.password,
    ));
  }

  @override
  Future<UserEntity?> login(String email, String password) async {
    final model = await local.loginUser(email, password);
    return model != null
        ? UserEntity(email: model.email, password: model.password)
        : null;
  }

  @override
  Future<void> logout() => local.logoutUser();

  @override
  String? getCurrentUserEmail() => local.getCurrentUserEmail();
}
