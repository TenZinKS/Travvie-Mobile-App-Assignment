import 'package:dartz/dartz.dart';
import 'package:travvie/core/error/failure.dart';
import 'package:travvie/features/auth/domain/repository/auth_local_repository.dart';

class ForgotPassword {
  final AuthLocalRepository repository;

  ForgotPassword(this.repository);

  Future<Either<Failure, void>> call({
    required String email,
    required String newPassword,
  }) async {
    return await repository.changePassword(
      email: email,
      currentPassword: "", // ignored for forgot
      newPassword: newPassword,
      isForgotPassword: true,
    );
  }
}
