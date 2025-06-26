import 'package:dartz/dartz.dart';
import 'package:travvie/core/error/failure.dart';
import 'package:travvie/features/auth/domain/entity/user_entity.dart';
import 'package:travvie/features/auth/domain/repository/auth_local_repository.dart';

class LoginUser {
  final AuthLocalRepository repository;

  LoginUser(this.repository);

  Future<Either<Failure, UserEntity>> call(String email, String password) async {
    try {
      final user = await repository.login(email, password);
      if (user == null) {
        return Left(LocalDatabaseFailure(message: "Invalid email or password"));
      }
      return Right(user);
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }
}
