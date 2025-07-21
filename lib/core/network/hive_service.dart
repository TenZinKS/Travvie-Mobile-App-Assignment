import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:travvie/app/constant/hive_table_constants.dart';
import 'package:travvie/features/auth/data/model/user_model.dart';
import 'package:travvie/features/trip/data/model/trip_model.dart';
import 'package:travvie/features/saved/data/model/saved_trip_model.dart';

class HiveService {
  late Box<UserModel> _usersBox;
  late Box<String> _sessionBox;

  Box<TripModel>? _tripsBox;
  Box<SavedTripModel>? _savedTripsBox;

  /// Initialize Hive (call once in main)
  Future<void> init() async {
    final dir = await getApplicationDocumentsDirectory();
    Hive.init(dir.path);

    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(UserModelAdapter());
    }
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(TripModelAdapter());
    }
    if (!Hive.isAdapterRegistered(2)) {
      Hive.registerAdapter(SavedTripModelAdapter());
    }

    _usersBox = await Hive.openBox<UserModel>(HiveTableConstants.usersBox);
    _sessionBox = await Hive.openBox<String>(HiveTableConstants.sessionBox);

    print('[Hive] Core initialization complete.');
  }

  /// Open trip/saved trip boxes for the logged-in user
  Future<void> openUserBoxes() async {
    final email = getCurrentUserEmail();
    if (email == null) {
      throw Exception("Cannot open boxes: no user logged in.");
    }

    final tripsBoxName = "${HiveTableConstants.tripsBox}_$email";
    final savedTripsBoxName = "${HiveTableConstants.savedTripsBox}_$email";

    _tripsBox = await Hive.openBox<TripModel>(tripsBoxName);
    _savedTripsBox = await Hive.openBox<SavedTripModel>(savedTripsBoxName);

    print('[Hive] User boxes opened for $email');
  }

  /// Save any object into a box
  Future<void> save<T>(String boxName, String key, T value) async {
    final box = _getBox<T>(boxName);
    await box.put(key, value);
  }

  /// Read an object
  Future<T?> read<T>(String boxName, String key) async {
    final box = _getBox<T>(boxName);
    return box.get(key);
  }

  /// Delete a key
  Future<void> delete<T>(String boxName, String key) async {
    final box = _getBox<T>(boxName);
    await box.delete(key);
  }

  /// Check if key exists
  Future<bool> containsKey<T>(String boxName, String key) async {
    final box = _getBox<T>(boxName);
    return box.containsKey(key);
  }

  /// Get all values
  Future<List<T>> getAll<T>(String boxName) async {
    final box = _getBox<T>(boxName);
    return box.values.toList().cast<T>();
  }

  /// Internal box getter
  Box<T> _getBox<T>(String boxName) {
    if (boxName == HiveTableConstants.usersBox && T == UserModel) {
      return _usersBox as Box<T>;
    } else if (boxName == HiveTableConstants.sessionBox && T == String) {
      return _sessionBox as Box<T>;
    } else if (boxName.startsWith(HiveTableConstants.tripsBox) && T == TripModel) {
      if (_tripsBox == null) throw HiveError("Trips box not opened yet.");
      return _tripsBox as Box<T>;
    } else if (boxName.startsWith(HiveTableConstants.savedTripsBox) && T == SavedTripModel) {
      if (_savedTripsBox == null) throw HiveError("Saved trips box not opened yet.");
      return _savedTripsBox as Box<T>;
    } else {
      throw HiveError("Unsupported box or type: $boxName");
    }
  }

  /// Clear user-specific boxes
  Future<void> clearUserData() async {
    await _tripsBox?.clear();
    await _savedTripsBox?.clear();
  }

  /// Clear global session/user boxes
  Future<void> clearGlobalData() async {
    await _usersBox.clear();
    await _sessionBox.clear();
  }

  /// Wipe everything
  Future<void> clearAll() async {
    await clearUserData();
    await clearGlobalData();
  }


  /// Read current user
  String? getCurrentUserEmail() {
    return _sessionBox.get(HiveTableConstants.currentUserEmail);
  }

  /// Debug trip logs
  Future<void> debugPrintTrips() async {
    for (var key in _tripsBox?.keys ?? []) {
      final trip = _tripsBox?.get(key);
      print('[Trip] $key → ${trip?.from} | ${trip?.to}');
    }
  }

  /// Debug saved trip logs
  Future<void> debugPrintSavedTrips() async {
    for (var key in _savedTripsBox?.keys ?? []) {
      final trip = _savedTripsBox?.get(key);
      print('[SavedTrip] $key → ${trip?.id} | ${trip?.to}');
    }
  }

  /// Open extra user-specific box (for image)
  Future<Box> openUserBox(String email) async {
    final boxName = "${email}_box";
    return Hive.isBoxOpen(boxName)
        ? Hive.box(boxName)
        : await Hive.openBox(boxName);
  }

  /// Save user profile image path
  Future<void> saveProfileImagePath(String email, String imagePath) async {
    final box = await openUserBox(email);
    await box.put('profileImagePath', imagePath);
  }

  /// Get profile image
  Future<String?> getProfileImagePath(String email) async {
    final box = await openUserBox(email);
    return box.get('profileImagePath');
  }

  /// Delete profile image only
  Future<void> deleteProfileImagePath(String email) async {
    final box = await openUserBox(email);
    await box.delete('profileImagePath');
  }

  // ✅ Delete full user account & boxes
  Future<void> deleteUser(String email) async {
  // Delete profile image path box
  final profileBoxName = "${email}_box";
  if (Hive.isBoxOpen(profileBoxName)) {
    await Hive.box(profileBoxName).clear();
    await Hive.box(profileBoxName).close();
  } else if (await Hive.boxExists(profileBoxName)) {
    final box = await Hive.openBox(profileBoxName);
    await box.clear();
    await box.close();
  }

  // Remove user from users box
  await _usersBox.delete(email);

  // Remove session if matches
  if (getCurrentUserEmail() == email) {
    await _sessionBox.delete(HiveTableConstants.currentUserEmail);
  }

  // Handle trip box
  final tripsBoxName = "${HiveTableConstants.tripsBox}_$email";
  if (Hive.isBoxOpen(tripsBoxName)) {
    final box = Hive.box<TripModel>(tripsBoxName);
    await box.clear();
    await box.close();
  } else if (await Hive.boxExists(tripsBoxName)) {
    final box = await Hive.openBox<TripModel>(tripsBoxName);
    await box.clear();
    await box.close();
  }

  // Handle saved trip box
  final savedBoxName = "${HiveTableConstants.savedTripsBox}_$email";
  if (Hive.isBoxOpen(savedBoxName)) {
    final box = Hive.box<SavedTripModel>(savedBoxName);
    await box.clear();
    await box.close();
  } else if (await Hive.boxExists(savedBoxName)) {
    final box = await Hive.openBox<SavedTripModel>(savedBoxName);
    await box.clear();
    await box.close();
  }

  print("[Hive] User '$email' deleted successfully.");
}


}
