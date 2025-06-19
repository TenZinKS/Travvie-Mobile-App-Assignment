import 'package:hive/hive.dart';
import '../../model/user_model.dart';

abstract class AuthLocalDataSource {
  Future<void> registerUser(UserModel user);
  Future<UserModel?> loginUser(String email, String password);
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  static const String userBoxName = 'usersBox';

  @override
  Future<void> registerUser(UserModel user) async {
    final box = await Hive.openBox<UserModel>(userBoxName);
    await box.put(user.email, user); // key: email
  }

  @override
  Future<UserModel?> loginUser(String email, String password) async {
    final box = await Hive.openBox<UserModel>(userBoxName);
    final user = box.get(email);
    if (user != null && user.password == password) {
      return user;
    }
    return null;
  }
}
