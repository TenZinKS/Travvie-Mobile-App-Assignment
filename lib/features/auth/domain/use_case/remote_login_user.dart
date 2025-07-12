import 'package:dartz/dartz.dart';
import 'package:travvie/core/error/failure.dart';
import 'package:travvie/features/auth/domain/entity/login_response_entity.dart';
import 'package:travvie/features/auth/domain/repository/auth_remote_repository.dart';

class RemoteLoginUser {
  final AuthRemoteRepository repository;

  RemoteLoginUser(this.repository);

  Future<Either<Failure, LoginResponseEntity>> call({
    required String email,
    required String password,
  }) async {
    return await repository.login(email, password);
  }
}
