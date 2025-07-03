import 'package:dartz/dartz.dart';
import 'package:travvie/core/error/failure.dart';
import 'package:travvie/features/auth/domain/entity/user_entity.dart';

abstract class AuthRemoteRepository {
  Future<Either<Failure, String>> login(
      String email,
      String password,
  );

  Future<Either<Failure, void>> register(UserEntity user);
}
