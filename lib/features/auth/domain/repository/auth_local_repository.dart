import 'package:dartz/dartz.dart';
import 'package:travvie/core/error/failure.dart';
import '../entity/user_entity.dart';

abstract class AuthLocalRepository {
  Future<void> register(UserEntity user);
  Future<UserEntity?> login(String email, String password);
  Future<void> logout();

  /// Returns currently logged in user's email
  String? getCurrentUserEmail();

  /// Returns the full UserEntity of the current user (needed to access ID)
  UserEntity? getCurrentUser();

  /// Changes password of the user
  Future<Either<Failure, void>> changePassword({
    required String email,
    required String currentPassword,
    required String newPassword,
    bool isForgotPassword,
  });
}
