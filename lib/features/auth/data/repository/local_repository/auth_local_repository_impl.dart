import 'package:dartz/dartz.dart';
import 'package:travvie/core/error/failure.dart';
import 'package:travvie/features/auth/data/data_source/local_datasource/auth_local_datasource.dart';
import 'package:travvie/features/auth/data/model/user_model.dart';
import 'package:travvie/features/auth/domain/entity/user_entity.dart';
import 'package:travvie/features/auth/domain/repository/auth_local_repository.dart';

class AuthLocalRepositoryImpl implements AuthLocalRepository {
  final AuthLocalDataSource localDataSource;

  AuthLocalRepositoryImpl(this.localDataSource);

  @override
  Future<void> register(UserEntity user) async {
    final userModel = UserModel.fromEntity(user);
    await localDataSource.registerUser(userModel);
  }

  @override
  Future<UserEntity?> login(String email, String password) async {
    final userModel = await localDataSource.loginUser(
      email.trim(),
      password.trim(),
    );
    return userModel?.toEntity();
  }

  @override
  Future<void> logout() async {
    await localDataSource.logoutUser();
  }

  @override
  String? getCurrentUserEmail() {
    return localDataSource.getCurrentUserEmail();
  }

  /// ✅ Added: Get current logged-in user entity
  @override
  UserEntity? getCurrentUser() {
    final userModel = localDataSource.getCurrentUserModel();
    return userModel?.toEntity();
  }

  @override
  Future<Either<Failure, void>> changePassword({
    required String email,
    required String currentPassword,
    required String newPassword,
    bool isForgotPassword = false,
  }) async {
    try {
      await localDataSource.changePassword(
        email: email,
        currentPassword: currentPassword,
        newPassword: newPassword,
        isForgotPassword: isForgotPassword,
      );
      return const Right(null);
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }
}
