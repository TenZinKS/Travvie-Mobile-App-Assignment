import 'package:dartz/dartz.dart';
import 'package:travvie/core/error/failure.dart';
import 'package:travvie/features/auth/domain/entity/login_response_entity.dart';
import 'package:travvie/features/auth/domain/entity/user_entity.dart';

abstract class AuthRemoteRepository {
  Future<Either<Failure, LoginResponseEntity>> login(String email, String password);
  Future<Either<Failure, void>> register(UserEntity user);

  /// ✅ New
  Future<Either<Failure, void>> deleteUserById(String userId);
}
