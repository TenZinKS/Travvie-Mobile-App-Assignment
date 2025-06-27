import '../entity/trip_entity.dart';

abstract class TripRepository {
  Future<void> addTrip(TripEntity trip);
  Future<List<TripEntity>> getAllTrips();
  Future<void> deleteTrip(String id);
  Future<void> updateTrip(TripEntity trip);
}
