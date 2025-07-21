import 'package:travvie/features/auth/domain/repository/auth_remote_repository.dart';

class DeleteUser {
  final AuthRemoteRepository repository;

  DeleteUser(this.repository);

  Future<void> call(String id) async {
    await repository.deleteUserById(id);
  }
}
