import 'package:hive_flutter/hive_flutter.dart';
import '../../domain/entity/user_entity.dart';

part 'user_model.g.dart';

@HiveType(typeId: 0)
class UserModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String email;

  @HiveField(2)
  final String password;

  @HiveField(3)
  final String profilePic;

  @HiveField(4)
  final bool isAdmin;

  UserModel({
    required this.id,
    required this.email,
    required this.password,
    required this.profilePic,
    required this.isAdmin,
  });

  factory UserModel.fromEntity(UserEntity entity) {
    return UserModel(
      id: entity.id,
      email: entity.email,
      password: entity.password,
      profilePic: entity.profilePic,
      isAdmin: entity.isAdmin,
    );
  }

  UserEntity toEntity() {
    return UserEntity(
      id: id,
      email: email,
      password: password,
      profilePic: profilePic,
      isAdmin: isAdmin,
    );
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json["id"] as String? ?? '',
      email: json["email"] as String? ?? '',
      password: json["password"] as String? ?? '',
      profilePic: json["profilePic"] as String? ?? '',
      isAdmin: json["isAdmin"] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "email": email,
      "password": password,
      "profilePic": profilePic,
      "isAdmin": isAdmin,
    };
  }

  UserModel copyWith({
    String? id,
    String? email,
    String? password,
    String? profilePic,
    bool? isAdmin,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      password: password ?? this.password,
      profilePic: profilePic ?? this.profilePic,
      isAdmin: isAdmin ?? this.isAdmin,
    );
  }
}
