import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import '../../app/constant/hive_table_constants.dart';
import '../../features/auth/data/model/user_model.dart';

class HiveService {
  /// Initialize Hive and open required boxes
  Future<void> init() async {
    final dir = await getApplicationDocumentsDirectory();
    final path = '${dir.path}/travvie.db';

    Hive.init(path);

    // ✅ Register Hive adapters only once
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(UserModelAdapter());
    }

    // Open commonly used boxes
    await Hive.openBox<UserModel>(HiveTableConstants.usersBox);
    await Hive.openBox(HiveTableConstants.sessionBox);
  }

  /// Save a value to a typed box
  Future<void> save<T>(String boxName, String key, T value) async {
    final box = await openBox<T>(boxName);
    await box.put(key, value);
  }

  /// Read a value from a typed box
  Future<T?> read<T>(String boxName, String key) async {
    final box = await openBox<T>(boxName);
    return box.get(key);
  }

  /// Delete a key from a box
  Future<void> delete<T>(String boxName, String key) async {
    final box = await openBox<T>(boxName);
    await box.delete(key);
  }

  /// Check if a key exists in a box
  Future<bool> containsKey<T>(String boxName, String key) async {
    final box = await openBox<T>(boxName);
    return box.containsKey(key);
  }

  /// Open a typed Hive box
  Future<Box<T>> openBox<T>(String boxName) async {
    if (!Hive.isBoxOpen(boxName)) {
      return await Hive.openBox<T>(boxName);
    }
    return Hive.box<T>(boxName);
  }

  /// Close Hive safely
  Future<void> close() async {
    await Hive.close();
  }

  /// Clear all local Hive storage (for dev/test only)
  Future<void> clearAll() async {
    await Hive.deleteFromDisk();
  }

  /// Debug print keys/values from any box
  Future<void> debugPrintBox(String boxName) async {
    final box = await Hive.openBox(boxName);
    print('[Hive Debug] Box: $boxName');
    for (var key in box.keys) {
      print('→ $key = ${box.get(key)}');
    }
  }

  /// Seed a dummy user for development/testing
  Future<void> seedDummyUser() async {
    final box = await openBox<UserModel>(HiveTableConstants.usersBox);

    const email = 'demo@travvie.com';
    const password = '123456';

    if (!box.containsKey(email)) {
      final demoUser = UserModel(email: email, password: password);
      await box.put(email, demoUser);
      print('[Hive] Dummy user created: $email / $password');
    } else {
      print('[Hive] Dummy user already exists');
    }
  }
}
