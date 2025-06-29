import 'package:travvie/core/network/hive_service.dart';
import 'package:travvie/app/constant/hive_table_constants.dart';
import 'package:travvie/features/trip/data/model/trip_model.dart';

abstract class LocalTripDataSource {
  Future<void> addTrip(TripModel trip);
  Future<List<TripModel>> getAllTrips();
  Future<void> deleteTrip(String tripId);
  Future<void> updateTrip(TripModel trip);
}

class LocalTripDataSourceImpl implements LocalTripDataSource {
  final HiveService hive;

  LocalTripDataSourceImpl(this.hive);

  @override
  Future<void> addTrip(TripModel trip) async {
    final userEmail = hive.getCurrentUserEmail();
    await hive.save<TripModel>(
      "${HiveTableConstants.tripsBox}_$userEmail",
      trip.id,
      trip,
    );
  }

  @override
  Future<List<TripModel>> getAllTrips() async {
    final userEmail = hive.getCurrentUserEmail();
    return await hive.getAll<TripModel>(
      "${HiveTableConstants.tripsBox}_$userEmail",
    );
  }

  @override
  Future<void> deleteTrip(String tripId) async {
    final userEmail = hive.getCurrentUserEmail();
    await hive.delete<TripModel>(
      "${HiveTableConstants.tripsBox}_$userEmail",
      tripId,
    );
  }

  @override
  Future<void> updateTrip(TripModel trip) async {
    final userEmail = hive.getCurrentUserEmail();
    await hive.save<TripModel>(
      "${HiveTableConstants.tripsBox}_$userEmail",
      trip.id,
      trip,
    );
  }
}
