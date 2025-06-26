import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:travvie/app/constant/hive_table_constants.dart';
import 'package:travvie/features/auth/data/model/user_model.dart';

class HiveService {
  late Box<UserModel> _usersBox;
  late Box<String> _sessionBox;

  /// Initialize Hive
  Future<void> init() async {
    final dir = await getApplicationDocumentsDirectory();
    Hive.init(dir.path);

    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(UserModelAdapter());
    }

    _usersBox = await Hive.openBox<UserModel>(HiveTableConstants.usersBox);
    _sessionBox = await Hive.openBox<String>(HiveTableConstants.sessionBox);
  }

  /// Save data
  Future<void> save<T>(String boxName, String key, T value) async {
    final box = _getBox<T>(boxName);
    await box.put(key, value);
  }

  /// Read data
  Future<T?> read<T>(String boxName, String key) async {
    final box = _getBox<T>(boxName);
    return box.get(key);
  }

  /// Delete key
  Future<void> delete<T>(String boxName, String key) async {
    final box = _getBox<T>(boxName);
    await box.delete(key);
  }

  /// Check if key exists
  Future<bool> containsKey<T>(String boxName, String key) async {
    final box = _getBox<T>(boxName);
    return box.containsKey(key);
  }

  /// Get cached box
  Box<T> _getBox<T>(String boxName) {
    if (boxName == HiveTableConstants.usersBox && T == UserModel) {
      return _usersBox as Box<T>;
    } else if (boxName == HiveTableConstants.sessionBox && T == String) {
      return _sessionBox as Box<T>;
    } else {
      throw HiveError("Unsupported or uninitialized box: $boxName");
    }
  }

  /// Clear boxes
  Future<void> clearAll() async {
    await _usersBox.clear();
    await _sessionBox.clear();
  }

  /// Seed dummy data
  Future<void> seedDummyUser() async {
    const email = 'demo@travvie.com';
    const password = '123456';

    if (!_usersBox.containsKey(email)) {
      final demoUser = UserModel(email: email, password: password);
      await _usersBox.put(email, demoUser);
      print('[Hive] Dummy user created');
    } else {
      print('[Hive] Dummy user already exists');
    }
  }

  /// Debug print
  Future<void> debugPrintUsers() async {
    for (var key in _usersBox.keys) {
      final user = _usersBox.get(key);
      print('[User] $key → ${user?.email} / ${user?.password}');
    }
  }
}
