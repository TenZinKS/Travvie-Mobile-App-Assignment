import 'package:hive_flutter/hive_flutter.dart';
import '../../domain/entity/user_entity.dart';

part 'user_model.g.dart';

@HiveType(typeId: 0)
class UserModel extends HiveObject {
  @HiveField(0)
  final String email;

  @HiveField(1)
  final String password;

  UserModel({
    required this.email,
    required this.password,
  });

  factory UserModel.fromEntity(UserEntity entity) {
    return UserModel(
      email: entity.email.trim(),
      password: entity.password.trim(),
    );
  }

  UserEntity toEntity() {
    return UserEntity(
      email: email.trim(),
      password: password.trim(),
    );
  }

  UserModel copyWith({
    String? email,
    String? password,
  }) {
    return UserModel(
      email: email ?? this.email,
      password: password ?? this.password,
    );
  }
}
