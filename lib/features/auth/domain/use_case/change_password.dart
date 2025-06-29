import 'package:dartz/dartz.dart';
import 'package:travvie/core/error/failure.dart';
import 'package:travvie/features/auth/domain/repository/auth_local_repository.dart';

class ChangePassword {
  final AuthLocalRepository repository;

  ChangePassword(this.repository);

  Future<Either<Failure, void>> call({
    required String email,
    required String currentPassword,
    required String newPassword,
  }) {
    return repository.changePassword(
      email: email,
      currentPassword: currentPassword,
      newPassword: newPassword,
    );
  }
}
