import 'package:dartz/dartz.dart';
import 'package:travvie/core/error/failure.dart';
import 'package:travvie/features/auth/domain/entity/user_entity.dart';
import 'package:travvie/features/auth/domain/repository/auth_local_repository.dart';

class RegisterUser {
  final AuthLocalRepository repository;

  RegisterUser(this.repository);

  Future<Either<Failure, void>> call(UserEntity user) async {
    try {
      await repository.register(user);
      return const Right(null);
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }
}
