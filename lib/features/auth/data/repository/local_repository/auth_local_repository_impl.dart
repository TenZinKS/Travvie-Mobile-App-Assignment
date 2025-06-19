import '../../data_source/local_datasource/auth_local_datasource.dart';
import '../../../domain/entity/user_entity.dart';
import '../../../domain/repository/auth_local_repository.dart';
import '../../model/user_model.dart';

class AuthLocalRepositoryImpl implements AuthLocalRepository {
  final AuthLocalDataSource localDataSource;

  AuthLocalRepositoryImpl(this.localDataSource);

  @override
  Future<void> register(UserEntity user) {
    final userModel = UserModel(email: user.email, password: user.password);
    return localDataSource.registerUser(userModel);
  }

  @override
  Future<UserEntity?> login(String email, String password) async {
    final model = await localDataSource.loginUser(email, password);
    return model != null ? UserEntity(email: model.email, password: model.password) : null;
  }
}
