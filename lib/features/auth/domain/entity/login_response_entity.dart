import 'package:travvie/features/auth/domain/entity/user_entity.dart';

class LoginResponseEntity {
  final String token;
  final UserEntity user;

  LoginResponseEntity({
    required this.token,
    required this.user,
  });
}
