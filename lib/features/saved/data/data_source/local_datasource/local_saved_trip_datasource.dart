
import 'package:hive_flutter/hive_flutter.dart';
import 'package:travvie/app/constant/hive_table_constants.dart';
import 'package:travvie/features/saved/data/model/saved_trip_model.dart';

abstract class LocalSavedTripDataSource {
  Future<void> addSavedTrip(SavedTripModel trip);
  Future<List<SavedTripModel>> getAllSavedTrips();
  Future<void> deleteSavedTrip(String id);
}

class LocalSavedTripDataSourceImpl implements LocalSavedTripDataSource {
  @override
  Future<void> addSavedTrip(SavedTripModel trip) async {
    final box = await Hive.openBox<SavedTripModel>(HiveTableConstants.savedTripsBox);
    await box.put(trip.id, trip);
  }

  @override
  Future<List<SavedTripModel>> getAllSavedTrips() async {
    final box = await Hive.openBox<SavedTripModel>(HiveTableConstants.savedTripsBox);
    return box.values.toList();
  }

  @override
  Future<void> deleteSavedTrip(String id) async {
    final box = await Hive.openBox<SavedTripModel>(HiveTableConstants.savedTripsBox);
    await box.delete(id);
  }
}
