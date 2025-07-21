import 'package:dartz/dartz.dart';
import 'package:travvie/core/error/failure.dart';
import 'package:travvie/features/auth/domain/repository/auth_remote_repository.dart';

class ChangePassword {
  final AuthRemoteRepository repository;

  ChangePassword(this.repository);

  Future<Either<Failure, void>> call({
    required String userId,
    required String currentPassword,
    required String newPassword,
  }) {
    return repository.changePassword(
      id: userId,
      currentPassword: currentPassword,
      newPassword: newPassword,
    );
  }
}
