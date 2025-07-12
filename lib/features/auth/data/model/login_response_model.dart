import 'package:travvie/features/auth/domain/entity/login_response_entity.dart';
import 'package:travvie/features/auth/domain/entity/user_entity.dart';

class LoginResponseModel {
  final String token;
  final UserEntity user;

  LoginResponseModel({
    required this.token,
    required this.user,
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    final userJson = json['user'] as Map<String, dynamic>;

    return LoginResponseModel(
      token: json['token'] as String,
      user: UserEntity(
        id: userJson['id'] ?? '',
        email: userJson['email'] ?? '',
        password: '', // backend does not return password
        profilePic: userJson['profilePic'] ?? '',
        isAdmin: userJson['isAdmin'] ?? false,
      ),
    );
  }

  LoginResponseEntity toEntity() {
    return LoginResponseEntity(
      token: token,
      user: user,
    );
  }
}
