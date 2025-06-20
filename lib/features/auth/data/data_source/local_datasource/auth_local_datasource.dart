import 'package:hive/hive.dart';
import 'package:travvie/app/constant/hive_table_constants.dart';
import '../../model/user_model.dart';

abstract class AuthLocalDataSource {
  Future<void> registerUser(UserModel user);
  Future<UserModel?> loginUser(String email, String password);
  Future<void> logoutUser();
  String? getCurrentUserEmail();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  @override
  Future<void> registerUser(UserModel user) async {
    final box = await Hive.openBox<UserModel>(HiveTableConstants.usersBox);

    if (box.containsKey(user.email.trim())) {
      throw Exception('User already exists');
    }

    await box.put(user.email.trim(), user);
  }

  @override
  Future<UserModel?> loginUser(String email, String password) async {
    final box = await Hive.openBox<UserModel>(HiveTableConstants.usersBox);
    final user = box.get(email.trim());

    if (user != null && user.password == password.trim()) {
      final sessionBox = await Hive.openBox(HiveTableConstants.sessionBox);
      await sessionBox.put(HiveTableConstants.currentUserEmail, user.email);
      return user;
    }

    return null;
  }

  @override
  Future<void> logoutUser() async {
    final sessionBox = await Hive.openBox(HiveTableConstants.sessionBox);
    await sessionBox.delete(HiveTableConstants.currentUserEmail);
  }

  @override
  String? getCurrentUserEmail() {
    final sessionBox = Hive.box(HiveTableConstants.sessionBox);
    final result = sessionBox.get(HiveTableConstants.currentUserEmail);
    return result is String ? result : null;
  }
}
