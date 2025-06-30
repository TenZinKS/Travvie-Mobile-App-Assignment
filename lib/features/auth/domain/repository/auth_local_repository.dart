import 'package:dartz/dartz.dart';
import 'package:travvie/core/error/failure.dart';

import '../entity/user_entity.dart';

abstract class AuthLocalRepository {
  Future<void> register(UserEntity user);
  Future<UserEntity?> login(String email, String password);
  Future<void> logout();
  String? getCurrentUserEmail();

  Future<Either<Failure, void>> changePassword({
    required String email,
    required String currentPassword,
    required String newPassword,
    bool isForgotPassword,
  });
}

