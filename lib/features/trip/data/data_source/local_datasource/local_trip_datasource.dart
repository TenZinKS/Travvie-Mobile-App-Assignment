import 'package:hive_flutter/hive_flutter.dart';
import 'package:travvie/features/trip/data/model/trip_model.dart';


abstract class LocalTripDataSource {
  Future<void> addTrip(TripModel trip);
  Future<List<TripModel>> getAllTrips();
  Future<void> deleteTrip(String id);
  Future<void> updateTrip(TripModel trip);
}

class LocalTripDataSourceImpl implements LocalTripDataSource {
  final String boxName = 'tripsBox';

  @override
  Future<void> addTrip(TripModel trip) async {
    final box = await Hive.openBox<TripModel>(boxName);
    await box.put(trip.id, trip);
  }

  @override
  Future<List<TripModel>> getAllTrips() async {
    final box = await Hive.openBox<TripModel>(boxName);
    return box.values.toList();
  }

  @override
  Future<void> deleteTrip(String id) async {
    final box = await Hive.openBox<TripModel>(boxName);
    await box.delete(id);
  }

  @override
  Future<void> updateTrip(TripModel trip) async {
    final box = await Hive.openBox<TripModel>(boxName);
    await box.put(trip.id, trip);
  }
}
