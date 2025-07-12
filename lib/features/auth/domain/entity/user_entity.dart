import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String id;
  final String email;
  final String password;
  final String profilePic;
  final bool isAdmin;

  const UserEntity({
    required this.id,
    required this.email,
    required this.password,
    required this.profilePic,
    required this.isAdmin,
  });

  @override
  List<Object?> get props => [id, email, password, profilePic, isAdmin];
}
