import 'package:dartz/dartz.dart';
import 'package:travvie/core/error/failure.dart';
import 'package:travvie/features/auth/domain/entity/user_entity.dart';
import 'package:travvie/features/auth/domain/repository/auth_remote_repository.dart';

class RemoteRegisterUser {
  final AuthRemoteRepository repository;

  RemoteRegisterUser(this.repository);

  Future<Either<Failure, void>> call(UserEntity user) async {
    return await repository.register(user);
  }
}
