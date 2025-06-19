import 'package:hive/hive.dart';
import '../../model/user_model.dart';

abstract class AuthLocalDataSource {
  Future<void> registerUser(UserModel user);
  Future<UserModel?> loginUser(String email, String password);
  Future<void> logoutUser();
  String? getCurrentUserEmail();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  static const userBoxName = 'usersBox';
  static const sessionBoxName = 'sessionBox';
  static const currentKey = 'currentUserEmail';

  @override
  Future<void> registerUser(UserModel user) async {
    final box = await Hive.openBox<UserModel>(userBoxName);

    if (box.containsKey(user.email.trim())) {
      throw Exception('User already exists');
    }

    await box.put(user.email.trim(), user);
  }

  @override
  Future<UserModel?> loginUser(String email, String password) async {
    final box = await Hive.openBox<UserModel>(userBoxName);
    final user = box.get(email.trim());

    if (user != null && user.password == password.trim()) {
      final sessionBox = await Hive.openBox(sessionBoxName);
      await sessionBox.put(currentKey, user.email);
      return user;
    }

    return null;
  }

  @override
  Future<void> logoutUser() async {
    final sessionBox = await Hive.openBox(sessionBoxName);
    await sessionBox.delete(currentKey);
  }

  @override
  String? getCurrentUserEmail() {
    final sessionBox = Hive.box(sessionBoxName);
    final result = sessionBox.get(currentKey);
    return result is String ? result : null;
  }
}
