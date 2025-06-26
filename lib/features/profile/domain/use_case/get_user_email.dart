import 'package:dartz/dartz.dart';
import 'package:travvie/core/error/failure.dart';
import 'package:travvie/features/auth/domain/repository/auth_local_repository.dart';

class GetUserEmail {
  final AuthLocalRepository repository;

  GetUserEmail(this.repository);

  Future<Either<Failure, String>> call() async {
    try {
      final email = repository.getCurrentUserEmail();
      if (email == null || email.isEmpty) {
        return Left(LocalDatabaseFailure(message: 'No user logged in'));
      }
      return Right(email);
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }
}
