import 'package:hive_flutter/hive_flutter.dart';
import 'package:travvie/app/constant/hive_table_constants.dart';
import 'package:travvie/core/network/hive_service.dart';
import '../../model/user_model.dart';

abstract class AuthLocalDataSource {
  Future<void> registerUser(UserModel user);
  Future<UserModel?> loginUser(String email, String password);
  Future<void> logoutUser();
  String? getCurrentUserEmail();

  /// Changes a user's password.
  /// [isForgotPassword] = true → skip checking current password.
  Future<void> changePassword({
    required String email,
    required String currentPassword,
    required String newPassword,
    bool isForgotPassword = false,
  });
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final HiveService hive;

  AuthLocalDataSourceImpl(this.hive);

  @override
  Future<void> registerUser(UserModel user) async {
    final exists = await hive.containsKey<UserModel>(
      HiveTableConstants.usersBox,
      user.email.trim(),
    );

    // Instead of throwing, we update existing user
    if (exists) {
      // Update instead
      await hive.save<UserModel>(
        HiveTableConstants.usersBox,
        user.email.trim(),
        user,
      );
      return;
    }

    await hive.save<UserModel>(
      HiveTableConstants.usersBox,
      user.email.trim(),
      user,
    );
  }

  @override
  Future<UserModel?> loginUser(String email, String password) async {
    final user = await hive.read<UserModel>(
      HiveTableConstants.usersBox,
      email.trim(),
    );

    if (user != null && user.password.trim() == password.trim()) {
      await hive.save<String>(
        HiveTableConstants.sessionBox,
        HiveTableConstants.currentUserEmail,
        user.email.trim(),
      );
      return user;
    }

    return null;
  }

  @override
  Future<void> logoutUser() async {
    await hive.delete<String>(
      HiveTableConstants.sessionBox,
      HiveTableConstants.currentUserEmail,
    );
  }

  @override
  String? getCurrentUserEmail() {
    try {
      final sessionBox = Hive.box<String>(HiveTableConstants.sessionBox);
      return sessionBox.get(HiveTableConstants.currentUserEmail);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> changePassword({
    required String email,
    required String currentPassword,
    required String newPassword,
    bool isForgotPassword = false,
  }) async {
    final user = await hive.read<UserModel>(
      HiveTableConstants.usersBox,
      email.trim(),
    );

    if (user == null) {
      throw Exception("User not found.");
    }

    if (!isForgotPassword) {
      if (user.password.trim() != currentPassword.trim()) {
        throw Exception("Current password does not match.");
      }
    }

    final updatedUser = user.copyWith(password: newPassword.trim());
    await hive.save<UserModel>(
      HiveTableConstants.usersBox,
      email.trim(),
      updatedUser,
    );
  }
}
