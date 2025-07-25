import 'package:hive_flutter/hive_flutter.dart';

class TokenProvider {
  static Future<String?> getToken() async {
    final box = await Hive.openBox('auth');
    return box.get('token') as String?;
  }

  static Future<String?> getUserId() async {
    final box = await Hive.openBox('auth');
    return box.get('userId') as String?;
  }
}
